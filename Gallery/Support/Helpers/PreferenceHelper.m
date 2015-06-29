//
//  PreferenceHelper.m
//  Gallery
//
//  Created by Appiaries Corporation on 15/06/25.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "PreferenceHelper.h"

static NSString *const kPreferenceInitializedKey     = @"gallery.initialized";
static NSString *const kPreferenceDisplayIntervalKey = @"gallery.image.displayInterval";
static NSString *const kPreferenceCommentHiddenKey   = @"gallery.comment.hidden";

@implementation PreferenceHelper

#pragma mark - Initialization
+ (instancetype)sharedPreference
{
    static PreferenceHelper *_sharedPreference = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedPreference = [[PreferenceHelper alloc] initSharedPreference];
    });
    return _sharedPreference;
}

- (instancetype)initSharedPreference
{
    self = [super init];
    return self;
}

- (id)init {
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark - Helper methods
- (BOOL)loadInitialized {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPreferenceInitializedKey];
}
- (void)saveInitialized:(BOOL)initialized {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:initialized forKey:kPreferenceInitializedKey];
}

- (NSInteger)loadDisplayInterval {
    return [[NSUserDefaults standardUserDefaults] integerForKey:kPreferenceDisplayIntervalKey];
}
- (void)saveDisplayInterval:(NSInteger)interval {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:interval forKey:kPreferenceDisplayIntervalKey];
}

- (BOOL)loadCommentHidden {
    return [[NSUserDefaults standardUserDefaults] boolForKey:kPreferenceCommentHiddenKey];
}
- (void)saveCommentHidden:(BOOL)hidden {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:hidden forKey:kPreferenceCommentHiddenKey];
}

@end
