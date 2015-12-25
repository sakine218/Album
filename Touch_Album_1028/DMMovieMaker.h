//
//  DMMovieMaker.h
//  MixAudioToMovieSampler
//
//  Created by Masuhara on 2015/12/02.
//  Copyright © 2015年 Daisuke Masuhara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface DMMovieMaker : NSObject

+ (DMMovieMaker *)sharedManager;

+ (UIImage *)cropRectImage: (UIImage *)image;
+ (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height;

+ (void)mergeAudio:(NSURL *)audioURL withVideo:(NSURL *)videoURL;
+ (void)makeMovieWithImages:(NSArray *)images withAudio:(NSURL *)audioURL;
@end
