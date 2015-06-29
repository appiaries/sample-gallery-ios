//
// Created by Appiaries Corporation on 15/06/25.
// Copyright (c) 2015 Appiaries. All rights reserved.
//

#import "IllustrationImage.h"


@implementation IllustrationImage

#pragma mark - Initialization
+ (id)image
{
    return [[self class] file];
}

#pragma mark - ABManagedProtocol
+ (NSString *)collectionID
{
    return @"IllustrationImages";
}

@end



