//
//  AddImageViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "AddImageViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ILLustrationImageManager.h"
#import "ILLustrationManager.h"
#import "ILLustrationImage.h"
#import "MBProgressHUD.h"


@implementation AddImageViewController
@synthesize illustration;

#pragma mark Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"画像追加";
    
    // Set border for Add button
    [[self.btnAddImage layer] setCornerRadius:7.0f];
    [[self.btnAddImage layer] setMasksToBounds:YES];
    
    self.viewContainer.layer.borderColor = [UIColor blackColor].CGColor;
    self.viewContainer.layer.borderWidth = 1.0f;
    
    self.tvComments.layer.borderColor = [UIColor blackColor].CGColor;
    self.tvComments.layer.borderWidth = 1.0f;
    
    [self addDoneToolBarToKeyboard:self.tvComments];
    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [tabBarController setDelegate:self];
}

#pragma mark - Actions
- (IBAction)actionBrowse:(id)sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [imagePicker setDelegate:self];
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)actionAddImage:(id)sender
{
    NSString *textComment = [self.tvComments.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!imageURL) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"画像が選択されていません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else if (textComment.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"コメントが入力されていません" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else if (textComment.length > 50) {
        [[[UIAlertView alloc] initWithTitle:@"" message:@"コメントが全角50文字を超えています" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [self upLoadImageToServer];
    }
}

#pragma mark - TabBarController delegates
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex != 2) {
        self.tvComments.text = @"";
        imageURL = nil;
    }
}

#pragma mark - UIImagePicker delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    selectImage = info[UIImagePickerControllerOriginalImage];
    imageURL = info[UIImagePickerControllerReferenceURL];
    isUpdateImage = YES;
}

#pragma mark - Keyboard handlers
// Add Done button to keyboard
- (void)addDoneToolBarToKeyboard:(UITextView *)textView
{
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = @[
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
    ];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

// Dismiss Keyboard
- (void)doneButtonClickedDismissKeyboard
{
    [self.tvComments resignFirstResponder];
}

#pragma mark - Private methods
// Upload image to server
- (void)upLoadImageToServer
{
    NSData *imgData;
    NSString *typeImage = @"png";
    NSString *imageName = @"image.png";
    
    NSString *extension = [imageURL pathExtension];
    CFStringRef imageUTI = (UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension,(__bridge CFStringRef)extension , NULL));
    
    if (UTTypeConformsTo(imageUTI, kUTTypeJPEG)) {
        // Handle JPG
        imgData = UIImageJPEGRepresentation(selectImage, 0.9f);
        typeImage = @"jpg";
        imageName = @"image.jpg";
    } else if (UTTypeConformsTo(imageUTI, kUTTypePNG)) {
        // Handle PNG
        imgData = UIImagePNGRepresentation(selectImage);
    } else {
        NSLog(@"Unhandled Image UTI: %@", imageUTI);
    }
    
    [[ILLustrationImageManager sharedManager] addImageData:imgData fileName:imageName typeImage:typeImage withCompleteBlock:^(ILLustrationImage *completeBlock){
        NSDictionary *dictionary = @{
                @"description" : self.tvComments.text,
                @"image_id"    : completeBlock.id,
        };
        [[ILLustrationManager sharedManager] addImageInfoWithData:dictionary failBlock:^(NSError *failBlock){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (failBlock != nil) {
                NSLog(@"NSError");
            } else {
                NSLog(@"OK");
                self.tvComments.text = @"";
                imageURL = nil;
                self.tabBarController.selectedIndex = 0; 
            }
        }];
    } failBlock:^(NSError *failBlock){ }];
}

@end
