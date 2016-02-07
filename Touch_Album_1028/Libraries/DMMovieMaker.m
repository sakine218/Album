//
//  DMMovieMaker.m
//  MixAudioToMovieSampler
//
//  Created by Masuhara on 2015/12/02.
//  Copyright © 2015年 Daisuke Masuhara. All rights reserved.
//

#import "DMMovieMaker.h"
// #import "SVProgressHUD.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <MediaPlayer/MediaPlayer.h>

#define LogReferenceCount(obj) NSLog(@"[%@] reference count = %ld", [obj class], CFGetRetainCount((__bridge void*)obj))

@implementation DMMovieMaker

static DMMovieMaker *sharedInstance = nil;
const int kVideoFPS = 24;

+ (DMMovieMaker *)sharedManager {
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    }
    return sharedInstance;
}

#pragma mark - Merge Audio and Video


#pragma mark - Make a movie from image Array
+ (void)makeMovieWithImages:(NSArray *)images withAudio:(NSURL *)audioURL {
    // [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    // [SVProgressHUD showWithStatus:@"書き出し中..."];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *videoPath = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/movie.mov"];
    NSURL *exportURL = [NSURL fileURLWithPath:videoPath];
    
    NSParameterAssert(images);
    NSParameterAssert(videoPath);
    NSAssert((images.count > 0), @"Set least one image.");
    
    // Delete file if same path
    if ([fileManager fileExistsAtPath:videoPath]) {
        [fileManager removeItemAtPath:videoPath error:nil];
    }
    
    // Assign movie size from the first image size in array
    CGSize size = ((UIImage *)images[0]).size;
    
    NSError *error = nil;
    
    __block AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:videoPath]
                                                                   fileType:AVFileTypeQuickTimeMovie
                                                                      error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"some errors are occured" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    NSDictionary *outputSettings =
    @{
      AVVideoCodecKey  : AVVideoCodecH264,
      AVVideoWidthKey  : @(size.width = 320),
      AVVideoHeightKey : @(size.height =320),
      
      };
    
    AVAssetWriterInput *writerInput = [AVAssetWriterInput
                                       assetWriterInputWithMediaType:AVMediaTypeVideo
                                       outputSettings:outputSettings];
    
    [videoWriter addInput:writerInput];
    
    NSDictionary *sourcePixelBufferAttributes =
    @{
      (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32ARGB),
      (NSString *)kCVPixelBufferWidthKey           : @(size.width),
      (NSString *)kCVPixelBufferHeightKey          : @(size.height),
      };
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput
                                                     sourcePixelBufferAttributes:sourcePixelBufferAttributes];
    
    writerInput.expectsMediaDataInRealTime = YES;
    
    // Start make a movie
    if (![videoWriter startWriting]) {
        NSLog(@"Failed to start writing.");
        return;
    }
    
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    CVPixelBufferRef buffer = NULL;
    
    int frameCount = 0;
    int durationForEachImage = 1;
    int32_t fps = 24;
    
    for (__weak UIImage *image in images) {
        if (adaptor.assetWriterInput.readyForMoreMediaData) {
            CMTime frameTime = CMTimeMake((int64_t)frameCount * fps * durationForEachImage, fps);
            // TODO: ここの調整(リサイズ後なのかそのままでいいのか)
            // UIImage *resizedImage = [self cropRectImage:image];
            buffer = [self pixelBufferFromCGImage:image.CGImage withOriginImage:image];
            
            if (![adaptor appendPixelBuffer:buffer withPresentationTime:frameTime]) {
                NSLog(@"Failed to append buffer. [resizedImage : %@]", image);
            }
            if(buffer) {
                buffer = nil;
                CVBufferRelease(buffer);
            }
            frameCount++;
            // images = nil;
        }else {
            // 追加(ここで10枚が7枚になるので
            NSDate *maxDate = [NSDate dateWithTimeIntervalSinceNow:0.4
                               ];
            [[NSRunLoop currentRunLoop] runUntilDate:maxDate];
        }
    }
    
    // Finish writing a movie
    [writerInput markAsFinished];
    NSLog(@"images === %p", images);
    __block NSArray *array = images;
    
    [videoWriter finishWritingWithCompletionHandler:^{
        array = nil;
        [self mergeAudio:audioURL withVideo:exportURL];
        videoWriter = nil;
    }];
    
    CVPixelBufferPoolRelease(adaptor.pixelBufferPool);
}

