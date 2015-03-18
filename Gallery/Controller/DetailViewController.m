//
//  DetailViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"
#import "ILLustrationManager.h"
#import "ILLustrationImageManager.h"
#import "MBProgressHUD.h"


@implementation DetailViewController
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
    
    [MBProgressHUD showHUDAddedTo:self.imageView animated:YES];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        NSString *urlImage = [illustration getUrlFromImageID:illustration.imageID];
        NSURL *imageURL = [NSURL URLWithString:urlImage];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.imageView animated:YES];
            
            self.lbComment.text = illustration.description;
            self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            self.imageView.image = image;
        });
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.title = @"";
}

#pragma mark - Actions
// Click button delete
- (IBAction)actionDeleteImage:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"この画像を削除しますか？"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:@"キャンセル", nil
    ] show];
}

// Change Image
- (IBAction)actionChangeImage:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"戻る";
    EditViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editViewController"];
    [viewController setIllustration:illustration];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - UIAlertView delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteSelectImage];
    }
}

#pragma mark - Private methods
// Delete image
- (void)deleteSelectImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ILLustrationImageManager sharedManager] deleteImageWithImageID:illustration.imageID failBlock:^(NSError *error){
        if (error == nil) {
            NSLog(@"Delete ILLustrationImage successfully");
            [[ILLustrationManager sharedManager] deleteImageWithImageID:illustration.id failBlock:^(NSError *error_){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if (error_ == nil) {
                    NSLog(@"Delete ILLustration successfully");
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    NSLog(@"Delete ILLustration error");
                }
            }];
        } else {
            NSLog(@"Delete ILLustrationImage error");
        }
    }];
}

@end
