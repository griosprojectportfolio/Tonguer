//
//  AppApi.h
//  Rondogo
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "AFNetworkActivityIndicatorManager.h"
#import <UIProgressView+AFNetworking.h>
#import "Netconection.h"

@interface AppApi : AFHTTPRequestOperationManager



+ (AppApi *)sharedClient ;
+ (AppApi *)sharedAuthorizedClient;
- (id)initWithBaseURL:(NSURL *)url;


- (AFHTTPRequestOperation *)loginUser:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)signUpUser:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)updateUser:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)forgotPassword:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)signOutUser:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)userDefaultCls:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)userLearnCls:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)userLearnedCls:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)freeClass:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)userClassVideo:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)freeClsList:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)freeClsVideoList:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)payClass:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)payClsList:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)hostpayClass:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)addvertiesment:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)discusAllTopic:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)discusTopicComments:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)discusTopicPostComments:(NSDictionary *)aParams
                                        success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                        failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)createClassTopic:(NSDictionary *)aParams
                                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)clsQuestion:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)clsQueaAnswer:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)clsAdminComment:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (void)downloadMediaData:(NSDictionary *)aParams
                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)userAnswer:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)getUserNotes:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)createUserNotes:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)notesLike:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callFilterNotesApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callSearchNotesApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callSearchClassApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callNotesDeleteApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)callNotesUpdateApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)aboutUS:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)clsOutline:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)videoComplete:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)feedback:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)paypalApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)userClassOrders:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)startLearning:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)addNotes:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;

- (AFHTTPRequestOperation *)walletApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;


- (AFHTTPRequestOperation *)getUserScore:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock;



-(NSURL *)getDocumentDirectoryFileURL:(NSDictionary *)aParams;

-(void)saveDownloadedData:(NSDictionary *)aParams;





@end
