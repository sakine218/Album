//
//  ShareMovieViewController.m
//  Touch_Album_1028
//
//  Created by 西林咲音 on 2016/01/20.
//  Copyright © 2016年 西林咲音. All rights reserved.
//

#import "ShareMovieViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DMMovieMaker.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>
#import <Social/Social.h>


@interface ShareMovieViewController ()

@property (nonatomic, retain) IBOutlet UIButton *btn;

@end

@implementation ShareMovieViewController{
    IBOutlet UIButton *btn;
    IBOutlet UIView  *movieplayView;
    IBOutlet UIButton *facebookButtton;
    IBOutlet UIButton *twitterButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"hoge");
    
    NSLog(@"%@", self.outputURL);
    
    dmPlayer = [[DMMovieMaker alloc] init];
    
    MPMoviePlayerController *player = [[MPMoviePlayerController alloc] initWithContentURL:self.outputURL];
    
    self.player = player;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePreloadDidFinish:)
//                                                 name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
//                                               object:player];
//    
//    // 動作の再生終了時に呼ばれるNotification
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(moviePlayerPlaybackDidFinish:)
//                                                 name:MPMoviePlayerPlaybackDidFinishNotification
//                                               object:player];
    
    //movieplayView = dmPlayer.Player.view
    player.view.frame = CGRectMake(40, 160, 250, 250);
    [self.view addSubview:player.view];
    [player prepareToPlay];
    //[moviePlayer prepareToPlay];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)BtnPush:(id)sender{
    __block ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    if ([library videoAtPathIsCompatibleWithSavedPhotosAlbum:self.outputURL] == true) {
        [library writeVideoAtPathToSavedPhotosAlbum:self.outputURL
        completionBlock:^(NSURL *assetURL, NSError *error){
            dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%@", assetURL);
            if (error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil, nil];
                    [alert show];
                        }else{
                            // [SVProgressHUD showSuccessWithStatus:@"保存完了!"];
                            /*
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"  delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [alert show];
                            */
                            library = nil;
                            
                            UIAlertView *alert =
                            [[UIAlertView alloc] initWithTitle:@"保存完了" message:@"　"
                                                      delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                            [alert show];
                    }
            });
        }];
    }
}

- (void)facebookButton {
    
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [vc setInitialText:NSLocalizedString(@"FacebookShareText", nil)];
    [vc addURL:self.outputURL];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)twitterButton {
    
    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [vc setInitialText:NSLocalizedString(@"TwitterShareText", nil)];
    [vc addURL:self.outputURL];
    [self presentViewController:vc animated:YES completion:nil];
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
