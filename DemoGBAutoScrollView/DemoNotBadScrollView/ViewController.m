//
//  ViewController.m
//  test
//
//  Created by gxy on 16/2/17.
//  Copyright (c) 2016年 gxy. All rights reserved.
//

#import "ViewController.h"
#import "GBAutoScrollView.h"
@interface ViewController ()<GBAutoScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    NSArray *arr=@[@"http://www.5068.com/u/faceimg/20140725173411.jpg",@"1.jpg", @"http://file27.mafengwo.net/M00/52/F2/wKgB6lO_PTyAKKPBACID2dURuk410.jpeg", @"http://file27.mafengwo.net/M00/B2/12/wKgB6lO0ahWAMhL8AAV1yBFJDJw20.jpeg",@"2.jpg"];
    
    //第一种创建方式
   // NotBadScrollView * imagesView=[[NotBadScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width*9/16)];
   //  imagesView.imageArray=arr;
    
    //第二种
//    NotBadScrollView * imagesView=[[NotBadScrollView alloc]init];
//    imagesView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width*9/16);
    
    //第三种
    GBAutoScrollView * imagesView=[GBAutoScrollView scrollViewWithImageArray:arr];
    imagesView.frame=CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width*9/16);
    
    //第四种
//     NotBadScrollView * imagesView=[[NotBadScrollView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width*9/16) imageArray:arr];
    
    //[imagesView startTimer];
   // imagesView.timeInterval=1;
    //imagesView.descriptionArray=@[@"one",@"two",@"three"];
    imagesView.delegate=self;
  //  [imagesView setPageDotWithImage:@"other" currentImage:@"current"];
    [self.view addSubview:imagesView];
    
}

-(void)notBadScrollViewDidClick:(GBAutoScrollView *)scrollView imageIndex:(NSInteger)index{
    NSLog(@"%ld",index);
}
@end
