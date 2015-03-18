//
//  EditViewController.h
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ILLustration.h"

@interface EditViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSURL *imageURL;
    UIImage *selectImage;
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
