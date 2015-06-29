//
//  PreferenceHelper.h
//  Gallery
//
//  Created by Appiaries Corporation on 15/06/25.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>

@interface PreferenceHelper : NSObject

#pragma mark - Initialization
+ (id)sharedPreference;

#pragma mark - Helper methods
- (BOOL)loadInitialized;
- (void)saveInitialized:(BOOL)initialized;
- (NSInteger)loadDisplayInterval;
- (void)saveDisplayInterval:(NSInteger)interval;
- (BOOL)loadCommentHidden;
- (void)saveCommentHidden:(BOOL)hidden;

@end