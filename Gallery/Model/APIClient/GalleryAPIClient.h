//
//  GalleryAPIClient.h
//  Gallery
//
//  Created by Appiaries Corporation on 1/9/15.
//  Copyright (c) 2015 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface GalleryAPIClient : AFHTTPSessionManager
#pragma mark - Properties
@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSString *storeToken;
@property (nonatomic, readonly) NSDate *tokenExpireDate;
@property (nonatomic, readonly) NSString *userId;

#pragma mark - Initialization
+ (instancetype)sharedClient;

#pragma mark - Public methods
- (void)saveSettingUserDefault:(BOOL)isComment timeInterval:(NSString *)timeInterval option:(NSInteger)option;
- (NSString *)getSettingTimeInterval;
- (BOOL)getSettingComment;

@end
