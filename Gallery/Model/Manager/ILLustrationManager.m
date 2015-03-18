//
//  ILLustrationManager.m
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ILLustrationManager.h"
#import "ILLustration.h"

@interface ILLustrationManager ()
#pragma mark - Properties (Private)
@property (readwrite, nonatomic) ILLustration *imageInfo;
@end


@implementation ILLustrationManager

APISSession *apisSession;

+ (ILLustrationManager *)sharedManager
{
    static ILLustrationManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ILLustrationManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (id)initSharedInstance
{
    self = [super init];
    if (self) {
        self.imageInfo = [[ILLustration alloc] init];
    }
    return self;
}

- (id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

- (void)initialize
{
    apisSession = [APISSession sharedSession];
    apisSession.datastoreId = APISDatastoreId;
    apisSession.applicationId = APISAppId;
    apisSession.applicationToken = APISAppToken;
}

#pragma mark - Public methods
- (void)addImageInfoWithData:(NSDictionary *)data failBlock:(void(^)(NSError *))failBlock
{
    [self initialize];
    
    NSString *collectionId = @"Illustrations";
    APISJsonAPIClient *api = [[APISSession sharedSession] createJsonAPIClientWithCollectionId:collectionId];
    
    [api createJsonObjectWithId:@"" data:data
                        success:^(APISResponseObject *response){
                            NSLog(@"JSONオブジェクトの登録成功 [ステータス:%ld, レスポンス:%@, ロケーション:%@]",
                                  (long)response.statusCode, response.data, response.location);
                            failBlock(nil);
                        }
                        failure:^(NSError *error){
                            NSLog(@"JSONオブジェクトの登録失敗 [原因:%@]", [error localizedDescription]);
                            failBlock(error);
                        }];
}

- (void)getImageListWithCompleteBlock:(void (^)(NSMutableArray *))completeBlock failBlock:(void (^)(NSError *))failedBlock
{
    [self initialize];
    
    NSString *collectionId = @"Illustrations";
    
    APISQueryCondition *query = [[APISQueryCondition alloc] init];
    
    // JSONオブジェクト検索APIの実行
    APISJsonAPIClient *api = [[APISSession sharedSession] createJsonAPIClientWithCollectionId:collectionId];
    [api searchJsonObjectsWithQueryCondition:query
                                     success:^(APISResponseObject *response){
                                         
                                         NSMutableArray *objList = [[NSMutableArray alloc] init];
                                         
                                         if ((response.data) && [response.data isKindOfClass:[NSDictionary class]]) {
                                             NSArray *objs = response.data[@"_objs"];
                                             
                                             if ([objs isKindOfClass:[NSArray class]] && [objs count] > 0) {
                                                 for (NSDictionary *v in objs) {
                                                     ILLustration *iLLustration = [[ILLustration alloc] initWithDict:v];
                                                     [objList addObject:iLLustration];
                                                 }
                                             }
                                         }
                                         if (completeBlock) completeBlock(objList);
                                         NSLog(@"getImageListWithCompleteBlock success: %li Object", (long)[objList count]);
                                     }
                                     failure:^(NSError *error){
                                         NSLog(@"getImageListWithCompleteBlock error");
                                         failedBlock(error);
                                     }];
}

- (void)updateImageInfoWithImageID:(NSString *)imageID imageData:(NSDictionary *)data failBlock:(void(^)(NSError *))failBlock
{
    [self initialize];
    
    NSString *collectionId = @"Illustrations";

    // JSONオブジェクト更新APIの実行
    APISJsonAPIClient *api = [[APISSession sharedSession] createJsonAPIClientWithCollectionId:collectionId];
    [api updateJsonObjectWithId:imageID
                           data:data
                        success:^(APISResponseObject *response){
                            NSLog(@"JSONオブジェクトの更新成功 [ステータス:%ld, レスポンス:%@, ロケーション:%@]",
                                  (long)response.statusCode, response.data, response.location);
                            failBlock(nil);
                        }
                        failure:^(NSError *error){
                            NSLog(@"JSONオブジェクトの更新失敗 [原因:%@]", [error localizedDescription]);
                            failBlock(error);
                        }];
}

- (void)deleteImageWithImageID:(NSString *)imageID failBlock:(void (^)(NSError *))failedBlock
{
    [self initialize];
    
    NSString *collectionId = @"Illustrations"; // 削除対象のJSONオブジェクトが格納されているコレクションのIDを指定します
    // JSONオブジェクト削除APIの実行
    APISJsonAPIClient *api = [[APISSession sharedSession] createJsonAPIClientWithCollectionId:collectionId];
    
    [api deleteJsonObjectWithId:imageID success:^(APISResponseObject *response){
        NSLog(@"JSONオブジェクトの一括削除成功 [ステータス:%ld, レスポンス:%@]",
              (long)response.statusCode, response.data);
        failedBlock(nil);
    } failure:^(NSError *error){
        NSLog(@"JSONオブジェクトの一括削除失敗 [原因:%@]", [error localizedDescription]);
        failedBlock(error);
    }];
}

@end
