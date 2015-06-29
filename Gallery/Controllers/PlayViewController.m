//
//  PlayViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 11/27/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "PlayViewController.h"
#import "Illustration.h"
#import "ImageViewController.h"
#import "EditViewController.h"
#import "PreferenceHelper.h"
#import "IllustrationImage.h"


#define TAG_SCROLL_VIEW 88888
#define TAG_PAGE_CONTROL 99999


@implementation PlayViewController
{
    NSArray *_illustrations;
    NSTimer *_slideTimer;
    NSMutableArray *_imageUrls;
    UIButton *_preButton;
    UIButton *_nextButton;
    BOOL _backToFirst;
    NSInteger _displayInterval;
    BOOL _commentHidden;
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
    [self.view reloadInputViews];
    _imageUrls = [@[] mutableCopy];

    [super viewDidLoad];
};

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews) {
        if (subview.tag == TAG_PAGE_CONTROL || subview.tag == TAG_SCROLL_VIEW) {
            [subview removeFromSuperview];
        }
    }
    
    [_slideTimer invalidate];
    _slideTimer = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = YES;
    _commentLabel.text = @"";

    _displayInterval = [[PreferenceHelper sharedPreference] loadDisplayInterval];
    _commentHidden   = [[PreferenceHelper sharedPreference] loadCommentHidden];

    [_imageUrls removeAllObjects];
    [self loadImages];
}

#pragma mark - Actions
- (void)actionButtonPre
{
    _pageControl.currentPage --;
    Illustration *il = _illustrations[(NSUInteger)_pageControl.currentPage];
    if (!_commentHidden) {
        _commentLabel.text = il.description;
    }
    [self checkShowOrHideButton:_pageControl.currentPage];
    
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    [_scrollView setContentOffset:CGPointMake(pageWidth * _pageControl.currentPage, _scrollView.bounds.origin.y)];
    
    CATransition *transition = [CATransition animation];
    transition.duration = 0.30;
    transition.type = kCATransitionPush;
    transition.subtype = kCATransitionFromLeft;
    [_scrollView.layer addAnimation:transition forKey:@"animateOpacity"];
    [CATransaction commit];
}

// Next image
- (void)actionButtonNext
{
    _pageControl.currentPage ++;
    Illustration *il = _illustrations[(NSUInteger)_pageControl.currentPage];

    if (!_commentHidden) {
        _commentLabel.text = il.description;
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
    vc.illustration = _illustrations[(NSUInteger)_pageControl.currentPage];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - AlertView delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self deleteSelectedImage];
    }
}

#pragma mark - UIScrollView delegates
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat width = CGRectGetWidth(_scrollView.frame);
    NSInteger page = (NSInteger)floor((_scrollView.contentOffset.x - width /2)/ width) +1;
    _pageControl.currentPage = page;
    [self loadScrollViewPage:page];
}

#pragma mark - Private methods
- (void)checkShowOrHideButton:(NSInteger)pageNumber
{
    if (pageNumber == [_illustrations count] - 1) {
        _preButton.alpha = 1;
        _nextButton.alpha = 0;
    } else if (pageNumber == 0) {
        _preButton.alpha = 0;
        _nextButton.alpha = 1;
    } else {
        _preButton.alpha = 1;
        _nextButton.alpha = 1;
    }
}

