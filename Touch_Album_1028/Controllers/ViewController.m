//
//  ViewController.m
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/07.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import "ViewController.h"
#import "EAIntroView.h"

@interface ViewController ()<EAIntroDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //if ([[NSUserDefaults standardUserDefaults] integerForKey:@"active"] == 0) {
        // もし初回起動ならばチュートリアル表示のメソッドを呼び出す
        [self showTutorial];
    //}
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:46/255.0 green:139/255.0 blue:87/255.0 alpha:1.000];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:46/255.0 green:139/255.0 blue:87/255.0 alpha:1.000];
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

- (void)showTutorial {
    // basic
    EAIntroPage *page1 = [EAIntroPage page];
    page1.bgImage = [UIImage imageNamed:@"Tutorial0.png"];
    
    EAIntroPage *page2 = [EAIntroPage page];
    page2.bgImage = [UIImage imageNamed:@"Tutorial1.png"];

    EAIntroPage *page3 = [EAIntroPage page];
    page3.bgImage = [UIImage imageNamed:@"Tutorial2.png"];

    EAIntroPage *page4 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"Tutorial3.png"];
    
    EAIntroPage *page5 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"Tutorial4.png"];
    
    EAIntroPage *page6 = [EAIntroPage page];
    page4.bgImage = [UIImage imageNamed:@"Tutorial5.png"];

    EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
    
    [intro.skipButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [intro setDelegate:self];
    
    [intro showInView:self.view animateDuration:0.0];
        
    // チュートリアルを見たことを記録する
    // [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"active"];
}
 
@end
