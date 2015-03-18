//
//  ILLustrationImageManager.h
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ILLustrationImage;

@interface ILLustrationImageManager : NSObject
#pragma mark - Properties
@property (readonly, nonatomic) ILLustrationImage *imageInfo;

#pragma mark - Initialization
+ (ILLustrationImageManager *)sharedManager;

#pragma mark - Public methods
- (void)addImageData:(NSData *)imageData fileName:(NSString *)fileName typeImage:(NSString *)type withCompleteBlock:(void (^)(ILLustrationImage *))completeBlock failBlock:(void(^)(NSError *))failBlock;
- (void)updateImageDataWithID:(NSString *)imageID imageData:(NSData *)imageData fileName:(NSString *)fileName typeImage:(NSString *)type failBlock:(void(^)(NSError *))failBlock;
- (void)deleteImageWithImageID:(NSString *)imageID failBlock:(void (^)(NSError *))failedBlock;

@end
