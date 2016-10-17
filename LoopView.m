//
//  LoopView.m
//  测试轮播
//
//  Created by 慧流 on 16/10/13.
//  Copyright © 2016年 范博. All rights reserved.

#import "LoopView.h"
@interface LoopView () <UIScrollViewDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic)CGPoint offSet;
@property (nonatomic,strong)NSTimer *repeatingTimer;
@end


@implementation LoopView

- (void)awakeFromNib{
    [super awakeFromNib];
    UIScrollView *scrollView = [[UIScrollView alloc]init];

    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;
    scrollView.userInteractionEnabled = YES;
    scrollView.delegate = self;
    scrollView.tag = 100;
    [self addSubview:scrollView];
    
    UIImageView *currentImageView = [[UIImageView alloc]init];
    currentImageView.image = [UIImage imageNamed:@"1"];
    [scrollView addSubview:currentImageView];
    currentImageView.tag = 102;
    
    UIImageView *nextImageView = [[UIImageView alloc]init];
    nextImageView.image = [UIImage imageNamed:@"2"];
    [scrollView addSubview:nextImageView];
    nextImageView.tag = 103;
    
    UIImageView *preImageView = [[UIImageView alloc]init];
    preImageView.image = [UIImage imageNamed:@"5"];
    [scrollView addSubview:preImageView];
    preImageView.tag = 101;
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = 6;
    pageControl.currentPage = 0;
    pageControl.tag = 104;
    [self addSubview:pageControl];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    
    NSInvocationOperation *peration = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(update:) object:nil];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    [queue addOperation:peration];
}

// 调整按钮的frame最好在这个方法里面
- (void)layoutSubviews
{
    [super layoutSubviews];
    UIPageControl *pageControl = [self viewWithTag:104];
    UIScrollView *scrollview = [self viewWithTag:100];
    UIImageView *currentImageView = [self viewWithTag:102];
    UIImageView *preImageView = [self viewWithTag:101];
    UIImageView *nextImageView = [self viewWithTag:103];
    CGFloat width = self.frame.size.width;
    CGFloat hight = self.frame.size.height;
    scrollview.contentOffset = CGPointMake(width, 0);
    scrollview.frame = CGRectMake(0, 0, width, hight);
    [scrollview setContentSize:CGSizeMake(width * 6, hight)];
    currentImageView.frame = CGRectMake(width, 0, width, hight);
    nextImageView.frame = CGRectMake(width * 2, 0, width, hight);
    preImageView.frame = CGRectMake(0, 0, width, hight);

    pageControl.frame = CGRectMake(self.bounds.size.width/2 - 40, self.bounds.size.height - 100, 80, 20);

}

- (void)update:(NSTimer *)timer{
    CGFloat width = self.frame.size.width;
    _offSet = CGPointMake(width, 0);
    NSTimer *timerSecond = [NSTimer scheduledTimerWithTimeInterval:0.002 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
      self.repeatingTimer = timerSecond;
}

- (void) updateImage{
    UIScrollView *scrollview = [self viewWithTag:100];
    _offSet.x += _offSet.x / 200;
    [scrollview setContentOffset:_offSet animated:YES];
    if (_offSet.x > self.frame.size.width * 2) {
        [self.repeatingTimer invalidate];
        self.repeatingTimer = nil;
    }
}

#pragma mark -UISrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self.timer invalidate];
    [self.repeatingTimer invalidate];
    self.repeatingTimer = nil;
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    self.timer = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(update:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    UIScrollView *scrollview = [self viewWithTag:100];
    UIImageView *currentImageView = [self viewWithTag:102];
    UIImageView *preImageView = [self viewWithTag:101];
    UIImageView *nextImageView = [self viewWithTag:103];
    UIPageControl *pControl = (UIPageControl *)[self viewWithTag:104];
    static int i = 1;
    float offset = scrollview.contentOffset.x;
    if (nextImageView.image == nil || preImageView.image == nil){
    
        NSString *nextImgName = [NSString stringWithFormat:@"%d",i == 6 ? 1 : i+1];
        nextImageView.image = [UIImage imageNamed:nextImgName];
        
        NSString *preImgName = [NSString stringWithFormat:@"%d", i == 1 ? 6 : i-1];
        preImageView.image = [UIImage imageNamed:preImgName];
    }
    
    if (offset == 0) {
        currentImageView.image = preImageView.image;
        scrollview.contentOffset = CGPointMake(scrollview.bounds.size.width,0);
        preImageView.image = nil;
        
        if (i == 1) {
            i = 6;
            pControl.currentPage = i - 1;

        }else{
            i = i - 1;
            pControl.currentPage = i - 1;
        }
    }
    
    if (offset == scrollview.bounds.size.width * 2) {
        currentImageView.image = nextImageView.image;
        scrollview.contentOffset = CGPointMake(scrollview.bounds.size.width, 0);
        nextImageView.image = nil;
        if (i == 6) {
            i = 1;
            pControl.currentPage = i - 1;

        }else{
            i += 1;
            pControl.currentPage = i - 1;

        }
    }

}
@end
