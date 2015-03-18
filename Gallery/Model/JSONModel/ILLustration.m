//
//  ILLustration.m
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ILLustration.h"

@implementation ILLustration
@synthesize description = _description;

#pragma mark - Initialization
- (id)initWithDict:(NSDictionary *)iLLustrationDict
{
    if (self = [super init]) {
        _id = iLLustrationDict[@"_id"];
        _description = iLLustrationDict[@"description"];
        _imageID = iLLustrationDict[@"image_id"];
        _cts = iLLustrationDict[@"_cts"];
        _uts = iLLustrationDict[@"_uts"];
        _cby = iLLustrationDict[@"_cby"];
        _uby = iLLustrationDict[@"_uby"];
    }
    return  self;
}

#pragma mark - Public methods
- (NSString *)getUrlFromImageID:(NSString *)imageID
{
    return [NSString stringWithFormat:@"https://api-datastore.appiaries.com/v1/bin/%@/%@/IllustrationImages/%@/_bin", APISDatastoreId, APISAppId, imageID];
}

@end
