//
//  AddViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Illustration;

@interface AddViewController : UIViewController
        <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>
#pragma mark - Properties
@property (strong, nonatomic) Illustration *illustration;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

#pragma mark - Actions
- (IBAction)actionBrowse:(id)sender;
- (IBAction)actionAddImage:(id)sender;

@end
