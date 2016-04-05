//
//  NotBadScrollView.m
//
//
//  Created by Bruce on 16/2/17.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import "NotBadScrollView.h"

#define kWidth self.frame.size.width
#define kHeight self.frame.size.height
#define kdefaultTimeInterval 2.0
#define cachePath ([NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject stringByAppendingPathComponent:@"NotBadScrollViewImageCache"])

@interface NotBadScrollView ()<UIScrollViewDelegate>

@property(strong,nonatomic) UIScrollView  * scrollView;
@property(strong,nonatomic) UIPageControl  * pageControl;
@property(strong,nonatomic) UILabel  * descriptionLabel;

@property(strong,nonatomic) UIImageView  * leftImageView;

@property(strong,nonatomic) UIImageView  * centerImageView;
///当前显示图片的索引
@property(assign,nonatomic) NSInteger  centerImageIndex;

@property(strong,nonatomic) UIImageView  * rightImageView;

@property(strong,nonatomic) NSTimer  * timer;
///imageArray对应的图片数组
@property(strong,nonatomic) NSMutableArray<UIImage *>  * images;
//内存缓存字典
@property(strong,nonatomic) NSMutableDictionary<NSString *,UIImage *>  *cacheDic;
@end


@implementation NotBadScrollView

#pragma mark 懒加载
-(NSMutableDictionary<NSString *,UIImage *> *)cacheDic{
    if (!_cacheDic) {
        _cacheDic=[NSMutableDictionary dictionary];
    }
    return _cacheDic ;
}

-(NSMutableArray<UIImage *> *)images{
    if (!_images) {
        _images=[NSMutableArray array];
        }
    return _images ;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView=[[UIScrollView alloc]init];
        _scrollView.bounces=NO;
        _scrollView.pagingEnabled=YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate=self;
    }
    return _scrollView ;
}

-(UIImageView *)leftImageView{
    if (!_leftImageView) {
        UIImageView *leftImageView=[[UIImageView alloc]init];
        _leftImageView=leftImageView;
         [_scrollView addSubview:_leftImageView];
    }
    return _leftImageView ;
}

-(UIImageView *)centerImageView{
    if (!_centerImageView) {
        UIImageView *centerImageView=[[UIImageView alloc]init];
        centerImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(centerImageViewDidClick)];
        [centerImageView addGestureRecognizer:tapGestureRecognizer];
        _centerImageView=centerImageView;
        [_scrollView addSubview:_centerImageView];
    }
    return _centerImageView ;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        UIImageView *rightImageView=[[UIImageView alloc]init];
        _rightImageView=rightImageView;
        [_scrollView addSubview:_rightImageView];
        
    }
    return _rightImageView ;
}

-(UILabel *)descriptionLabel{
    if (!_descriptionLabel) {
        _descriptionLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kHeight-20, kWidth, 20)];
        _descriptionLabel.backgroundColor=[UIColor colorWithWhite:0 alpha:0.5];
        _descriptionLabel.hidden=YES;
        _descriptionLabel.textColor=[UIColor whiteColor];
        _descriptionLabel.textAlignment=NSTextAlignmentCenter;
        _descriptionLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_descriptionLabel];
    }
    return _descriptionLabel ;
}

-(UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl=[[UIPageControl alloc]init];
        _pageControl.hidesForSinglePage=YES;
    }
    return _pageControl ;
}

-(NSTimer *)timer{
    if (!_timer) {
        NSTimeInterval timeInterval=self.timeInterval!=0 ? self.timeInterval : kdefaultTimeInterval;

        NSTimer *timer=[NSTimer timerWithTimeInterval:timeInterval target:self selector:@selector(scroll) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        _timer=timer;
    }
    return _timer ;
}

#pragma mark 定时器相关
-(void)startTimer{
    [self addTimer];
}

-(void)pauseTimer{
    [_timer invalidate];
    _timer=nil;
}

-(void)setTimeInterval:(NSTimeInterval)timeInterval{
    _timeInterval=timeInterval;
    
    if (_timer) {
        [self pauseTimer];
    }
    [self startTimer];
}

-(void)addTimer{
    if (_images.count<=1) {
        return;
    }
    [self timer];
}

-(void)setPageDotWithImage:(NSString *)image currentImage:(NSString *)currentImage{
    if (!image || !currentImage ) return;
    
    [self.pageControl setValue:[UIImage imageNamed:currentImage] forKey:@"currentPageImage"];
    [self.pageControl setValue:[UIImage imageNamed:image] forKey:@"pageImage"];
}

-(void)creatImages{
    NSInteger i=0;
    for (NSString *string in _imageArray) {
        if ([string hasPrefix:@"http:"]||[string hasPrefix:@"https:"]) {
            [self.images addObject:[UIImage imageNamed:@"placeholder"]];
            [self downloadImage:i];
        }else{
            [self.images addObject:[UIImage imageNamed:string]];
        }
        i++;
    }
}

-(void)creatFile{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:cachePath]) {
        [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

-(void)cleanImageCache{
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cachePath error:NULL];
    for (NSString *fileName in contents) {
        NSLog(@"%@",fileName);
        [[NSFileManager defaultManager] removeItemAtPath:[cachePath stringByAppendingPathComponent:fileName] error:nil];
    }
}

-(void)downloadImage:(NSInteger)index{
    NSString *key=_imageArray[index];
    //先从内存缓存中区
    UIImage *image=self.cacheDic[key];
    if (image) {
        _images[index]=image;
    }
    else{//从磁盘缓存中取
        [self creatFile];
        NSString *path = [cachePath stringByAppendingPathComponent:[key lastPathComponent]];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data) {
            image = [UIImage imageWithData:data];
            _images[index] = image;
            [self.cacheDic setObject:image forKey:key];
        }else{//从网络请求
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSURL *url=[NSURL URLWithString:key];
                NSData *imageData=[NSData dataWithContentsOfURL:url];
                if (imageData) {
                    UIImage *downloadImage = [UIImage imageWithData:imageData];
                    [self.cacheDic setObject:downloadImage forKey:key];
                dispatch_async(dispatch_get_main_queue(), ^{
                        self.images[index] = downloadImage;
                    });
                    [imageData writeToFile:path atomically:YES];
                }
            });
        }
    }
}

