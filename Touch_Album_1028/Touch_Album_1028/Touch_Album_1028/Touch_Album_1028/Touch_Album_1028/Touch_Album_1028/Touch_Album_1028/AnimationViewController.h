//
//  AnimationViewController.h
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/21.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AnimationViewController : UIViewController

@property (nonatomic, weak)IBOutlet UIImageView *imageView;
@property (nonatomic)NSArray *imageArray;
@property (nonatomic)AVAssetWriter *videoWriter;

@end
