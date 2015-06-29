//
//  EditViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Illustration;

@interface EditViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
#pragma mark - Properties
@property (strong, nonatomic) Illustration *illustration;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

#pragma mark - Actions
- (IBAction)actionBrowse:(id)sender;
- (IBAction)actionAddImage:(id)sender;

@end
