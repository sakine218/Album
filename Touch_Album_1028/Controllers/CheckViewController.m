//
//  CheckViewController.m
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/07.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import "CheckViewController.h"
#import "ELCImagePickerController.h"
#import "AnimationViewController.h"
#import "DMMovieMaker.h"
#define TIME 2.4
#import "DMSideScrollView.h"
#define BUTTON_WIDTH 125
#define BUTTON_HEIGHT 125
#import <AVFoundation/AVFoundation.h>
#import "MBProgressHUD.h"
#import "ShareMovieViewController.h"
#import "ScrollViewWithBar.h"

@interface CheckViewController() <UIImagePickerControllerDelegate,UIScrollViewDelegate>

@end

// AddsubView, NSTimer

@implementation CheckViewController {
    
    UIImageView *imageView;
    
    NSMutableArray *imageArray;
    IBOutlet ScrollViewWithBar *scrollView;
    NSMutableArray *buttonImageArray;
    float currentX;
    NSMutableArray *tmpArray;
    
    
    NSArray *musicimageArray;
    NSArray *musicframeimageArray;
    NSArray *pathArray;
    NSMutableArray *buttonArray;
    IBOutlet ScrollViewWithBar *buttonscrollView;
    NSArray *imagepath;
    IBOutlet UIImageView *buttonimageView;
    IBOutlet UIButton *musicbutton;
    IBOutlet UIButton *speedbutton;
    
    IBOutlet UIView *uv;
    
    float duration;

    
    //  BGMのため
    //    AVAudioPlayer *player;
    NSError *error;
    NSString *path;
    NSURL *url;
    
    NSURL *movieURL;
}



// ページの高さ
const CGFloat pHeight = 580;
// ページの幅
const CGFloat pWidth  = 580;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    buttonscrollView.hidden = NO;
    
    [self makeView];
    uv.hidden = YES;
    
    buttonimageView.image = [UIImage imageNamed:@"makingselectbutton0.png"];
    
    
    scrollView.showsHorizontalScrollIndicator = NO;
    buttonscrollView.showsHorizontalScrollIndicator = NO;

    
    NSLog(@"hoge");
    
    //    _playButton = buttonscrollView;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(toNext:) name:@"toNext" object:nil];
    
    
    musicimageArray = [NSArray arrayWithObjects:
                       [UIImage imageNamed:@"onpu0.png"],
                       [UIImage imageNamed:@"onpu1.png"],
                       [UIImage imageNamed:@"onpu2.png"],
                       [UIImage imageNamed:@"onpu5.png"],
                       [UIImage imageNamed:@"onpu6.png"],
                       [UIImage imageNamed:@"onpu7.png"],
                       [UIImage imageNamed:@"onpu3.png"],
                       [UIImage imageNamed:@"onpu4.png"],nil];
    
    musicframeimageArray = [NSArray arrayWithObjects:
                             [UIImage imageNamed:@"onpuframe0.png"],
                             [UIImage imageNamed:@"onpuframe1.png"],
                             [UIImage imageNamed:@"onpuframe2.png"],
                             [UIImage imageNamed:@"onpuframe5.png"],
                             [UIImage imageNamed:@"onpuframe6.png"],
                             [UIImage imageNamed:@"onpuframe7.png"],
                             [UIImage imageNamed:@"onpuframe3.png"],
                             [UIImage imageNamed:@"onpuframe4.png"],nil];

    
    if (!buttonArray) {
        buttonArray = [NSMutableArray new];
        [self makeButtons:musicimageArray.count];
        currentX = 0;
    }
    
    [buttonArray[0] setImage:musicframeimageArray[0] forState:normal];
    path = [[NSBundle mainBundle] pathForResource:@"otonashi" ofType:@"mp3"];
    if (self.audioPlayer.playing ){
        NSLog(@"playing->stop");
        [self.audioPlayer stop];
    }else{
        [self.audioPlayer play];
        NSLog(@"stop->playing");
    }
    
    if (!imageArray) {
        imageArray = [[NSMutableArray alloc] init];
    }
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    imageArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"images"]];
    tmpArray = [NSMutableArray new];
    if (!tmpArray) {
        tmpArray = [NSMutableArray new];
    }
    for (int i = 0; i < imageArray.count; i++) {
        NSDictionary *dic = imageArray[i];
        UIImage *image = [dic valueForKey:@"UIImagePickerControllerOriginalImage"];
        
        // 画像を切り取り
        
        UIImage *croppedImage = [DMMovieMaker cropRectImage:image];
        
        [tmpArray addObject:croppedImage];
    }
    
    int pNum = imageArray.count + (imageArray.count - 1);
    
    for (int i=0;i < pNum; i++){
        if (i % 2 == 0) {
            // UIImageViewのインスタンス
            UIImage *image = tmpArray[i / 2];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            CGRect rect = imageView.frame;
            if ([UIScreen mainScreen].bounds.size.height == 1024) {
            rect.size.height = pHeight;
            rect.size.width = pWidth;
            }else{
                rect.size.height = 280;
                rect.size.width = 280;
            }
            rect.origin.x = currentX;
            rect.origin.y = 0;//scroll view height
            imageView.frame = rect;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView setClipsToBounds:YES];
            // UIScrollViewのインスタンスに画像を貼付ける
            [scrollView addSubview:imageView];
            
//            //デバッグあんべ　scroll viewの高さを出力
//            NSLog(@"scroll view height = %f",scrollView.bounds.size.height);
//            //デバッグあんべ　Imageの高さを出力
//            NSLog(@"Image height = %f, width = %f",imageView.bounds.size.height,imageView.bounds.size.height);
//
            //デバッグあんべ　Imageの高さを出力
            NSLog(@"Image height = %f, width = %f",imageView.bounds.size.height,imageView.bounds.size.height);
            
            
            currentX = currentX + imageView.bounds.size.width ;
        } else {
            UIButton *button;
            if ([UIScreen mainScreen].bounds.size.height == 1024){
            button = [[UIButton alloc] initWithFrame:CGRectMake(currentX + 20, 250, 60, 60)];
            }else{
            button = [[UIButton alloc] initWithFrame:CGRectMake(currentX + 20, 110, 60, 60)];
            }
            UIImage *image = [UIImage imageNamed:@"mark.png"];
            [button setTitle:@" " forState:UIControlStateNormal];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.layer.cornerRadius = 30.0f;
            [scrollView addSubview:button];
            currentX = currentX+ 40 + button.bounds.size.width;
        }
        if ([UIScreen mainScreen].bounds.size.height == 1024){
        [scrollView setContentSize:CGSizeMake( currentX + 20, pHeight)];
        }else{
            [scrollView setContentSize:CGSizeMake( currentX + 20, 280)];
        }
    }
    
    [self.navigationController setNavigationBarHidden:NO animated:NO]; // ナビゲーションバー表示
    
}

