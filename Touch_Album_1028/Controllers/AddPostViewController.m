//
//  AddPostViewController.m
//  TouchAlbum2
//
//  Created by 西林咲音 on 2015/10/07.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import "AddPostViewController.h"
#import "ELCImagePickerController.h"
#import "ELCAlbumPickerController.h"
#import "MBProgressHUD.h"
#import "ELCOverlayImageView.h"

@interface AddPostViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate>
@property(nonatomic, strong) ELCImagePickerController *elcPicker;
@end

@implementation AddPostViewController {
    int count;
}

- (IBAction)showELCPicker:(id)sender
{
    // Create the image picker
    self.elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    self.elcPicker.maximumImagesCount = 50; //Set the maximum number of images to select, defaults to 4
    self.elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    self.elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    self.elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    self.elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:self.elcPicker animated:YES completion:nil];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:60/255.0 green:179/255.0 blue:113/255.0 alpha:1.000];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
//    if (info.count < 5) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"5枚以上選択してください"
//                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
//        return;
//    }
//    [self.view bringSubviewToFront:ELCOverlayImageView];
    
    // リサイズ
    NSLog(@"info == %@", info);
    
    // 選択した画像の配列をNSUserDefaultsに保存
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:info];
    [ud setObject:data forKey:@"images"];
    [ud synchronize];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        [self performSegueWithIdentifier:@"toNext" sender:nil];
    }];
    
    [ud setInteger:info.count forKey:@"number"];
    [ud synchronize];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
