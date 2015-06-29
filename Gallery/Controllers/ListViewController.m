//
//  ListViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 14/10/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ListViewController.h"
#import "DetailViewController.h"
#import "LazyLoad.h"
#import "Illustration.h"


@implementation ListViewController
{
    NSArray *_illustrations;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setupView];

    [self loadImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self loadImages];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _illustrations = [NSArray array];
    [_collectionView reloadData];
}

#pragma mark - UICollectionView delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_illustrations count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellImage";
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Illustration *il = _illustrations[(NSUInteger)indexPath.row];

    [cell addSubview:[self imageViewWithURL:il.imageUrl frame:CGRectMake(0, 0, 93, 72)]];
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Illustration *il = _illustrations[(NSUInteger)indexPath.row];
    DetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [vc setIllustration:il];
    self.navigationItem.title = @"戻る";
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:vc animated:YES];
}

- (UIView *)imageViewWithURL:(NSString *)url frame:(CGRect)rect
{
    LazyLoad *lazyLoading = [[LazyLoad alloc] init];
    lazyLoading.backgroundColor = [UIColor grayColor];
    lazyLoading.frame = rect;
    [lazyLoading loadImageFromURL:[NSURL URLWithString:url]];
    return lazyLoading;
}

#pragma mark - MISC
- (void)setupView
{
    self.navigationController.navigationBarHidden = YES;

    _collectionView.delegate = self;
    _collectionView.dataSource = self;
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
            _illustrations = foundArray;
            [weakSelf.collectionView reloadData];
        } else {
            [SVProgressHUD showErrorWithStatus:err.description];
        }
    }];
}

@end
