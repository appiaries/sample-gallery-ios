//
//  ImageViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "ImageViewController.h"
#import "ImageLoad.h"


@implementation ImageViewController

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (id)initWithImageURL:(NSString *)url
{
    imageURL = url;
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[self addViewWithURL:imageURL NFrame:self.view.frame]];
}

#pragma mark - Private methods
- (UIView *)addViewWithURL:(NSString *)urlStr NFrame:(CGRect)rect
{
    ImageLoad *imgLoading = [[ImageLoad alloc] init];
    [imgLoading setBackgroundColor:[UIColor grayColor]];
    [imgLoading loadImageFromURL:[NSURL URLWithString:urlStr]];
    return imgLoading;
}

@end
