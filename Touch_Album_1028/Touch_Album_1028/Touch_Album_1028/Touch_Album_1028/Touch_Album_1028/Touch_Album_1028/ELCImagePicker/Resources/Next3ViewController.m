//
//  Next3ViewController.m
//  TouchAlbum
//
//  Created by 西林咲音 on 2015/08/26.
//  Copyright (c) 2015年 西林咲音. All rights reserved.
//

#import "NextViewController.h"
#import "Next2ViewController.h"
#import "Next3ViewController.h"
#import "Next4ViewController.h"


@interface Next3ViewController ()


@end

@implementation Next3ViewController{
    //    IBOutlet UICollectionView *selectedPhotoView;
    NSArray *imageArray;
    int randNumber;
    IBOutlet UIScrollView *scrollView;
    IBOutlet UINavigationItem *nabigationItem;
    IBOutlet UIImageView *ImageView;
    IBOutlet UIImageView *ImageView2;
    IBOutlet UIImageView *ImageView3;
    NSMutableArray *buttonImageArray;
}

- (IBAction)getRandomNumber {
    
    
    
    NSMutableArray *array = [NSMutableArray new];
    //------------
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int number = (int)[ud integerForKey:@"number"];
    
    if (number == 0) {
        UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"終了" message:@"終了"
                                  delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
        
    }
    NSLog(@"SAVED INT %d", number);
    
    while(number) {
        randNumber = (int)arc4random_uniform(4) + 1;
        NSLog(@"%d",randNumber);
        
        if (number <= 4){
            int restNumber = (int)[ud integerForKey:@"number"];
            randNumber = (int)arc4random_uniform(restNumber) + 1;
            if (randNumber == 1) {
                NextViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"NextViewController"];
                [ud setInteger:restNumber - randNumber  forKey:@"number"];
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (randNumber == 2) {
                Next2ViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"Next2ViewController"];
                [ud setInteger:restNumber - randNumber  forKey:@"number"];
                
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (randNumber == 3){
                Next3ViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"Next3ViewController"];
                [ud setInteger:restNumber - randNumber  forKey:@"number"];
                
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (randNumber == 4){
                Next4ViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"Next4ViewController"];
                [ud setInteger:restNumber - randNumber  forKey:@"number"];
                
                [self.navigationController pushViewController:nextVC animated:YES];
            }
            
            [array addObject:[NSNumber numberWithInteger:number]];
            NSLog(@"RETUREND");
            NSLog(@"array == %@", array);
            return;
        }else {
            if (randNumber == 1) {
                NextViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"NextViewController"];
                
                //                secondVC.secondNum = self.firstNum;
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (randNumber == 2) {
                Next2ViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"Next2ViewController"];
                
                //                secondVC.secondNum = self.firstNum;
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (randNumber == 3){
                Next3ViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"Next3ViewController"];
                
                //                secondVC.secondNum = self.firstNum;
                [self.navigationController pushViewController:nextVC animated:YES];
            }else if (randNumber == 4){
                Next4ViewController *nextVC =  [self.storyboard instantiateViewControllerWithIdentifier:@"Next4ViewController"];
                //                secondVC.secondNum = self.firstNum;
                [self.navigationController pushViewController:nextVC animated:YES];
            }
            number = number - randNumber;
            [array addObject: [NSNumber numberWithInteger:randNumber]];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setInteger:number forKey:@"number"];
            NSLog(@"SAVED INT %d", number);
            [ud synchronize];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    int restNum = (int)[ud integerForKey:@"number"];
    if (restNum == 0) {
        nabigationItem.rightBarButtonItem.title = @"完了";
    }
    
    NSData *data = [ud objectForKey:@"images"];
    NSMutableArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"array == %@", array);
    
    scrollView.scrollEnabled = YES;
    
    if (!buttonImageArray) {
        buttonImageArray = [NSMutableArray new];
    }
    
    for (int i = 0; i < array.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        button.frame = CGRectMake((button.bounds.size.width * i) + (20 * i) + 20, 10, 50, 50);
        scrollView.contentSize = CGSizeMake((button.bounds.size.width * i) + (10 * i) + 70 + 10, button.bounds.size.height);
        [button setBackgroundColor:[UIColor redColor]];
        [button setBackgroundImage:[array[i] valueForKey:@"UIImagePickerControllerOriginalImage" ] forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(tapButton:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
        button.tag = i + 1;
        
        
    }
    NSLog(@"array == %@", array);
    ImageView.image = [array[0] valueForKey:@"UIImagePickerControllerOriginalImage" ];
    ImageView2.image = [array[1] valueForKey:@"UIImagePickerControllerOriginalImage" ];
    ImageView3.image = [array[2] valueForKey:@"UIImagePickerControllerOriginalImage" ];
    [array removeObjectAtIndex:2];
    [array removeObjectAtIndex:1];
    [array removeObjectAtIndex:0];
    
    
    NSLog(@"array == %@", array);
    [ud setObject:[NSKeyedArchiver archivedDataWithRootObject:array] forKey:@"images"];
    [ud synchronize];
}

- (void)tapButton:(UIButton *)button {
    NSLog(@"タップされたボタンは%dです", button.tag);
}


@end