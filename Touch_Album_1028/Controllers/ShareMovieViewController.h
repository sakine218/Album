//
//  ShareMovieViewController.h
//  Touch_Album_1028
//
//  Created by 西林咲音 on 2016/01/20.
//  Copyright © 2016年 西林咲音. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DMMovieMaker.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ShareMovieViewController : UIViewController{
    
    DMMovieMaker *dmPlayer;
}

@property (nonatomic)NSURL *outputURL;
@property (strong, nonatomic) MPMoviePlayerController *player;

//@property(strong, nonatomic) DMMovieMaker *Player;

@end
