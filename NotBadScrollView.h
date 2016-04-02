//
//  NotBadScrollView.h
//
//
//  Created by Bruce on 16/2/17.
//  Copyright © 2016年 Bruce. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NotBadScrollView;

@protocol NotBadScrollViewDelegate <NSObject>

@optional
///当前图片被点击
-(void)notBadScrollViewDidClick:(nullable NotBadScrollView *)scrollView imageIndex:(NSInteger) index;

@end

@interface NotBadScrollView : UIView

///图片数组(可以是本地，网络或者共存)
@property(strong,nonatomic,nonnull) NSArray<NSString *>  *imageArray;
///图片对应的描述数组
@property(strong,nonatomic,nullable) NSArray<NSString *>  *descriptionArray;

///滚动间隔时间,若设置了此时间，则不需要开启定时器了，否则需要开启定时器
@property(assign,nonatomic) NSTimeInterval timeInterval;

@property(weak,nonatomic) id<NotBadScrollViewDelegate>  delegate;

-(nullable instancetype)initWithFrame:(CGRect)frame imageArray:(nonnull NSArray<NSString *> *)imageArray;
+(nullable instancetype)scrollViewWithFrame:(CGRect)frame imageArray:(nonnull NSArray<NSString *> *)imageArray;


///开启定时器，默认间隔时间为2.0s
-(void)startTimer;
///暂停定时器
-(void)pauseTimer;
///设置pageControl的圆点图片
-(void)setPageDotWithImage:(nullable NSString *)image currentImage:(nullable NSString *)currentImage;
///清除图片缓存
-(void)cleanImageCache;

@end
