//
//  AppDelegate.m
//  Gallery
//
//  Created by Appiaries Corporation on 14/10/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "GALDelegate.h"
#import "GalleryAPIClient.h"

@implementation GALDelegate

#pragma mark - Application lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Set default setting
    NSString *timeInterval = [[GalleryAPIClient sharedClient] getSettingTimeInterval];
    if (timeInterval == nil) {
        [[GalleryAPIClient sharedClient] saveSettingUserDefault:YES timeInterval:@"5秒" option:3];
    }
    
    return YES;
}
							
@end
