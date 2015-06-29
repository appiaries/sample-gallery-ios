//
//  AddViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "AddViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "IllustrationImage.h"
#import "Illustration.h"

@implementation AddViewController
{
    NSURL *_imageUrl;
    UIImage *_selectedImage;
}

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

    [self setupView];
}

#pragma mark - Actions
- (IBAction)actionBrowse:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)actionAddImage:(id)sender
{
    NSString *comment = [_commentTextView.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (!_imageUrl) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"画像が選択されていません"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
        ] show];
    } else if (comment.length == 0) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"コメントが入力されていません"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
        ] show];
    } else if (comment.length > 50) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"コメントが全角50文字を超えています"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
        ] show];
    } else {
        [self uploadImage];
    }
}

#pragma mark - TabBarController delegates
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex != 2) {
        _commentTextView.text = @"";
        _imageUrl = nil;
    }
}

#pragma mark - UIImagePicker delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    _selectedImage = info[UIImagePickerControllerOriginalImage];
    _imageUrl = info[UIImagePickerControllerReferenceURL];
}

#pragma mark - Keyboard handlers
// Dismiss Keyboard
- (void)doneButtonClickedDismissKeyboard
{
    [_commentTextView resignFirstResponder];
}

#pragma mark - MISC
- (void)setupView
{
    self.title = @"追加";

    _addButton.layer.cornerRadius = 7.0f;
    _addButton.layer.masksToBounds = YES;

    _containerView.layer.borderColor = [UIColor blackColor].CGColor;
    _containerView.layer.borderWidth = 1.0f;

    _commentTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _commentTextView.layer.borderWidth = 1.0f;

    // Add Done button to keyboard
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = @[
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)]
    ];
    [doneToolbar sizeToFit];
    _commentTextView.inputAccessoryView = doneToolbar;

    UITabBarController *tabBarController = (UITabBarController *)[UIApplication sharedApplication].keyWindow.rootViewController;
    tabBarController.delegate = self;
}

- (IllustrationImage *)illustrationImageWithURL:(NSURL *)url
{
    NSString *contentType;
    NSString *filename;
    NSData *data;

    NSString *ext = [url pathExtension];
    CFStringRef uti = (UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef) ext, NULL));
    if (UTTypeConformsTo(uti, kUTTypeJPEG)) {
        contentType = @"image/jpeg";
        filename = @"image.jpg";
        data = UIImageJPEGRepresentation(_selectedImage, 0.9f);
    } else if (UTTypeConformsTo(uti, kUTTypePNG)) {
        contentType = @"image/png";
        filename = @"image.png";
        data = UIImagePNGRepresentation(_selectedImage);
    } else {
        @throw [NSException exceptionWithName:@"UnsupportedMediaTypeException"
                                       reason:@"Detect unsupported media type of image"
                                     userInfo:nil];
    }

    IllustrationImage *image = [IllustrationImage image];
    image.name = filename;
    image.contentType = contentType;
    if (image.contentType) {
        image.tags = @[image.contentType];
    }
    image.data = data;

    return image;
}

- (void)uploadImage
{
    __weak typeof(self) weakSelf = self;
    //----------------------------------------
    // Create new illustration image
    //----------------------------------------
    [SVProgressHUD show];
    IllustrationImage *image = [self illustrationImageWithURL:_imageUrl];
    [image saveWithBlock:^(ABResult *ret, ABError *err){
        if (err == nil) {
            IllustrationImage *createdImage = ret.data;
            //----------------------------------------
            // Create new illustration
            //----------------------------------------
            Illustration *il = [Illustration illustration];
            il.image_id    = createdImage.ID;
            il.description = _commentTextView.text;
            [il saveWithBlock:^(ABResult *nestedRet, ABError *nestedErr) {
                if (nestedErr == nil) {
                    [SVProgressHUD dismiss];
                    _imageUrl = nil;
                    weakSelf.commentTextView.text = @"";
                    weakSelf.tabBarController.selectedIndex = 0;
                } else {
                    [SVProgressHUD showErrorWithStatus:err.description];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:err.description];
        }
    }];
}

@end
