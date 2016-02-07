//
//  ViewController.m
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/07.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:95/255.0 green:168/255.0 blue:160/255.0 alpha:1.000];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:60/255.0 green:179/255.0 blue:113/255.0 alpha:1.000];
}

- (void)viewDidAppear:(BOOL)animated{
    if (!timer){
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(blinkButton) userInfo:nil repeats:YES];
        [timer fire];
    }
}

- (void)blinkButton{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 1.0f;
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VAL;
    animation.fromValue = [NSNumber numberWithFloat:1.0f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    [startButton.layer addAnimation:animation forKey:@"blink"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
