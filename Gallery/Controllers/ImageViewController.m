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
{
    NSString *_imageUrl;
}

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (id)initWithURL:(NSString *)url
{
    _imageUrl = url;
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupView];
}

#pragma mark - MISC
- (void)setupView
{
    ImageLoad *imgLoading = [[ImageLoad alloc] init];
    imgLoading.backgroundColor = [UIColor grayColor];
    [imgLoading loadImageFromURL:[NSURL URLWithString:_imageUrl]];
    [self.view addSubview:imgLoading];
}

@end
