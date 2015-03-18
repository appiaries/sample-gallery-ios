//
//  ListImageViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 14/10/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListImageViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray *listImages;
}
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;

@end
