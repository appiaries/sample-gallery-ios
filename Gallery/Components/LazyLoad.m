//
//  LazyLoad.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "LazyLoad.h"

@implementation LazyLoad
{
    NSURLConnection *_connection;
    UIActivityIndicatorView *_activityView;
    NSMutableData *_data;
}

- (id)init
{
    self = [super init];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.frame];
        imageView.backgroundColor = [UIColor blueColor];
        [self addSubview:imageView];
        
        _activityView =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        _activityView.center = CGPointMake(47, 36);
        [_activityView startAnimating];

        [self addSubview:_activityView];
    }
    return self;
}

#pragma mark - Public methods
- (void)loadImageFromURL:(NSURL *)url
{
	NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	_connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

#pragma mark - NSURLConnection delegates
- (void)connection:(NSURLConnection *)theConnection didReceiveData:(NSData *)incrementalData
{
	if (_data == nil) {
        _data = [[NSMutableData alloc] initWithCapacity:2048];
    }
	[_data appendData:incrementalData];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)theConnection
{
	_connection = nil;
	if ([[self subviews] count] > 0) {
        [[self subviews][0] removeFromSuperview];
    }
	
	UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:_data]];

	[self addSubview:imageView];
	imageView.frame = self.bounds;
	[imageView setNeedsLayout];
    
    [_activityView stopAnimating];
	[self setNeedsLayout];
    
	_data = nil;
}

@end
