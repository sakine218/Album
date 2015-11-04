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

@interface AddPostViewController() <UIImagePickerControllerDelegate, UINavigationControllerDelegate, ELCImagePickerControllerDelegate> 
@end

@implementation AddPostViewController {
    int count;
}

- (IBAction)showELCPicker:(id)sender
{
    /*
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
     ELCAlbumPickerController *albumController = [[ELCAlbumPickerController alloc] initWithNibName:@"ELCAlbumPickerController" bundle:[NSBundle mainBundle]];
     ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initWithRootViewController:albumController];
     [albumController setParent:elcPicker];
     [elcPicker setDelegate:self];
     [self presentViewController:elcPicker animated:YES completion:nil];
     } else {
     
     }
     */
    // Create the image picker
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select, defaults to 4
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return selected order of images
    elcPicker.imagePickerDelegate = self;
    
    //Present modally
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    if (info.count < 5) {
        
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"画像選択について" message:@"5枚以上選択してください"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
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