+ (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image withOriginImage:(UIImage *)originImage {
    NSDictionary *options = @{
                              (NSString *)kCVPixelBufferCGImageCompatibilityKey : @(YES),
                              (NSString *)kCVPixelBufferCGBitmapContextCompatibilityKey: @(YES),
                              };
    
    CVPixelBufferRef pxbuffer = NULL;
    CVPixelBufferCreate(kCFAllocatorDefault,
                        CGImageGetWidth(image),
                        CGImageGetHeight(image),
                        kCVPixelFormatType_32ARGB,
                        (__bridge CFDictionaryRef)options,
                        &pxbuffer);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata,
                                                 CGImageGetWidth(image),
                                                 CGImageGetHeight(image),
                                                 8,
                                                 4 * CGImageGetWidth(image),
                                                 rgbColorSpace,
                                                 (CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    
    CGContextConcatCTM(context, CGAffineTransformMakeRotation(0));
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

+ (void)mergeAudio:(NSURL *)audioURL withVideo:(NSURL *)videoURL {
    
    NSLog(@"audioURL == %@ videoURL == %@", audioURL, videoURL);
    
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    
    AVURLAsset *audioAsset = [[AVURLAsset alloc]initWithURL:audioURL options:nil];
    AVURLAsset *videoAsset = [[AVURLAsset alloc]initWithURL:videoURL options:nil];
    
    CMTimeRange range = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    // CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:range ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    [a_compositionVideoTrack insertTimeRange:range ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *outputFilePath = [docsDir stringByAppendingPathComponent:[NSString stringWithFormat:@"movie.mov"]];
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    AVAssetExportSession* _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = @"com.apple.quicktime-movie";
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void) {
        dispatch_async(dispatch_get_main_queue(), ^{
            // [self exportDidFinish:_assetExport];
            NSDictionary *info = @{@"outputURL": _assetExport.outputURL};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"toNext" object:self userInfo:info];
        });
    }];
    
}

+ (void)exportDidFinish:(AVAssetExportSession *)session {
    if(session.status == AVAssetExportSessionStatusCompleted) {
        NSURL *outputURL = session.outputURL;
        // TODO: outputURLに一旦書き出したムービーが入っている(でもまだiPhoneには保存されていない)
        //ここでプレイヤーにセット *sakine*
        
        MPMoviePlayerController *Player = [[MPMoviePlayerController alloc] initWithContentURL:outputURL];
        
        // MoviePlayerを保持
        
        // 動画読み込み後に呼ばれるNotification
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(moviePreloadDidFinish:)
//                                                     name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
//                                                   object:Player];
//        
//        // 動作の再生終了時に呼ばれるNotification
//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(moviePlayerPlaybackDidFinish:)
//                                                     name:MPMoviePlayerPlaybackDidFinishNotification
//                                                   object:Player];
        
        if (outputURL != nil) {
            NSDictionary *info = @{@"outputURL": outputURL};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"toNext" object:nil userInfo:info];
        }
    }else {
        NSLog(@"Sesseion status == %ld", (long)session.status);
    }
}

+ (UIImage *)cropRectImage: (UIImage *)image {
    float w = image.size.width;
    float h = image.size.height;
    CGRect rect;
    
    if (h <= w) {
        float x = w / 2 - h / 2;
        float y = 0;
        rect = CGRectMake(x, y, h, h);
    }else {
        float x = 0;
        float y = h / 2 - w / 2;
        rect = CGRectMake(x, y, w, w);
    }
    
    // おまじない始まり
    UIGraphicsBeginImageContext(image.size);
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // おまじない終わり
    
    CGImageRef cgImage = CGImageCreateWithImageInRect(image.CGImage, rect);
//    LogReferenceCount(cgImage);
    UIImage *trimmedImage = [UIImage imageWithCGImage:cgImage];
    
    
    
    CGSize newSize = CGSizeMake(320, 320);
    
    UIGraphicsBeginImageContext(newSize);
    UIImage *resizedImage = nil;
    [trimmedImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    image = nil;
    
    CGImageRelease(cgImage);
    cgImage = nil;
    
    return resizedImage;
}

+ (UIImage *)resizedImage:(UIImage *)image width:(CGFloat)width height:(CGFloat)height {
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    [image drawInRect:CGRectMake(0.0, 0.0, width, height)];
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}


@end
