//
//  GalleryAPIClient.m
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import "GalleryAPIClient.h"
#import "NSURL+dictionaryFromQueryString.h"
#import "GALConfigurations.h"


// UserDefaults key
static NSString *const kUserDefaultsKeySlideshowInterval = @"KeySlideshowInterval";
static NSString *const kUserDefaultsKeySettingComment = @"KeySettingComment";


@interface GalleryAPIClient ()
#pragma mark - Properties (Private)
@property (nonatomic, readwrite) NSString *accessToken;
@property (nonatomic, readwrite) NSString *storeToken;
@property (nonatomic, readwrite) NSDate *tokenExpireDate;
@property (nonatomic, readwrite) NSString *userId;
@end


@implementation GalleryAPIClient

#pragma mark - Initialization
+ (instancetype)sharedClient
{
    static GalleryAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        configuration.HTTPAdditionalHeaders = @{ @"Accept" : @"application/json" };
        _sharedClient = [[GalleryAPIClient alloc] initWithSessionConfiguration:configuration];
        //reachability
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    //共通処理
    if (_sharedClient != nil) {
    }
    
    return _sharedClient;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Public methods
- (void)saveSettingUserDefault:(BOOL)isComment timeInterval:(NSString *)timeInterval option:(NSInteger)option
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    
    if (option == 1) { // Save only SettingComment
        [userDefault setBool:isComment forKey:kUserDefaultsKeySettingComment];
    } else if (option == 2) { // Save only SlideshowInterval
        [userDefault setObject:timeInterval forKey:kUserDefaultsKeySlideshowInterval];
    } else { // Save all
        [userDefault setBool:isComment forKey:kUserDefaultsKeySettingComment];
        [userDefault setObject:timeInterval forKey:kUserDefaultsKeySlideshowInterval];
    }
    [userDefault synchronize];
}

- (NSString *)getSettingTimeInterval
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:kUserDefaultsKeySlideshowInterval];
}

- (BOOL)getSettingComment
{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault boolForKey:kUserDefaultsKeySettingComment];
}

@end
