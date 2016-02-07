//
//  TemplateView.h
//  
//
//  Created by 西林咲音 on 2015/10/07.
//
//

#import <UIKit/UIKit.h>


@interface TemplateViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIActionSheetDelegate> {
    IBOutlet UICollectionView *templateViewController;
    NSMutableArray *templateArray;
}

@end
