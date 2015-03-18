//
//  AddImageViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILLustration.h"

@interface AddImageViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITabBarControllerDelegate>
{
    UIImage *selectImage;
    NSURL *imageURL;
    BOOL isUpdateImage;
}
#pragma mark - Properties
@property (strong, nonatomic) ILLustration *illustration;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;
@property (weak, nonatomic) IBOutlet UIButton *btnAddImage;
@property (weak, nonatomic) IBOutlet UITextView *tvComments;

#pragma mark - Actions
- (IBAction)actionBrowse:(id)sender;
- (IBAction)actionAddImage:(id)sender;

@end
