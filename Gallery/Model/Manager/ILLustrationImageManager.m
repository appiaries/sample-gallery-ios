//
//  ILLustrationImageManager.m
//  Gallery
//
//  Created by Appiaries Corporation on 11/28/14.
//  Copyright (c) 2014 Appiaries Corporation. All rights reserved.
//

#import "ILLustrationImageManager.h"
#import "ILLustrationImage.h"

@interface ILLustrationImageManager ()
#pragma mark - Properties (Private)
@property (readwrite, nonatomic) ILLustrationImage *imageInfo;
@end


@implementation ILLustrationImageManager

APISSession *apisSession;

+ (ILLustrationImageManager *)sharedManager
{
    static ILLustrationImageManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ILLustrationImageManager alloc] initSharedInstance];
    });
    return sharedInstance;
}

- (id)initSharedInstance {
    self = [super init];
    if (self) {
        self.imageInfo = [[ILLustrationImage alloc] init];
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
- (void)addImageData:(NSData *)imageData fileName:(NSString *)fileName typeImage:(NSString *)type withCompleteBlock:(void (^)(ILLustrationImage *))completeBlock failBlock:(void(^)(NSError *))failBlock
{
    // 会員・ログインAPIの実行
    [self initialize];
    
    NSString *collectionId = @"IllustrationImages"; // バイナリオブジェクトを登録するコレクションのIDを指定します
    NSString *objectId = @""; // 登録するバイナリオブジェクトのIDを指定します（未指定の場合はシステム側でランダムな文字列が割り当てられます）
    NSString *metaType = [NSString stringWithFormat:@"image/%@", type];
    NSDictionary *meta = @{ @"_tags" : metaType };  // 登録するファイルのメタ情報を指定します
    // バイナリオブジェクト登録APIの実行
    APISFileAPIClient *api = [[APISSession sharedSession] createFileAPIClientWithCollectionId:collectionId];
    [api createBinaryObjectWithId:objectId
                         filename:fileName
                           binary:imageData
                             meta:meta
                          success:^(APISResponseObject *response){
                              NSLog(@"バイナリオブジェクトの登録成功 [ステータス:%ld, レスポンス:%@, ロケーション:%@]",
                                    (long)response.statusCode, response.data, response.location);
                              ILLustrationImage *iLLustrationImage = [[ILLustrationImage alloc] initWithDict:response.data];
                              completeBlock(iLLustrationImage);
                          }
                          failure:^(NSError *error){
                              NSLog(@"バイナリオブジェクトの登録失敗 [原因:%@]", [error localizedDescription]);
                              failBlock(error);
                          }];
}

- (void)updateImageDataWithID:(NSString *)imageID imageData:(NSData *)imageData fileName:(NSString *)fileName typeImage:(NSString *)type failBlock:(void(^)(NSError *))failBlock
{
    // 会員・ログインAPIの実行
    [self initialize];
    
    NSString *collectionId = @"IllustrationImages"; // バイナリオブジェクトを登録するコレクションのIDを指定します
    NSString *metaType = [NSString stringWithFormat:@"image/%@", type];
    NSDictionary *meta = @{ @"_tags" : metaType }; // 登録するファイルのメタ情報を指定します
    // バイナリオブジェクト登録APIの実行
    APISFileAPIClient *api = [[APISSession sharedSession] createFileAPIClientWithCollectionId:collectionId];
    [api updateBinaryObjectWithId:imageID
                         filename:fileName
                           binary:imageData
                             meta:meta
                          success:^(APISResponseObject *response){
                              NSLog(@"バイナリオブジェクトの更新成功 [ステータス:%ld, レスポンス:%@, ロケーション:%@]",
                                    (long)response.statusCode, response.data, response.location);
                              failBlock(nil);
                          }
                          failure:^(NSError *error){
                              NSLog(@"バイナリオブジェクトの更新失敗 [原因:%@]", [error localizedDescription]);
                              failBlock(error);
                          }];
}

- (void)deleteImageWithImageID:(NSString *)imageID failBlock:(void (^)(NSError *))failedBlock
{
    [self initialize];
    NSString *collectionId = @"IllustrationImages"; // 削除対象のバイナリオブジェクトが格納されているコレクションのIDを指定します
    // JSONオブジェクト削除APIの実行
    APISFileAPIClient *api = [[APISSession sharedSession] createFileAPIClientWithCollectionId:collectionId];
    [api deleteBinaryObjectWithId:imageID
                          success:^(APISResponseObject *response){
                              NSLog(@"バイナリオブジェクトの削除成功 [ステータス:%ld, レスポンス:%@]",
                                    (long)response.statusCode, response.data);
                              failedBlock(nil);
                          }
                          failure:^(NSError *error){
                              NSLog(@"バイナリオブジェクトの削除失敗 [原因:%@]", [error localizedDescription]);
                              failedBlock(error);
                          }];
}

@end