-(IBAction)musicbutton: (UIButton *) sender{
    buttonimageView.image = [UIImage imageNamed:@"makingselectbutton0.png"];
    NSLog(@"みそしる");
    uv.hidden = YES;
    buttonscrollView.hidden = NO;
}

-(IBAction)speedbutton{
    buttonimageView.image = [UIImage imageNamed:@"makingselectbutton1.png"];
    NSLog(@"おしるこ");
    buttonimageView.image = [UIImage imageNamed:@"makingbutton0-0.png"];
    uv.hidden = NO;
    buttonscrollView.hidden = YES;
    [self.audioPlayer stop];
}

-(void)makeView{
    uv = [[UIView alloc]initWithFrame:CGRectMake(0,445,320,90)];
    UIButton *btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn0.frame = CGRectMake(20,5,80,80);
    NSLog(@"まぐろ");
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(120,5,80,80);
    NSLog(@"さーもん");
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(220,5,80,80);
    NSLog(@"なっとう");
    [uv addSubview:btn0];
    [uv addSubview:btn1];
    [uv addSubview:btn2];
    [self.view addSubview:uv];
    [btn0 addTarget:self action:@selector(btn0Pushed)forControlEvents:UIControlEventTouchDown];
    [btn1 addTarget:self action:@selector(btn1Pushed)forControlEvents:UIControlEventTouchDown];
    [btn2 addTarget:self action:@selector(btn2Pushed)forControlEvents:UIControlEventTouchDown];
}

-(void)btn0Pushed{
    buttonimageView.image = [UIImage imageNamed:@"makingbutton0-1.png"];
    duration = 3;
}

-(void)btn1Pushed{
    buttonimageView.image = [UIImage imageNamed:@"makingbutton0-0.png"];
    duration = 2;
}

-(void)btn2Pushed{
    buttonimageView.image = [UIImage imageNamed:@"makingbutton0-2.png"];
    duration = 1;
}

