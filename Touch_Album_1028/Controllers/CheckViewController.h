//
//  CheckViewController.h
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/07.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>

@interface CheckViewController : UIViewController<AVAudioPlayerDelegate>
@property(nonatomic) AVAudioPlayer *audioPlayer;

-(IBAction)okButton:(UIBarButtonItem *)savemovieButton;
@end
