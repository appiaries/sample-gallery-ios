//
// Created by Appiaries Corporation on 15/06/25.
// Copyright (c) 2015 Appiaries. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Illustration : ABDBObject <ABManagedProtocol>
#pragma mark - Properties
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *image_id;

#pragma mark - Initialization
+ (id)illustration;

#pragma mark - Public methods
- (NSString *)imageUrl;

@end
