//
//  DetailViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "DetailViewController.h"
#import "EditViewController.h"
#import "Illustration.h"
#import "IllustrationImage.h"


@implementation DetailViewController

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

    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"";
}

#pragma mark - Actions
- (IBAction)actionDeleteImage:(id)sender
{
    [[[UIAlertView alloc] initWithTitle:@""
                                message:@"この画像を削除しますか？"
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:@"キャンセル", nil
    ] show];
}

- (IBAction)actionChangeImage:(id)sender
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"戻る";
    EditViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"editViewController"];
    vc.illustration = _illustration;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIAlertView delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteSelectImage];
    }
}

#pragma mark - MISC
- (void)loadData
{
    __weak typeof(self) weakSelf = self;
    [SVProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSURL *url = [NSURL URLWithString:_illustration.imageUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];

        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.commentLabel.text = _illustration.description;
            weakSelf.imageView.contentMode = UIViewContentModeScaleAspectFit;
            weakSelf.imageView.image = image;
            [SVProgressHUD dismiss];
        });
    });
}

- (void)deleteSelectImage
{
    __weak typeof(self) weakSelf = self;
    //----------------------------------------
    // Delete illustration
    //----------------------------------------
    [SVProgressHUD show];
    [_illustration deleteWithBlock:^(ABResult *ret, ABError *err){
        if (err == nil) {
            //----------------------------------------
            // Delete illustration image
            //----------------------------------------
            IllustrationImage *image = [IllustrationImage image];
            image.ID = _illustration.image_id;
            [image deleteWithBlock:^(ABResult *nestedRet, ABError *nestedErr){
                if (nestedErr == nil) {
                    [SVProgressHUD dismiss];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [SVProgressHUD showErrorWithStatus:nestedErr.description];
                }
            }];
        } else {
            [SVProgressHUD showErrorWithStatus:err.description];
        }
    }];
}

@end
