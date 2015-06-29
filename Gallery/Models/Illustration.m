//
// Created by Appiaries Corporation on 15/06/25.
// Copyright (c) 2015 Appiaries. All rights reserved.
//

#import "Illustration.h"


@implementation Illustration
@dynamic description;
@dynamic image_id;

#pragma mark - Initialization
+ (id)illustration
{
    return [[self class] object];
}

#pragma mark - ABManagedProtocol
+ (NSString *)collectionID
{
    return @"Illustrations";
}

#pragma mark - Public methods
- (NSString *)imageUrl
{
    if (self.image_id) {
        return [NSString stringWithFormat:@"https://api-datastore.appiaries.com/v1/bin/%@/%@/IllustrationImages/%@/_bin", kDatastoreID, kApplicationID, self.image_id];
    } else {
        return nil;
    }
}

@end
