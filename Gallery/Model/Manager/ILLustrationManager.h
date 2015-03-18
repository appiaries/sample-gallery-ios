//
//  ILLustrationManager.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ILLustration;

@interface ILLustrationManager : NSObject
#pragma mark - Properties
@property (readonly, nonatomic) ILLustration *imageInfo;

#pragma mark - Initialization
+ (ILLustrationManager *)sharedManager;

#pragma mark - Public methods
- (void)addImageInfoWithData:(NSDictionary *)data failBlock:(void(^)(NSError *))failBlock;
- (void)getImageListWithCompleteBlock:(void (^)(NSMutableArray *))completeBlock failBlock:(void (^)(NSError *))failedBlock;
- (void)updateImageInfoWithImageID:(NSString *)imageID imageData:(NSDictionary *)data failBlock:(void(^)(NSError *))failBlock;
- (void)deleteImageWithImageID:(NSString *)imageID failBlock:(void (^)(NSError *))failedBlock;

@end
