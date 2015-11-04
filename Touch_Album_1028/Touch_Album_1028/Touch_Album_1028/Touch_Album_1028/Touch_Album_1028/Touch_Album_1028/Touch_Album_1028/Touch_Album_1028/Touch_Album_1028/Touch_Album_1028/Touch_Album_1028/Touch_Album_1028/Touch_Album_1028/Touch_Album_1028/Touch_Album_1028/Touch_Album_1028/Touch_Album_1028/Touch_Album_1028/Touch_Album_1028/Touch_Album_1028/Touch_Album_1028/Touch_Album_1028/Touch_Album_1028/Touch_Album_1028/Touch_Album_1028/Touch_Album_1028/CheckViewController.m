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

@interface CheckViewController() <UICollectionViewDelegate, UICollectionViewDataSource,UIImagePickerControllerDelegate>

@end

// AddsubView, NSTimer

@implementation CheckViewController {
    IBOutlet UICollectionView *selectedPhotoView;
    NSArray *imageArray;
    int randNumber;
    IBOutlet UIScrollView *scrollView;
    NSMutableArray *buttonImageArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    selectedPhotoView.delegate = self;
    selectedPhotoView.dataSource = self;
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    imageArray = [NSKeyedUnarchiver unarchiveObjectWithData:[ud objectForKey:@"images"]];
    [self.navigationController setNavigationBarHidden:NO animated:NO]; // ナビゲーションバー表示
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return imageArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
    imageView.image = [imageArray[indexPath.row] valueForKey:@"UIImagePickerControllerOriginalImage"];
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AnimationViewController *animationVC = segue.destinationViewController;
    animationVC.imageArray = imageArray;
}

@end
