//
//  ScrollViewWithBar.m
//  Touch_Album_1028
//
//  Created by 西林咲音 on 2016/04/05.
//  Copyright © 2016年 西林咲音. All rights reserved.
//

#import "ScrollViewWithBar.h"
#import <QuartzCore/QuartzCore.h>

@implementation ScrollViewWithBar
@synthesize barView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setShowsVerticalScrollIndicator:NO];
        self.delegate = self;
        [self setBar];
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setShowsVerticalScrollIndicator:NO];
        self.delegate = self;
        [self setBar];
    }
    return self;
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        [self setShowsVerticalScrollIndicator:NO];
        self.delegate = self;
        [self setBar];
    }
    return self;
}
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setBar];
}
- (void)setContentSize:(CGSize)contentSize
{
    [super setContentSize:contentSize];
    [self setBar];
}
- (void)addSubview:(UIView *)view
{
    [super addSubview:view];
    [self setBar];
}

- (void)setBar
{
    if(barView == nil){
        barView = [[UIView alloc] init];
        UIColor * barColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        UIColor * backColor = [UIColor colorWithWhite:0.7 alpha:0.5];
        [barView setBackgroundColor:barColor];
        [[barView layer] setCornerRadius:3.0f];
        [[barView layer] setMasksToBounds:YES];
        [[barView layer] setBorderWidth:1.0f];
        [[barView layer] setBorderColor:backColor.CGColor];
        
        [self addSubview:barView];
        barColor = nil;
        backColor = nil;
    }else{
        [self bringSubviewToFront:barView];
    }
    float barWidth = 7.0;
    float barHeight = self.frame.size.height * self.frame.size.height / self.contentSize.height;
    
    barView.frame = CGRectMake(self.frame.size.width-barWidth-1,
                               0,
                               barWidth,
                               barHeight);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect barFrame = barView.frame;
    barFrame.origin.y = scrollView.contentOffset.y + scrollView.frame.size.height * scrollView.contentOffset.y / scrollView.contentSize.height;
    barView.frame = barFrame;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
