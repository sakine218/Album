//
//  AnimationViewController.m
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/21.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import "AnimationViewController.h"
#import "ASScreenRecorder.h"
#define TIME 2.4
#import "DMSideScrollView.h"

@interface AnimationViewController ()<UIScrollViewDelegate>

@end

@implementation AnimationViewController

{
    NSArray *imageArray;
    int pageNumber;
    NSTimer *timer;
    IBOutlet UIView *sideScroller;
    DMSideScrollView *contentScrollView;

}

#pragma mark - Delegate
- (void)makeButtonsWithSize:(CGSize)size {
    
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *iv = [[UIImageView alloc] initWithImage:imageArray[i]];
        iv.frame = CGRectMake(sideScroller.bounds.origin.x + 10 + (10 * i) + (size.width * i), 10, size.width, size.height);
        iv.contentMode = UIViewContentModeScaleAspectFill;
        //iv.backgroundColor = [UIColor redColor];
        iv.userInteractionEnabled = YES;
        iv.tag = i + 1;
        iv.clipsToBounds = YES;
//        [imageArray addObject:iv];
        [contentScrollView addSubview:iv];
    }
    
    contentScrollView.contentSize = CGSizeMake(sideScroller.bounds.origin.x + 10 + (10 * imageArray.count) + (size.width * imageArray.count), sideScroller.bounds.size.height);
    [sideScroller addSubview:contentScrollView];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSError *error = nil;
    // 再生する audio ファイルのパスを取得
    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
    // パスから、再生するURLを作成する
    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
    // auido を再生するプレイヤーを作成する
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    // エラーが起きたとき
    if ( error != nil )
    {
        NSLog(@"Error %@", [error localizedDescription]);
    }
    // 自分自身をデリゲートに設定
    [self.audioPlayer setDelegate:self];

//-(IBAction)playAudio:(id)sender
//{
//    if ( self.audioPlayer.playing ){
//        [self.audioPlayer stop];
//        [self.playButton setTitle:@"Stop" forState:UIControlStateNormal];
//    }
//    else{
//        [self.audioPlayer play];
//        [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
//    }
//}

    if (!contentScrollView) {
        contentScrollView = [[DMSideScrollView alloc] initWithFrame:CGRectMake(0, 0, sideScroller.bounds.size.width, sideScroller.bounds.size.height)];
        contentScrollView.userInteractionEnabled = YES;
        contentScrollView.showsHorizontalScrollIndicator = NO;
        contentScrollView.pagingEnabled = NO;
        contentScrollView.bounces = YES;
    }
    contentScrollView.delegate = self;
    
    if (!imageArray) {
        imageArray = [NSMutableArray new];
    }
    
    traceMode = NO;
    tranceNumber = 45.0;
    
    imageArray = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"design_1.png"],
                  [UIImage imageNamed:@"design_2.png"],
                  [UIImage imageNamed:@"design_3.png"],
                  [UIImage imageNamed:@"design_4.png"],
                  [UIImage imageNamed:@"design_5.png"],
                  [UIImage imageNamed:@"design_6.png"],
                  [UIImage imageNamed:@"design_7.png"],
                  [UIImage imageNamed:@"design_8.png"],nil];
    
    [self makeButtonsWithSize:CGSizeMake(60, 60)];
    
    self.view.userInteractionEnabled = YES;
    _imageView.userInteractionEnabled = YES;
    sideScroller.userInteractionEnabled = YES;
    contentScrollView.userInteractionEnabled = YES;
    
    //[self setSKScene];
}

    /* Gesture
     UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
     swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
     [self.imageView addGestureRecognizer:swipeLeftGesture];
     */


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)paging {
    if (pageNumber < self.imageArray.count) {
        self.imageView.image = [self.imageArray[pageNumber] valueForKey:@"UIImagePickerControllerOriginalImage"];
        pageNumber = pageNumber + 1;
    }else {
        NSLog(@"end");
        [timer invalidate];
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp
                           forView:self.imageView cache:YES];
    
    [UIView commitAnimations];
}

- (IBAction)startAnimation:(id)sender {
    timer = [NSTimer scheduledTimerWithTimeInterval:TIME target:self selector:@selector(paging) userInfo:nil repeats:YES];
    [timer fire];
}

- (IBAction)saveMovie {
    ASScreenRecorder *recorder = [ASScreenRecorder sharedInstance];
    
    if (recorder.isRecording) {
        [recorder stopRecordingWithCompletion:^{
            NSLog(@"Finished recording");
        }];
    } else {
        [recorder startRecording];
        NSLog(@"Start recording");
    }
}

#pragma mark - GestureRecognizer
- (void)handleSwipeLeftGesture:(UISwipeGestureRecognizer *)sender {
    NSLog(@"swipe left");
    [self paging];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    
    //タッチされた位置を取得
    CGPoint touchpoint = [touch locationInView:self.view];
    
    //得られた位置にあるlayerを取得
    CALayer *layer = [self.view.layer hitTest:touchpoint];
    
    NSLog(@"subview == %@", layer);
}


@end
