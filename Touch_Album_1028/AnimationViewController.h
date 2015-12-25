//
//  AnimationViewController.h
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/21.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVFoundation.h>

@interface AnimationViewController : UIViewController<AVAudioPlayerDelegate>{
    int index;
    BOOL traceMode;
    float tranceNumber;
}

@property (nonatomic, weak)IBOutlet UIImageView *imageView;
@property (nonatomic)NSArray *imageArray;
@property (nonatomic)NSArray *photoimageArray;
@property (nonatomic)AVAssetWriter *videoWriter;
@property(nonatomic) AVAudioPlayer *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

- (IBAction)playAudio:(id)sender;

@end
