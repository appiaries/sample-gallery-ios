//
//  ILLustration.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILLustration : NSObject
#pragma mark - Properties
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *imageID;
@property (strong, nonatomic) NSNumber *cts;
@property (strong, nonatomic) NSNumber *uts;
@property (strong, nonatomic) NSString *cby;
@property (strong, nonatomic) NSString *uby;

#pragma mark - Initialization
- (id)initWithDict:(NSDictionary *)iLLustrationDict;

#pragma mark - Public methods
- (NSString *)getUrlFromImageID:(NSString *)imageID;

@end
