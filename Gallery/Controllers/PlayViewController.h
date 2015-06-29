//
//  PlayViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/27/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate>
#pragma mark - Properties
@property (nonatomic, strong) UIScrollView  *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;

#pragma mark - Actions
- (IBAction)actionDeleteImage:(id)sender;
- (IBAction)actionChangeImage:(id)sender;

@end
