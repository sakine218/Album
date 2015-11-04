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

@interface AnimationViewController ()

@end

@implementation AnimationViewController

{
    int pageNumber;
    NSTimer *timer;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    /* Gesture
     UISwipeGestureRecognizer* swipeLeftGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeftGesture:)];
     swipeLeftGesture.direction = UISwipeGestureRecognizerDirectionLeft;
     [self.imageView addGestureRecognizer:swipeLeftGesture];
     */
    
    pageNumber = 0;
    self.imageView.image = [self.imageArray[pageNumber] valueForKey:@"UIImagePickerControllerOriginalImage"];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
}

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





@end
