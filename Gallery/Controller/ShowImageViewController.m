//
//  ShowImageViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 11/27/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ShowImageViewController.h"
#import "MBProgressHUD.h"
#import "ILLustrationManager.h"
#import "ILLustrationImageManager.h"
#import "ILLustration.h"
#import "ImageViewController.h"
#import "EditViewController.h"
#import "GalleryAPIClient.h"


#define TAG_SCROLL_VIEW 88888
#define TAG_PAGE_CONTROL 99999


@implementation ShowImageViewController

#pragma mark - Initialization
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [self.view reloadInputViews];
    arrayImages = [[NSMutableArray alloc] init];
    [super viewDidLoad];
}

- (void)viewWillDisappear:(BOOL)animated
{
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews) {
        if (subview.tag == TAG_PAGE_CONTROL || subview.tag == TAG_SCROLL_VIEW) {
            [subview removeFromSuperview];
        }
    }
    
    [slideTimer invalidate];
    slideTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    self.lbComment.text = @"";
    [arrayImages removeAllObjects];
    [self loadImages];
}

#pragma mark - Actions
// Pre image
- (void)actionButtonPre
{
    -- self.pageControl.currentPage;
    ILLustration *iLLustration = listImages[(NSUInteger)self.pageControl.currentPage];
    BOOL isComment = [[GalleryAPIClient sharedClient] getSettingComment];
    if (isComment) {
        self.lbComment.text = iLLustration.description;
    }
    [self checkShowOrHideButton:self.pageControl.currentPage];
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:CGPointMake(pageWidth * self.pageControl.currentPage, self.scrollView.bounds.origin.y)];
    
    // Add animation
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [self.scrollView.layer addAnimation:transition forKey:@"animateOpacity"];
    [CATransaction commit];
}

// Next image
- (void)actionButtonNext
{
    ++ self.pageControl.currentPage;
    ILLustration *iLLustration = listImages[(NSUInteger)self.pageControl.currentPage];
    
    BOOL isComment = [[GalleryAPIClient sharedClient] getSettingComment];
    if (isComment) {
        self.lbComment.text = iLLustration.description;
    }
    [self checkShowOrHideButton:self.pageControl.currentPage];
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    [self.scrollView setContentOffset:CGPointMake(pageWidth*self.pageControl.currentPage, self.scrollView.bounds.origin.y)];
    
    // Add animation
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromRight;
    [self.scrollView.layer addAnimation:transition forKey:@"animateOpacity"];
    [CATransaction commit];
}

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
    ILLustration *info = listImages[(NSUInteger)self.pageControl.currentPage];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"戻る";
    EditViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"editViewController"];
    [viewController setIllustration:info];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteSelectImage];
    }
}

#pragma mark - UIScrollView delegates
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    NSInteger page = (NSInteger)floor((self.scrollView.contentOffset.x -pageWidth/2)/pageWidth) +1;
    self.pageControl.currentPage = page;
    [self loadScrollViewPage:page];
}

#pragma mark - Private methods
- (void)checkShowOrHideButton:(NSInteger)pageNumber
{
    if (pageNumber == [listImages count] - 1) {
        preButton.alpha = 1;
        nextButton.alpha = 0;
    } else if (pageNumber == 0){
        preButton.alpha = 0;
        nextButton.alpha = 1;
    } else {
        preButton.alpha = 1;
        nextButton.alpha = 1;
    }
}