- (void)initPageControl
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 300)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.backgroundColor = [UIColor lightGrayColor];
    _scrollView.tag = TAG_SCROLL_VIEW;
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame) * [_imageUrls count], 250)];
    [self.view addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _scrollView.frame.size.height + 60, 320, 20)];
    _pageControl.backgroundColor = [UIColor blackColor];
    _pageControl.tag = TAG_PAGE_CONTROL;
    _pageControl.currentPage = 0;
    _pageControl.numberOfPages = [_imageUrls count];
    [self.view addSubview:_pageControl];
    
    _viewControllers = [@[] mutableCopy];
    for (NSInteger i = 0; i < [_imageUrls count]; i++) {
        [_viewControllers addObject:[NSNull null]];
    }

    _slideTimer = [NSTimer scheduledTimerWithTimeInterval:_displayInterval target:self selector:@selector(scrollPages) userInfo:nil repeats:YES];
    
    for (int i = 0; i < [_imageUrls count]; i ++) {
        [self loadScrollViewPage:i];
    }
    
    _preButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 200, 30, 30)];
    [_preButton setBackgroundImage:[UIImage imageNamed:@"btn_back"] forState:UIControlStateNormal];
    [_preButton addTarget:self action:@selector(actionButtonPre) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_preButton];
    
    _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(285, 200, 30, 30)];
    [_nextButton setBackgroundImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [_nextButton addTarget:self action:@selector(actionButtonNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    
    _pageControl.hidden = YES;
    [self checkShowOrHideButton:0];
}

- (void)loadScrollViewPage:(NSInteger)page
{
    if (page >= _imageUrls.count) {
        return;
    }
    
    Illustration *il = _illustrations[(NSUInteger)_pageControl.currentPage];

    if (!_commentHidden) {
        _commentLabel.text = il.description;
    }
    [self checkShowOrHideButton:page];
    
    ImageViewController *vc = _viewControllers[(NSUInteger)page];
    if ([vc isEqual:[NSNull null]]) {
        vc = [[ImageViewController alloc] initWithURL:_imageUrls[(NSUInteger) page]];
        _viewControllers[(NSUInteger)page] = vc;
    }
    
    if (vc.view.superview == nil) {
        CGRect frame = _scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        vc.view.frame = frame;
        
        [_scrollView addSubview:vc.view];
        [vc didMoveToParentViewController:self];
    }
}

// Auto slide show image
- (void)scrollPages
{
    if (_pageControl.currentPage == [_illustrations count] - 1) {
        Illustration *il = _illustrations[0];
        if (!_commentHidden) {
            _commentLabel.text = il.description;
        }
        [self checkShowOrHideButton:0];
        _pageControl.currentPage++;
    } else {
        _pageControl.currentPage++;
        
        Illustration *il = _illustrations[(NSUInteger)_pageControl.currentPage];
        if (!_commentHidden) {
            _commentLabel.text = il.description;
        }
        [self checkShowOrHideButton:_pageControl.currentPage];
    }
    
    CGFloat pageWidth = CGRectGetWidth(_scrollView.frame);
    if (_backToFirst) {
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        _pageControl.currentPage = 0;
    } else {
        [_scrollView setContentOffset:CGPointMake(pageWidth*_pageControl.currentPage, _scrollView.bounds.origin.y)];
    }
    
    if (!_backToFirst) {
        // Add animation
        CATransition *transition = [CATransition animation];
        transition.duration = 0.30;
        transition.type = kCATransitionPush;
        transition.subtype = kCATransitionFromRight;
        
        [_scrollView.layer addAnimation:transition forKey:@"animateOpacity"];
        [CATransaction commit];
    }

    _backToFirst = (_pageControl.currentPage == _pageControl.numberOfPages - 1);
}

- (void)loadImages
{
    __weak typeof(self) weakSelf = self;
    //----------------------------------------
    // Find all illustrations
    //----------------------------------------
    [SVProgressHUD show];
    ABQuery *query = [[Illustration query] orderBy:@"_uts" direction:ABSortDESC];
    [baas.db findWithQuery:query block:^(ABResult *ret, ABError *err){
        if (err == nil) {
            [SVProgressHUD dismiss];
            NSArray *foundArray = ret.data;
            if ([foundArray count] == 0) {
                [[[UIAlertView alloc] initWithTitle:@""
                                            message:@"No image"
                                           delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:@"", nil
                ] show];
            }
            _illustrations = foundArray;
            [weakSelf playShowImage:_illustrations];
            [weakSelf initPageControl];
        } else {
            [SVProgressHUD showErrorWithStatus:err.description];
        }
    }];
}

- (void)playShowImage:(NSArray *)illustrations
{
    for (Illustration *il in illustrations) {
        [_imageUrls addObject:il.imageUrl];
    }
}

- (void)deleteSelectedImage
{
    __weak typeof(self) weakSelf = self;
    //----------------------------------------
    // Delete illustration
    //----------------------------------------
    [SVProgressHUD show];
    Illustration *il = _illustrations[(NSUInteger)_pageControl.currentPage];
    [il deleteWithBlock:^(ABResult *ret, ABError *err){
        if (err == nil) {
            //----------------------------------------
            // Delete illustration image
            //----------------------------------------
            IllustrationImage *image = [IllustrationImage image];
            image.ID = il.image_id;
            [image deleteWithBlock:^(ABResult *nestedRet, ABError *nestedErr){
                if (nestedErr == nil) {
                    weakSelf.tabBarController.selectedIndex = 0;
                    [SVProgressHUD dismiss];
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
