//
//  ViewController.m
//  ImageCarousel
//
//  Created by 刘殿阁 on 16/7/1.
//  Copyright © 2016年 mac. All rights reserved.
//

#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define ImageCount 3
#define ImageDataCount 4
#import "ViewController.h"
@interface ViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (strong, nonatomic) UIPageControl*  pageControl;
//当前图片的index
@property (assign, nonatomic) NSInteger currentIndex;
//定时器
@property (strong, nonatomic) NSTimer* timer;
//左边的imageView
@property (strong, nonatomic) UIImageView*  leftImageView;
//右边的imageView
@property (strong, nonatomic) UIImageView*  rightImageView;
//中间的imageView
@property (strong, nonatomic) UIImageView*  centerImageView;

@end
@implementation ViewController
#pragma mark -  懒加载
-(UIPageControl*)pageControl
{
    if (_pageControl == nil) {
        self.pageControl = [[UIPageControl alloc]init];
        [self.view addSubview:self.pageControl];
    }
    return _pageControl;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化scrollerView
    [self setUpScrollerView];
    //初始化pageController
    [self setUpPageControl];
    //加载默认的视图
    [self loadDefaultImage];
   
    
}
/**
 *  初始化scrollerView
 */
-(void)setUpScrollerView
{
    self.scrollerView.delegate = self;
    self.scrollerView.bounces = YES;
    self.scrollerView.pagingEnabled = YES;
    self.scrollerView.contentSize = CGSizeMake(SCREEN_WIDTH* ImageCount, 0);
    [self.scrollerView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
    
 
}
/**
 *  初始化pageController
 */
-(void)setUpPageControl
{
    self.pageControl.numberOfPages = ImageDataCount;
    [self.pageControl setValue:[UIImage imageNamed:@"liudiange"] forKeyPath:@"_currentPageImage"];
    [self.pageControl setValue:[UIImage imageNamed:@"diangeliu"] forKeyPath:@"_pageImage"];
    CGSize pageControlSize = [self.pageControl sizeForNumberOfPages:ImageDataCount];
    self.pageControl.frame = CGRectMake((SCREEN_WIDTH - pageControlSize.width)/2.0, SCREEN_HEIGHT - 200, pageControlSize.width, pageControlSize.height);
}
/**
 *  加载默认的视图
 */
-(void)loadDefaultImage
{
    UIImageView* leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",(ImageDataCount-1)]];
    [self.scrollerView addSubview:leftImageView];
    self.leftImageView = leftImageView;
    
    UIImageView* centerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",0]];
    [self.scrollerView addSubview:centerImageView];
    self.centerImageView = centerImageView;
    
    UIImageView* rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",1]];
    [self.scrollerView addSubview:rightImageView];
    self.rightImageView = rightImageView;
    
    //设置默认的页数何设置pagecontrol
    self.currentIndex = 0;
    self.pageControl.currentPage = 0;
    //创建定时器
    [self setUpTimer];

}
/**
 *  创建定时器
 */
-(void)setUpTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(timerChanged) userInfo:nil repeats:YES];
}
/**
 *  定时器改变的事件
 */
-(void)timerChanged
{
  
      //设置scrollerview偏移量改变
    [self.scrollerView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:NO];
    [self resetImage];
    self.pageControl.currentPage = self.currentIndex;
    [self.scrollerView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
}
#pragma mark - delegate
/**
 * 开始拖动的方法
 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
     //停止定时器
    [self.timer invalidate];
}
/**
 * 已经开始减速的方法
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //重新设置图片
    [self resetImage];
    self.pageControl.currentPage = self.currentIndex;
    //将scrollerview重新回到原来的位置
    [scrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:NO];
     //开始定时器
    [self setUpTimer];
}
/**
 * 已经结束拖拽
 */
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   
}
#pragma mark -  其它事件的响应
/**
 *  重新设置图片
 */
-(void)resetImage
{
    NSInteger leftIndex ,rightIndex;
    CGPoint offset =  self.scrollerView.contentOffset;
    if (offset.x > SCREEN_WIDTH) {
        self.currentIndex = (self.currentIndex + 1) % ImageDataCount;
    }else if (offset.x < SCREEN_WIDTH)
    {
        self.currentIndex = (self.currentIndex + ImageDataCount - 1) % ImageDataCount;
    }
    //重新设置左右以及当前显示图片
    self.centerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd",self.currentIndex]];
    leftIndex = (self.currentIndex + ImageDataCount  - 1) % ImageDataCount;
    rightIndex = (self.currentIndex + 1) % ImageDataCount;
    self.leftImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd",leftIndex]];
    self.rightImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd",rightIndex]];
}



























@end
