//
//  EditViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "EditViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "ILLustrationManager.h"
#import "ILLustrationImageManager.h"
#import "MBProgressHUD.h"


@implementation EditViewController
@synthesize illustration;

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDoneToolBarToKeyboard:self.tvComments];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlImage = [illustration getUrlFromImageID:illustration.imageID];
    imageURL = [NSURL URLWithString:urlImage];
    
    self.tvComments.text = illustration.description;
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
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
        [self updateImage];
    }
}

#pragma mark - UIImagePickerController delegates
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
- (void)updateImage
{
    // Handle PNG
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
    
    if (isUpdateImage) { // If update image
        [[ILLustrationImageManager sharedManager] updateImageDataWithID:illustration.imageID imageData:imgData fileName:imageName typeImage:typeImage failBlock:^(NSError *error){
            if (error == nil) {
                NSDictionary *dictionary = @{ @"description" : self.tvComments.text };
                [[ILLustrationManager sharedManager] updateImageInfoWithImageID:illustration.id imageData:dictionary failBlock:^(NSError *failBlock){
                    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                    if (failBlock != nil) {
                        NSLog(@"NSError");
                    } else {
                        NSLog(@"OK");
                        self.tabBarController.selectedIndex = 0;
                        [self.navigationController popToRootViewControllerAnimated:NO];
                    }
                }];
            } else {
                NSLog(@"%@", error);
            }
        }];
    } else { // Not update image
        NSDictionary *dictionary = @{ @"description" : self.tvComments.text };
        [[ILLustrationManager sharedManager] updateImageInfoWithImageID:illustration.id imageData:dictionary failBlock:^(NSError *failBlock){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (failBlock != nil) {
                NSLog(@"NSError");
            } else {
                NSLog(@"OK");
                self.tabBarController.selectedIndex = 0;
                [self.navigationController popToRootViewControllerAnimated:NO];
            }
        }];
    }
}

@end
