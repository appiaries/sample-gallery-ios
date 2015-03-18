//
//  ILLustrationImage.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ILLustrationImage : NSObject
#pragma mark - Properties
@property (strong, nonatomic) NSString *id;
@property (strong, nonatomic) NSString *mimeType;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *data;
@property (strong, nonatomic) NSString *uri;
@property (strong, nonatomic) NSNumber *cts;
@property (strong, nonatomic) NSNumber *uts;
@property (strong, nonatomic) NSString *cby;
@property (strong, nonatomic) NSString *uby;

#pragma mark - Initialization
- (id)initWithDict:(NSDictionary *)imageDict;

@end
