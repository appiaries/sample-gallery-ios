//
//  ListImageViewController.m
//  Gallery
//
//  Created by Appiaries Corporation on 14/10/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ListImageViewController.h"
#import "ILLustration.h"
#import "ILLustrationManager.h"
#import "DetailViewController.h"
#import "LazyLoad.h"
#import "MBProgressHUD.h"


@implementation ListImageViewController

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
	self.myCollectionView.delegate = self;
    self.myCollectionView.dataSource = self;
    
    [self loadImages];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [self loadImages];
}

- (void)viewWillDisappear:(BOOL)animated
{
    listImages = [NSArray array];
    [self.myCollectionView reloadData];
}

#pragma mark - UICollectionView delegates
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return listImages.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"CellImage";
    
    UICollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    ILLustration *iLLustration = listImages[(NSUInteger)indexPath.row];
    NSString *urlImage = [iLLustration getUrlFromImageID:iLLustration.imageID];
    
    [cell addSubview:[self addViewWithURL:urlImage NFrame:CGRectMake(0, 0, 93, 72)]];
        
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ILLustration *iLLustration = listImages[(NSUInteger)indexPath.row];
    DetailViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailViewController"];
    [viewController setIllustration:iLLustration];
    self.navigationItem.title = @"戻る";
    self.navigationController.navigationBarHidden = NO;

    [self.navigationController pushViewController:viewController animated:YES];
}

- (UIView *)addViewWithURL:(NSString *)urlStr NFrame:(CGRect)rect
{
    LazyLoad *lazyLoading = [[LazyLoad alloc] init];
    [lazyLoading setBackgroundColor:[UIColor grayColor]];
    [lazyLoading setFrame:rect];
    [lazyLoading loadImageFromURL:[NSURL URLWithString:urlStr]];
    return lazyLoading;
}

#pragma mark - Private methods
- (void)loadImages
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[ILLustrationManager sharedManager] getImageListWithCompleteBlock:^(NSMutableArray *completeBlock){
        listImages = completeBlock;
        
        // Sort image by time updated
        [self sortArrayImage];
        [self.myCollectionView reloadData];
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }
    failBlock:^(NSError *failBlock){
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    }];
}

- (void)sortArrayImage
{
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"_uts" ascending:NO];
    NSArray *sortDescriptors = [@[sortDescriptor] mutableCopy];
    NSArray *array = [NSArray arrayWithArray:listImages];
    array = [array sortedArrayUsingDescriptors:sortDescriptors];
    listImages = [NSMutableArray arrayWithArray:array];
}

@end
