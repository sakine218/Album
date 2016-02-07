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
#define BUTTON_WIDTH 80
#define BUTTON_HEIGHT 80
#import <AVFoundation/AVFoundation.h>
#import "DMMovieMaker.h"

@interface AnimationViewController ()<UIScrollViewDelegate>

@property UISlider      *audioVolumeSlider;


@end

@implementation AnimationViewController

{
    NSArray *imageArray;
    NSArray *pathArray;
    NSMutableArray *buttonArray;
    int pageNumber;
    NSTimer *timer;
    IBOutlet UIView *sideScroller;
    IBOutlet UIScrollView *scrollView;
    NSArray *imagepath;
    
    //BGMのため
    AVAudioPlayer *player;
    NSError *error;
    NSString *path;
    NSURL *url;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _playButton = scrollView;
//    scrollView.userInteractionEnabled = YES;
//    scrollView.scrollEnabled = YES;
//    NSError *error = nil;
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//    
//    if ( error != nil )
//    {
//        NSLog(@"Error %@", [error localizedDescription]);
//    }
//    [self->player prepareToPlay];
//    [self->player setDelegate:self];
//    NSTimeInterval ti = self->player.duration;
    
    imageArray = [NSArray arrayWithObjects:
                  [UIImage imageNamed:@"otodama_1.png"],
                  [UIImage imageNamed:@"otodama_2.png"],
                  [UIImage imageNamed:@"otodama_3.png"],
                  [UIImage imageNamed:@"otodama_4.png"],
                  [UIImage imageNamed:@"otodama_5.png"],
                  [UIImage imageNamed:@"otodama_6.png"],
                  [UIImage imageNamed:@"otodama_7.png"],
                  [UIImage imageNamed:@"otodama_8.png"],nil];
    
    if (!buttonArray) {
        buttonArray = [NSMutableArray new];
    }
    
    [self makeButtons:imageArray.count];
   
}

- (void)pushButton:(UIButton *)button {
    NSLog(@"Button Tag == %ld", button.tag);
    [self checkButton:button];
    
    
    if (button.tag == 0) {
        [self.audioPlayer stop];
        _audioPlayer.currentTime = 0;
    }
    
    if (button.tag == 1) {
        
//            NSError *error = nil;
        path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
//        url = [[NSURL alloc] initFileURLWithPath:path];
//        [DMMovieMaker makeMovieWithImages:imageArray withAudio:url];
//            self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//            if ( error != nil )
//            {
//                NSLog(@"Error %@", [error localizedDescription]);
//            }
            [player prepareToPlay];
            [player setDelegate:self];
        if ( player.playing ){
            [player stop];
        }
            else{
                [self.audioPlayer play];
            }

    }
    
    
    if (button.tag == 2) {
//        NSError *error = nil;
          path = [[NSBundle mainBundle] pathForResource:@"sampleM" ofType:@"mp3"];
//        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//        [DMMovieMaker makeMovieWithImages:imageArray withAudio:url];        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//        if ( error != nil )
//        {
//            NSLog(@"Error %@", [error localizedDescription]);
//        }
//        [player prepareToPlay];
//        [player setDelegate:self];
        if (player.playing ){
            [player stop];
        }
        else{
            [self.audioPlayer play];
        }
    }
    
    if (button.tag  == 3) {
//        NSError *error = nil;
        path = [[NSBundle mainBundle] pathForResource:@"sampleOk" ofType:@"mp3"];
//        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//        [DMMovieMaker makeMovieWithImages:imageArray withAudio:url];        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//        if ( error != nil )
//        {
//            NSLog(@"Error %@", [error localizedDescription]);
//        }
//        [player prepareToPlay];
//        [player setDelegate:self];
        if (player.playing ){
            [player stop];
        }
        else{
            [self.audioPlayer play];
        }
    }
    
    
    if (button.tag == 4) {
//        NSError *error = nil;
          path = [[NSBundle mainBundle] pathForResource:@"sampleO1" ofType:@"mp3"];
//        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//        [DMMovieMaker makeMovieWithImages:imageArray withAudio:url];
//        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//        if ( error != nil )
//        {
//            NSLog(@"Error %@", [error localizedDescription]);
//        }
//        [player prepareToPlay];
//        [player setDelegate:self];
        if (player.playing ){
            [player stop];
        }
        else{
            [self.audioPlayer play];
        }
    }
    
    if (button.tag == 5) {
//        NSError *error = nil;
          path = [[NSBundle mainBundle] pathForResource:@"sampleO2" ofType:@"mp3"];
//        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//        [DMMovieMaker makeMovieWithImages:imageArray withAudio:url];
//        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//        if ( error != nil )
//        {
//            NSLog(@"Error %@", [error localizedDescription]);
//        }
        [self->player prepareToPlay];
        [self->player setDelegate:self];
        if ( player.playing ){
            [player stop];
        }
        else{
            [self.audioPlayer play];
        }
    }
    
    if (button.tag == 6) {
//        NSError *error = nil;
          path = [[NSBundle mainBundle] pathForResource:@"sampleP1" ofType:@"mp3"];
//        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//        [DMMovieMaker makeMovieWithImages:imageArray withAudio:url];        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//        if ( error != nil )
//        {
//            NSLog(@"Error %@", [error localizedDescription]);
//        }
        [player prepareToPlay];
        [player setDelegate:self];
        if (player.playing ){
            [player stop];
        }
        else{
            [self.audioPlayer play];
        }
    }
    
    if (button.tag == 7) {
//        NSError *error = nil;
          path = [[NSBundle mainBundle] pathForResource:@"sampleP2" ofType:@"mp3"];
//        NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//        [DMMovieMaker makeMovieWithImages:imageArray withAudio:url];
//        self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
//        
//        if ( error != nil )
//        {
//            NSLog(@"Error %@", [error localizedDescription]);
//        }
        [player prepareToPlay];
        [player setDelegate:self];
        if (player.playing ){
            [player stop];
        }
        else{
            [self.audioPlayer play];
        }
    }
    
}

