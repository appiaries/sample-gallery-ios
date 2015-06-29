//
//  ListViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 14/10/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource>
#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end
