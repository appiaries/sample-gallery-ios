//
//  AppDelegate.m
//  Gallery
//
//  Created by Appiaries Corporation on 14/10/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferenceHelper.h"
#import "IllustrationImage.h"
#import "Illustration.h"

@implementation AppDelegate

#pragma mark - Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Activate SDK
    baas.config.datastoreID      = kDatastoreID;
    baas.config.applicationID    = kApplicationID;
    baas.config.applicationToken = kApplicationToken;
    [baas activate];

    // Register user definition classes
    [baas registerClasses:@[[Illustration class], [IllustrationImage class]]];

    // Set default settings if needed
    [self initializePreferenceIfNeeded];

    return YES;
}

- (void)initializePreferenceIfNeeded
{
    PreferenceHelper *pref = [PreferenceHelper sharedPreference];

    BOOL isAlreadyInitialized = [pref loadInitialized];
    if (!isAlreadyInitialized) {
        // Image display interval
        [pref saveDisplayInterval:5]; // (sec)
        // Comment hidden flag
        [pref saveCommentHidden:NO];

        [pref saveInitialized:YES];
    }
}

@end
