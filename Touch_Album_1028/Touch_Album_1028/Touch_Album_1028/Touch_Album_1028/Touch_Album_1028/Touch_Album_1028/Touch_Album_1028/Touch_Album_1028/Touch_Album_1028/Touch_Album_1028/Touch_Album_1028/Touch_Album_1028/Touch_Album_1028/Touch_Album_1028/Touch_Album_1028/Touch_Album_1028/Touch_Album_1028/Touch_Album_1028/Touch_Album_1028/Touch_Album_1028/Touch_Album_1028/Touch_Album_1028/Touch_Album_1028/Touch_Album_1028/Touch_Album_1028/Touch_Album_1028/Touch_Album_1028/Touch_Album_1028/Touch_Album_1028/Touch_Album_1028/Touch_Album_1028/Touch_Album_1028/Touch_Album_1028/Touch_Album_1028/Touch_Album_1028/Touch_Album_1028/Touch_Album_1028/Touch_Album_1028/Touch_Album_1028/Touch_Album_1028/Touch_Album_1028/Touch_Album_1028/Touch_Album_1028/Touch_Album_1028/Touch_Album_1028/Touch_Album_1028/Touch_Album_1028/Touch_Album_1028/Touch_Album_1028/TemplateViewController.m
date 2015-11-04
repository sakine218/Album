//
//  TemplateView.m
//  
//
//  Created by 西林咲音 on 2015/10/07.
//
//

#import "TemplateViewController.h"

@implementation TemplateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    templateViewController.dataSource = self;
    templateViewController.delegate = self;
    
    if (!templateArray) {
        templateArray = [[NSMutableArray alloc] init];
    }
    
    /*
     NSDictionary *temp1 = @{@"title" : @"a",
     @"bgImageName" : @"a",
     @"a" : @"b",
     @"a" : @"a",
     @"a" : @"a",
     @"a" : @"a"};
     
     [templateArray addObject:temp1];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO; //必須
    cell.layer.shadowOffset = CGSizeMake(0.0f, 2.0f);
    cell.layer.shadowOpacity = 0.9f;
    cell.layer.shadowRadius = 2.0f;
    
    UIImageView *bgImageView = (UIImageView *)[cell viewWithTag:1];
    UIImageView *titleImageView = (UIImageView *)[cell viewWithTag:2];
    
    //bgImageView.image = [UIImage imageNamed:@"simple.png"];
    
    bgImageView.backgroundColor = [UIColor redColor];
    titleImageView.image = [UIImage imageNamed:@""];
    
    titleImageView.layer.shouldRasterize = YES;  //レイヤーをラスタライズする
    titleImageView.layer.rasterizationScale = 0.2;  //ラスタライズ時の縮小率
    titleImageView.layer.minificationFilter = kCAFilterTrilinear;
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%d",indexPath.row);
    //[self showActionSheet];
    //[self performSegueWithIdentifier:@"toSource" sender:nil];
}

@end