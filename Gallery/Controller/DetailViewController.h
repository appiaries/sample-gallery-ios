//
//  DetailViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILLustration.h"

@interface DetailViewController : UIViewController <UIAlertViewDelegate>
#pragma mark - Properties
@property (strong, nonatomic) ILLustration *illustration;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *lbComment;

#pragma mark - Actions
- (IBAction)actionDeleteImage:(id)sender;
- (IBAction)actionChangeImage:(id)sender;

@end