- (void)checkButton: (UIButton *)currentButton {
    
    for (int i = 0; i < buttonArray.count; i++) {
        if (currentButton == buttonArray[i]) {
            [self.audioPlayer stop];
            _audioPlayer.currentTime = 0;
            [[buttonArray[i] layer] setBorderColor:[[UIColor orangeColor] CGColor]];
            [[buttonArray[i] layer] setBorderWidth:2.0];
        }else {
            [_audioPlayer play];
            [[buttonArray[i] layer] setBorderColor:[[UIColor blackColor] CGColor]];
            [[buttonArray[i] layer] setBorderWidth:1.5];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private
- (void)paging {
    if (pageNumber < self.imageArray.count) {
        NSLog(@"pageNumber=%d",pageNumber);

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
    timer = [NSTimer scheduledTimerWithTimeInterval:TIME target:self selector:@selector(paging)  userInfo:nil repeats:YES];
    [timer fire];
}

- (IBAction)makeMovie {

}

#pragma mark - Private
- (void)makeButtons:(int)numberOfButtons {
    for (int i = 0; i < numberOfButtons; i++) {
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake((BUTTON_WIDTH * i + 1) +  (20 * (i + 1)) , 0, BUTTON_WIDTH, BUTTON_HEIGHT)];
//        [button setTitle:@"Button" forState:UIControlStateNormal];
        [button setTitle:@"Tapped" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:imageArray[i] forState:UIControlStateNormal];
        
        
        button.tag = i;
        button.layer.cornerRadius = 40.0f;
        button.clipsToBounds = YES;
        
        [[button layer] setBorderColor:[[UIColor blackColor] CGColor]];
        [[button layer] setBorderWidth:1.5];

        [scrollView addSubview:button];
        [buttonArray addObject:button];
    }
    scrollView.contentSize = CGSizeMake((BUTTON_WIDTH * numberOfButtons) + (23 * numberOfButtons), BUTTON_HEIGHT);
}





@end