-(void)setImageArray:(NSArray<NSString *> *)imageArray{
    _imageArray=imageArray;
    [self creatImages];
    if (_images.count>1) {
        self.leftImageView.image=_images.lastObject;
        self.rightImageView.image=_images[1];
    }else{
        self.scrollView.scrollEnabled=NO;
    }
    self.centerImageIndex=0;
    self.centerImageView.image=_images[0];
    self.pageControl.numberOfPages=_images.count;
    
}

-(void)setDescriptionArray:(NSArray<NSString *> *)descriptionArray{
    _descriptionArray=descriptionArray;
    
    if (descriptionArray && descriptionArray.count > 0) {
        if (descriptionArray.count < _images.count) {
            NSMutableArray *descriptions = [NSMutableArray arrayWithArray:descriptionArray];
            for (NSInteger i = descriptionArray.count; i < _images.count; i++) {
                [descriptions addObject:@""];
            }
            _descriptionArray = descriptions;
        }
        self.descriptionLabel.hidden = NO;
        _descriptionLabel.text = _descriptionArray.firstObject;
    }
    self.pageControl.center=CGPointMake(0.9*kWidth-10*(_descriptionArray.count-1), kHeight-30);
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    self.scrollView.frame = CGRectMake(0, 0, kWidth, kHeight);
    self.scrollView.contentSize=CGSizeMake(kWidth*3, kHeight);
    self.scrollView.contentOffset = CGPointMake(kWidth, 0);
    self.scrollView.contentInset=UIEdgeInsetsMake(0, 0, 0, 0);
    self.pageControl.center=CGPointMake(self.center.x, kHeight*0.9);
    self.centerImageView.frame=CGRectMake(kWidth, 0, kWidth, kHeight);
    self.leftImageView.frame=CGRectMake(0, 0, kWidth, kHeight);
    self.rightImageView.frame=CGRectMake(2*kWidth, 0, kWidth, kHeight);
}

#pragma mark 构造方法

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

-(instancetype)initWithImageArray:(NSArray<NSString *> *)imageArray{
    if (self=[self initWithFrame:CGRectNull imageArray:imageArray]) {
    }
    
    return self;
}
+(instancetype)scrollViewWithImageArray:(NSArray<NSString *> *)imageArray{
    return [[self alloc]initWithImageArray:imageArray];
}

-(instancetype)initWithFrame:(CGRect)frame imageArray:(NSArray<NSString *> *)imageArray{
    if (self=[self initWithFrame:frame]) {
        self.imageArray=imageArray;
        }
        return self;
}
+(instancetype)scrollViewWithFrame:(CGRect)frame imageArray:(NSArray<NSString *> *)imageArray{
  return [[self alloc]initWithFrame:frame imageArray:imageArray];
}

///核心算法，实现滚动图片的效果
-(void)reloadImage{
    
    NSInteger leftImageIndex,rightImageIndex;
    CGFloat currentContentOffsetX = _scrollView.contentOffset.x;
    
    if (currentContentOffsetX>kWidth) {
        //从右往左
        _centerImageIndex=(_centerImageIndex+1)%_images.count;
        self.pageControl.currentPage=self.pageControl.currentPage+1;
    }else if(currentContentOffsetX<kWidth) {
        //从左往右
        _centerImageIndex=(_centerImageIndex+_images.count-1)%_images.count;
        self.pageControl.currentPage=self.pageControl.currentPage-1;
    }
    _centerImageView.image=self.images[_centerImageIndex];
    
    leftImageIndex=(_centerImageIndex+_images.count-1)%_images.count;
    rightImageIndex=(_centerImageIndex+1)%_images.count;
    
    _leftImageView.image=self.images[leftImageIndex];
    _rightImageView.image=_images[rightImageIndex];
    _scrollView.contentOffset=CGPointMake(kWidth, 0);
    self.pageControl.currentPage=_centerImageIndex;
    
    if (_descriptionArray[_centerImageIndex].length==0) {
        self.descriptionLabel.hidden=YES;
    }else{
        self.descriptionLabel.hidden=NO;
    }
    self.descriptionLabel.text=_descriptionArray[_centerImageIndex];
    
}

-(void)scroll{
    [self.scrollView setContentOffset:CGPointMake(2*kWidth, 0) animated:YES];
}

-(void)centerImageViewDidClick{
    if ([self.delegate respondsToSelector:@selector(notBadScrollViewDidClick:imageIndex:)]) {
        [self.delegate notBadScrollViewDidClick:self imageIndex:self.centerImageIndex];
    }
}

#pragma UIScrollViewDelegate

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self pauseTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self reloadImage];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self reloadImage]; 
}

@end