// Init changePage
- (void)initPageControl
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 300)];
    [_scrollView setPagingEnabled:YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setDelegate:self];
    [_scrollView setBackgroundColor:[UIColor lightGrayColor]];
    _scrollView.tag = TAG_SCROLL_VIEW;

    //ContentSize
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame) * [arrayImages count], 250)];
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.scrollView.frame.size.height + 60, 320, 20)];
    [_pageControl setBackgroundColor:[UIColor blackColor]];
    _pageControl.tag = TAG_PAGE_CONTROL;
    
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = [arrayImages count];
    [self.view addSubview:_pageControl];
    
    _viewController = [[NSMutableArray alloc] init];
    
    for (NSInteger i = 0; i < [arrayImages count]; i++) {
        [_viewController addObject:[NSNull null]];
    }
    
    slideTimer = [NSTimer scheduledTimerWithTimeInterval:[self getTimeInterval] target:self selector:@selector(scrollPages) userInfo:nil repeats:YES];
    
    for (int i = 0; i < [arrayImages count]; i ++) {
        [self loadScrollViewPage:i];
    }
    
    preButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 200, 30, 30)];
    [preButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [preButton addTarget:self action:@selector(actionButtonPre) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preButton];
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 200, 30, 30)];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [nextButton addTarget:self action:@selector(actionButtonNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    _pageControl.hidden = YES;
    [self checkShowOrHideButton:0];
}

- (void)loadScrollViewPage:(NSInteger)page
{
    if (page >= arrayImages.count) {
        return;
    }
    
    ILLustration *iLLustration = listImages[(NSUInteger)self.pageControl.currentPage];
    
    BOOL isComment = [[GalleryAPIClient sharedClient] getSettingComment];
    if (isComment) {
        self.lbComment.text = iLLustration.description;
    }
    [self checkShowOrHideButton:page];
    
    ImageViewController *imageViewController = self.viewController[(NSUInteger)page];
    if ([imageViewController isEqual:[NSNull null]]) {
        imageViewController = [[ImageViewController alloc] initWithImageURL:arrayImages[(NSUInteger)page]];
        self.viewController[(NSUInteger)page] = imageViewController;
    }
    
    if (imageViewController.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        imageViewController.view.frame = frame;
        
        [self.scrollView addSubview:imageViewController.view];
        [imageViewController didMoveToParentViewController:self];
    }
}

// Auto slide show image
- (void)scrollPages
{
    if (self.pageControl.currentPage == [listImages count] - 1) {
        ILLustration *iLLustration = listImages[0];
        BOOL isComment = [[GalleryAPIClient sharedClient] getSettingComment];
        if (isComment) {
            self.lbComment.text = iLLustration.description;
        }
        [self checkShowOrHideButton:0];
        ++ self.pageControl.currentPage;
    } else {
        ++ self.pageControl.currentPage;
        
        ILLustration *iLLustration = listImages[(NSUInteger)self.pageControl.currentPage];
        BOOL isComment = [[GalleryAPIClient sharedClient] getSettingComment];
        if (isComment) {
            self.lbComment.text = iLLustration.description;
        }
        [self checkShowOrHideButton:self.pageControl.currentPage];
    }
    
    CGFloat pageWidth = CGRectGetWidth(self.scrollView.frame);
    if (isFromStart) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        self.pageControl.currentPage = 0;
    } else {
        [self.scrollView setContentOffset:CGPointMake(pageWidth*self.pageControl.currentPage, self.scrollView.bounds.origin.y)];
    }
    
    if (!isFromStart) {
        // Add animation
        CATransition *transition = [CATransition animation];
        transition.duration = 0.30;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        
        [self.scrollView.layer addAnimation:transition forKey:@"animateOpacity"];
        [CATransaction commit];
    }

    isFromStart = (_pageControl.currentPage == _pageControl.numberOfPages - 1);
}

// Get list image from server
- (void)loadImages
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ILLustrationManager sharedManager] getImageListWithCompleteBlock:^(NSMutableArray *completeBlock){
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        listImages = completeBlock;
        if ([listImages count] == 0) {
            [[[UIAlertView alloc] initWithTitle:@""
                                        message:@"No image"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:@"", nil
            ] show];
            return;
        }
        
        // Sort image by time updated
        [self sortArrayImage];
        [self playShowImage:listImages];
        [self initPageControl];
    }
    failBlock:^(NSError *failBlock){
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)playShowImage:(NSArray *)listImage
{
    for (ILLustration *item in listImage) {
        NSString *urlImage = [item getUrlFromImageID:item.imageID];
        [arrayImages addObject:urlImage];
    }
}

// Get TimeInterval from userDefaults
- (NSInteger)getTimeInterval
{
    NSInteger second;
    NSString *timeInterval = [[GalleryAPIClient sharedClient] getSettingTimeInterval];
    if ([timeInterval isEqualToString:@"2秒"]) {
        second = 2;
    } else if ([timeInterval isEqualToString:@"5秒"]) {
        second = 5;
    } else {
        second = 10;
    }
    return second;
}

// Sort image array by time modify
- (void)sortArrayImage
{
    NSSortDescriptor *sortDescriptor1 = [[NSSortDescriptor alloc] initWithKey:@"_uts" ascending:NO];
    NSArray *sortDescriptors = [@[sortDescriptor1] mutableCopy];
    NSArray *array = [NSArray arrayWithArray:listImages];
    array = [array sortedArrayUsingDescriptors:sortDescriptors];
    listImages = [NSMutableArray arrayWithArray:array];
}

// Delete image
- (void)deleteSelectImage
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    ILLustration *iLLustration = listImages[(NSUInteger)self.pageControl.currentPage];
    
    [[ILLustrationImageManager sharedManager] deleteImageWithImageID:iLLustration.imageID failBlock:^(NSError *error){
        if (error == nil) {
            NSLog(@"Delete ILLustrationImage successfully");
            [[ILLustrationManager sharedManager] deleteImageWithImageID:iLLustration.id failBlock:^(NSError *error_){
                [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
                if(error_ == nil){
                    NSLog(@"Delete ILLustration successfully");
                    self.tabBarController.selectedIndex = 0;
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