- (void)pushButton: (UIButton *)button{
    
    NSLog(@"Button Tag == %ld", button.tag);
    [self checkButton:button];
    
    if (button.tag == 0) {
        path = [[NSBundle mainBundle] pathForResource:@"otonashi" ofType:@"mp3"];
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else if (button.tag == 1) {
        path = [[NSBundle mainBundle] pathForResource:@"sample" ofType:@"mp3"];
        //[self.audioPlayer prepareToPlay];
        //[self.audioPlayer setDelegate:self];
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else if (button.tag == 2) {
        path = [[NSBundle mainBundle] pathForResource:@"sample2" ofType:@"mp3"];
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else if (button.tag  == 3) {
        path = [[NSBundle mainBundle] pathForResource:@"sampleOk" ofType:@"mp3"];
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else if (button.tag == 4) {
        path = [[NSBundle mainBundle] pathForResource:@"sampleO1" ofType:@"mp3"];;
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else if (button.tag == 5) {
        path = [[NSBundle mainBundle] pathForResource:@"sampleO2" ofType:@"mp3"];;
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else if (button.tag == 6) {
        path = [[NSBundle mainBundle] pathForResource:@"sampleP1" ofType:@"mp3"];
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else if (button.tag == 7) {
        path = [[NSBundle mainBundle] pathForResource:@"sampleP2" ofType:@"mp3"];
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
    }else {
        path = [[NSBundle mainBundle] pathForResource:@"otonashi" ofType:@"mp3"];
        if (self.audioPlayer.playing ){
            NSLog(@"playing->stop");
            [self.audioPlayer stop];
        }else{
            [self.audioPlayer play];
            NSLog(@"stop->playing");
        }
        
    }
    NSLog(@"path = %@",path);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];

    [self.audioPlayer prepareToPlay];
    self.audioPlayer.delegate = self;
    
    [_audioPlayer play];
}



- (void)checkButton: (UIButton *)currentButton {
        for (int i = 0; i < buttonArray.count; i++) {
        if (currentButton == buttonArray[i]) {
            [_audioPlayer play];
            NSLog(@"stop->playing(checkButton)");
            _audioPlayer.currentTime = 0;
            [currentButton setImage:musicframeimageArray[i] forState:normal];
//            [[buttonArray[i] layer] setBorderColor:[[UIColor orangeColor] CGColor]];
//            [[buttonArray[i] layer] setBorderWidth:2.0];
        }else {
            [buttonArray[i] setImage:musicimageArray[i] forState:normal];
            //[self.audioPlayer stop];
            //NSLog(@"playing->stop(checkButton)");
//            [[buttonArray[i] layer] setBorderColor:[[UIColor blackColor] CGColor]];
//            [[buttonArray[i] layer] setBorderWidth:1.5];
        }
    }
}

-(IBAction)okButton:(UIBarButtonItem *)savemovieButton {
    [self.audioPlayer stop];
    url = [[NSURL alloc] initFileURLWithPath:path];
    [DMMovieMaker makeMovieWithImages:tmpArray withAudio:url withduration:duration];
}

- (void)toNext:(NSNotificationCenter *)notificationCenter {
    // 通知で送られてきたoutputURLを取り出して、NSURLの変数に保存。
    NSURL *outputURL = [[notificationCenter valueForKey:@"userInfo"] valueForKey:@"outputURL"];
    movieURL = outputURL;
    [self performSegueWithIdentifier:@"toPreview" sender:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ShareMovieViewController *shareMovieViewController = segue.destinationViewController;
    shareMovieViewController.outputURL = movieURL;
    //    AnimationViewController *animationVC = segue.destinationViewController;
    //    animationVC.photoimageArray = tmpArray;
}

- (void)viewWillAppear:(BOOL)animated {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


#pragma mark - Private
- (void)makeButtons:(int)numberOfButtons {
    for (int i = 0; i < numberOfButtons; i++) {
        UIButton *button;
        if ([UIScreen mainScreen].bounds.size.height == 1024){
        button = [[UIButton alloc] initWithFrame:CGRectMake((BUTTON_WIDTH * i + 1) +  (20 * (i + 1)) , 20, BUTTON_WIDTH, BUTTON_HEIGHT)];
        }else{
            button = [[UIButton alloc] initWithFrame:CGRectMake((80 * i + 1) +  (20 * (i + 1)) , 0, 80, 80)];
        }
        //        [button setTitle:@"Button" forState:UIControlStateNormal];
        [button setTitle:@"Tapped" forState:UIControlStateSelected];
        [button addTarget:self action:@selector(pushButton:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:musicimageArray[i] forState:UIControlStateNormal];
        
        
        button.tag = i;
//        button.layer.cornerRadius = 40.0f;
        button.clipsToBounds = YES;
        
//        [[button layer] setBorderColor:[[UIColor blackColor] CGColor]];
//        [[button layer] setBorderWidth:1.5];
        
        [buttonscrollView addSubview:button];
        [buttonArray addObject:button];
    }
    if ([UIScreen mainScreen].bounds.size.height == 1024){
    buttonscrollView.contentSize = CGSizeMake((BUTTON_WIDTH * numberOfButtons) + (23 * numberOfButtons), BUTTON_HEIGHT);
    }else{
        buttonscrollView.contentSize = CGSizeMake((80 * numberOfButtons) + (23 * numberOfButtons), 80);
    }
}

- (IBAction)backToTop {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end

