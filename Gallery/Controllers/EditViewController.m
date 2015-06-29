//
//  EditViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <MobileCoreServices/MobileCoreServices.h>
#import "EditViewController.h"
#import "Illustration.h"
#import "IllustrationImage.h"


@implementation EditViewController
{
    NSURL *_imageUrl;
    UIImage *_selectedImage;
    BOOL _needsUpdateImage;
}

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

    [self setupView];

    _imageUrl = [NSURL URLWithString:_illustration.imageUrl];
    _commentTextView.text  = _illustration.description;
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
    } else if ([comment length] == 0) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"コメントが入力されていません"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
        ] show];
    } else if ([comment length] > 50) {
        [[[UIAlertView alloc] initWithTitle:@""
                                    message:@"コメントが全角50文字を超えています"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil
        ] show];
    } else {
        [self updateImage];
    }
}

#pragma mark - UIImagePickerController delegates
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];

    _selectedImage = info[UIImagePickerControllerOriginalImage];
    _imageUrl = info[UIImagePickerControllerReferenceURL];
    _needsUpdateImage = YES;
}

#pragma mark - Keyboard handlers
- (void)doneButtonClickedDismissKeyboard
{
    [_commentTextView resignFirstResponder];
}

#pragma mark - MISC
- (void)setupView
{
    self.title = @"編集";

    _editButton.layer.cornerRadius = 7.0f;
    _editButton.layer.masksToBounds = YES;

    _containerView.layer.borderColor = [UIColor blackColor].CGColor;
    _containerView.layer.borderWidth = 1.0f;

    _commentTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _commentTextView.layer.borderWidth = 1.0f;

    // Add Done button to keyboard
    UIToolbar *doneToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = @[
            [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
            [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
    ];
    [doneToolbar sizeToFit];
    _commentTextView.inputAccessoryView = doneToolbar;
}

- (IllustrationImage *)illustrationImageWithURL:(NSURL *)url objectID:(NSString *)objectID
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
    if (objectID) {
        image.ID = objectID;
        [image apply];
    }
    image.name = filename;
    image.contentType = contentType;
    if (image.contentType) {
        image.tags = @[image.contentType];
    }
    image.data = data;

    return image;
}

- (void)updateImage
{
    __weak typeof(self) weakSelf = self;

    if (_needsUpdateImage) {
        //----------------------------------------
        // Update illustration image
        //----------------------------------------
        [SVProgressHUD show];
        IllustrationImage *image = [self illustrationImageWithURL:_imageUrl objectID:_illustration.image_id];
        [image saveWithBlock:^(ABResult *ret, ABError *err){
            if (err == nil) {
                IllustrationImage *updatedImage = ret.data;
                NSLog(@"Image illustration updated: %@", updatedImage);
                //----------------------------------------
                // Update illustration
                //----------------------------------------
                _illustration.description = _commentTextView.text;
                [_illustration saveWithBlock:^(ABResult *nestedRet, ABError *nestedErr){
                    if (nestedErr == nil) {
                        [SVProgressHUD dismiss];
                        weakSelf.tabBarController.selectedIndex = 0;
                        [weakSelf.navigationController popToRootViewControllerAnimated:NO];
                    } else {
                        [SVProgressHUD showErrorWithStatus:nestedErr.description];
                    }
                }];
            } else {
                [SVProgressHUD showErrorWithStatus:err.description];
            }
        }];

    } else {
        //----------------------------------------
        // Update illustration
        //----------------------------------------
        [SVProgressHUD show];
        _illustration.description = _commentTextView.text;
        [_illustration saveWithBlock:^(ABResult *ret, ABError *err){
            if (err == nil) {
                [SVProgressHUD dismiss];
                weakSelf.tabBarController.selectedIndex = 0;
                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [SVProgressHUD showErrorWithStatus:err.description];
            }
        }];
    }
}

@end
