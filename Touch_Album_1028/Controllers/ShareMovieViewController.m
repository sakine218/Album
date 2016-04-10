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


#import "SocialVideoHelper.h"
#import "REComposeViewController.h"


@interface ShareMovieViewController ()<REComposeViewControllerDelegate>

@property (nonatomic, retain) IBOutlet UIButton *btn;

@end

@implementation ShareMovieViewController{
    IBOutlet UIButton *btn;
    IBOutlet UIView  *movieplayView;
    IBOutlet UIButton *facebookButtton;
    IBOutlet UIButton *twitterButton;
    IBOutlet UIButton *instagramButton;
    ACAccount *account;
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


- (IBAction)facebookButton {
    
//    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
//    [vc setInitialText:NSLocalizedString(@"FacebookShareText", nil)];
//    [vc addURL:self.outputURL];
//    [self presentViewController:vc animated:YES completion:nil];
    
    ACAccountStore *store = [ACAccountStore new];
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{ ACFacebookAppIdKey : @"1718574951696653",
                               ACFacebookAudienceKey : ACFacebookAudienceFriends,
                               ACFacebookPermissionsKey : @[@"publish_actions"] };
    
    [store requestAccessToAccountsWithType:type options:options completion:^(BOOL granted, NSError *error) {
        if (! granted) {
            NSLog(@"%@", error);
            return;
        }
        
        NSArray *accounts = [store accountsWithAccountType:type];
        if (accounts.count < 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"Facebookのアカウントが設定されていません" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
        }
        
        account = accounts[0];
        ACAccountCredential *credientital = [account credential];
        NSString *accessToken = [credientital oauthToken];
        NSLog(@"信頼情報 == %@/ アクセストークン == %@", credientital, accessToken);
        
        // ここはメインスレッドで動かす
        dispatch_async(dispatch_get_main_queue(), ^{
            REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
            composeViewController.title = @"Facebook";
            composeViewController.hasAttachment = NO;
            // composeViewController.attachmentImage = [UIImage imageNamed:@"Flower.jpg"];
            composeViewController.placeholderText = @"ここにテキストを書く";
            composeViewController.delegate = self;
            
            // [composeViewController presentFromRootViewController];
            [composeViewController presentFromViewController:self];
        });
    }];
    
}

- (void)postFacebookWithComment:(NSString *)comment {
    
    ACAccountCredential *credientital = [account credential];
    NSString *accessToken = [credientital oauthToken];
    NSLog(@"信頼情報 == %@/ アクセストークン == %@", credientital, accessToken);
    
    [SocialVideoHelper uploadFacebookVideo:[NSData dataWithContentsOfURL:self.outputURL] comment:comment account:account withCompletion:^(BOOL success, NSString *errorMessage) {
        if (errorMessage != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"投稿エラー" message:@"投稿に失敗しました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"投稿完了" message:@"投稿しました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }];
}


- (void)composeViewController:(REComposeViewController *)composeViewController didFinishWithResult:(REComposeResult)result {
    [composeViewController dismissViewControllerAnimated:YES completion:nil];
    
    if ([composeViewController.title isEqualToString:@"Facebook"]) {
        // facebookの処理
        if (result == REComposeResultCancelled) {
            NSLog(@"Cancelled");
        }
        
        if (result == REComposeResultPosted) {
            [self postFacebookWithComment:composeViewController.text];
        }

    }else if ([composeViewController.title isEqualToString:@"Twitter"]) {
        // Twitterの処理
        if (result == REComposeResultCancelled) {
            NSLog(@"Cancelled");
        }
        
        if (result == REComposeResultPosted) {
            [self tweetWithComment:composeViewController.text];
        }

    }
}

- (IBAction)twitterButton {
    ACAccountStore *store = [ACAccountStore new];
    ACAccountType *type = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [store requestAccessToAccountsWithType:type options:nil completion:^(BOOL granted, NSError *error) {
        if (! granted) {
            NSLog(@"%@", error);
            return;
        }
        
        NSArray *accounts = [store accountsWithAccountType:type];
        NSLog(@"%@" , accounts);
        if (accounts.count < 1) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"Twitterのアカウントが設定されていません" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
            return;
            //twitterのアカウントが複数ある場合に選択できるようにする
//        }else {
//            dispatch_async(dispatch_get_main_queue(), ^{
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"アカウント選択" delegate:self cancelButtonTitle:@"キャンセル" destructiveButtonTitle:@"アカウントその1" otherButtonTitles:@"アカウントその2", nil];
//            [actionSheet showInView:self.view];
//            });
        }
        
        // ここをActionSheetDelegateにまかせればOK
        account = accounts[0];
        
        // ここはメインスレッドで動かす
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"====MAIN THREAD TWEET SHAREING===");
            REComposeViewController *composeViewController = [[REComposeViewController alloc] init];
            composeViewController.title = @"Twitter";
            composeViewController.hasAttachment = YES;
            // composeViewController.attachmentImage
            composeViewController.placeholderText = @"ここにツイートを書く";
            composeViewController.delegate = self;
            [composeViewController presentFromViewController:self];
        });
        
    }];
   }

- (void)tweetWithComment:(NSString *)comment {
    [SocialVideoHelper uploadTwitterVideo:[NSData dataWithContentsOfURL:self.outputURL] comment:comment account:account withCompletion:^(BOOL success, NSString *errorMessage) {
        if (errorMessage != nil) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"投稿エラー" message:@"ツイートに失敗しました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"投稿完了" message:@"ツイートしました。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alertView show];
        }
    }];
}

//- (IBAction)instagramButton{
//    NSURL *instagramURL = [NSURL URLWithString:@"instagram://app"];
//    if ([[UIApplication sharedApplication] canOpenURL:instagramURL])
//    {
//        NSURL *videoFilePath = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[request downloadDestinationPath]]]; // Your local path to the video
//        NSString *caption = @"Some Preloaded Caption";
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library writeVideoAtPathToSavedPhotosAlbum:videoFilePath completionBlock:^(NSURL *assetURL, NSError *error) {
//            NSString *escapedString   = [self urlencodedString:videoFilePath.absoluteString];
//            NSString *escapedCaption  = [self urlencodedString:caption];
//            NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://library?AssetPath=%@&InstagramCaption=%@",escapedString,escapedCaption]];
//            if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//                [[UIApplication sharedApplication] openURL:instagramURL];
//            }
//        }];
//    }
//}

- (IBAction)backToTop {
    [self dismissViewControllerAnimated:YES completion:nil];
}




@end

