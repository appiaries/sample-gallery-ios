//
//  ShowImageViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/27/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowImageViewController : UIViewController <UIAlertViewDelegate, UIScrollViewDelegate>
{
    NSArray *listImages;
    NSTimer *slideTimer;
    NSMutableArray *arrayImages;
    UIButton *preButton;
    UIButton *nextButton;
    BOOL isFromStart;
}
#pragma mark - Properties
@property(nonatomic, strong)UIScrollView  *scrollView;
@property(nonatomic, strong)UIPageControl *pageControl;
@property(nonatomic, strong)NSMutableArray *viewController;
@property (weak, nonatomic) IBOutlet UILabel *lbComment;

#pragma mark - Actions
- (IBAction)actionDeleteImage:(id)sender;
- (IBAction)actionChangeImage:(id)sender;

@end
