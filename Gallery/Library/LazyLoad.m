//
//  LazyLoad.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "LazyLoad.h"

@implementation LazyLoad

- (id)init
{
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        imageView.backgroundColor = [UIColor blueColor];
        [self addSubview:imageView];
        
        activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityView.center = CGPointMake(47, 36);
        [activityView startAnimating];
        
        [self addSubview:activityView];
    }
    return self;
}

#pragma mark - Public methods
- (void)loadImageFromURL:(NSURL *)url
{
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnection delegates
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData
{
	if (data == nil) {
        data = [[NSMutableData alloc] initWithCapacity:2048];
    }
	[data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	connection = nil;
	if ([[self subviews] count] > 0) {
        [[self subviews][0] removeFromSuperview];
    }
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];

	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
    
    [activityView stopAnimating];
	[self setNeedsLayout];
    
	data = nil;
}

@end
