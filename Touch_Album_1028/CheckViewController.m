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

@interface CheckViewController() <UIImagePickerControllerDelegate>

@end

// AddsubView, NSTimer

@implementation CheckViewController {
    NSMutableArray *imageArray;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *buttonImageArray;
    float currentX;
    NSMutableArray *tmpArray;
}

// ページの高さ
const CGFloat pHeight = 320;
// ページの幅
const CGFloat pWidth  = 320;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currentX = 30;
//    NSUInteger i;
    
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
        NSDictionary *hoge = imageArray[i];
        UIImage *image = [hoge valueForKey:@"UIImagePickerControllerOriginalImage"];
        
//        // 切り抜き元となる画像を用意する。
//        int imageW = image.size.width;
//        int imageH = image.size.height;
//        
//        // 切り抜く位置を指定するCGRectを作成する。
//        // 今回は、画像の中心部分を320×320で切り取る例。
//        // なお簡略化のため、imageW,imageHともに320以上と仮定する。
//        int posX = (imageW - 320) / 2;
//        int posY = (imageH - 320) / 2;
//        CGRect trimArea = CGRectMake(posX, posY, 320, 320);
//        
//        // CoreGraphicsの機能を用いて、
//        // 切り抜いた画像を作成する。
//        CGImageRef imageRef = [image CGImage];
//        CGImageRef trimmedImageRef = CGImageCreateWithImageInRect(imageRef, trimArea);
//        UIImage *trimmedImage = [UIImage imageWithCGImage:trimmedImageRef];
        
        [tmpArray addObject:image];
    }
    
    int pNum = imageArray.count + (imageArray.count - 1);

    for (int i=0;i < pNum; i++){
        if (i % 2 == 0) {
            // UIImageViewのインスタンス
            UIImage *image = tmpArray[i / 2];
            UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
            
            CGRect rect = imageView.frame;
            rect.size.height = pHeight;
            rect.size.width = pWidth;
            rect.origin.x = currentX;
            rect.origin.y = 80;
            imageView.frame = rect;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            [imageView setClipsToBounds:YES];
            // UIScrollViewのインスタンスに画像を貼付ける
            [scrollView addSubview:imageView];
            currentX = currentX + imageView.bounds.size.width ;
        }else {
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(currentX + 20, 200, 60, 60)];
            UIImage *image = [UIImage imageNamed:@"transition.png"];
            [button setTitle:@" " forState:UIControlStateNormal];
            [button setBackgroundImage:image forState:UIControlStateNormal];
            button.layer.cornerRadius = 30.0f;
            [scrollView addSubview:button];
            currentX = currentX+ 40 + button.bounds.size.width;
        }
        [scrollView setContentSize:CGSizeMake( currentX + 20, pHeight)];
    }

    [self.navigationController setNavigationBarHidden:NO animated:NO]; // ナビゲーションバー表示
    
    
    }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AnimationViewController *animationVC = segue.destinationViewController;
    animationVC.photoimageArray = tmpArray;
}

@end
