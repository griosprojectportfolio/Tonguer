//
//  AppApi.m
//  Rondogo
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//
#import "AppApi.h"

#import "FreeClsCat.h"
#import "FreeSubCat.h"
#import "FreeCls.h"
#import "FreeClssVideo.h"
#import "PayClsCat.h"
#import "PaySubCat.h"
#import "PayCls.h"
#import "User.h"
#import "UserDefaultClsList.h"
#import "UserLearnClsList.h"
#import "UserLearnedClsList.h"
#import "UserClsVideo.h"
#import "HostPayCls.h"
#import "Addvertiesment.h"
#import "DisAdminTopic.h"
#import "DisUserToic.h"
#import "DisTopicComments.h"
#import "Questions.h"
#import "QuestionComment.h"
#import "Answer.h"
#import "UserNotes.h"
#import "Notes.h"
#import "Aboutus.h"
#import "ClsOutLineModule.h"
#import "ClsModElement.h"
#import "UserClassOrder.h"
#import "DownloadedData.h"
#import "VideoDone.h"

/* API Constants */
static NSString * const kAppAPIBaseURLString = @"https://tonguer.herokuapp.com/api/v1";
//static NSString * const kAppMediaBaseURLString = @"http://192.168.10.30:1234";

@interface AppApi ()

@end

@implementation AppApi

/* API Clients */

+ (AppApi *)sharedClient {
    
    static AppApi * _sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[AppApi alloc] initWithBaseURL:[NSURL URLWithString:kAppAPIBaseURLString]];
    });
    
    return [AppApi manager];
}

+ (AppApi *)sharedAuthorizedClient{
    return nil;
}

/* API Initialization */

-(id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    return self;
}

/* API Deallocation */

-(void)dealloc {
    
}

#pragma mark- Login User

- (AFHTTPRequestOperation *)loginUser:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
    return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/sessions/login" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      
      NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
      [arrResponse addObject:[responseObject valueForKey:@"user"]];
      [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [User entityFromArray:arrResponse inContext:localContext];
      }completion:^(BOOL success, NSError *error) {
        successBlock(task, responseObject);
      }];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            failureBlock(task, error);
        }
    }];
}



#pragma mark- SignUp User

- (AFHTTPRequestOperation *)signUpUser:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  

    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:aParams];
    [dictParams removeObjectForKey:@"auth_token"];

    return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/registration" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      NSDictionary *dict = [responseObject valueForKey:@"user"];
      [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [User entityWithDictionaty:dict inContext:localContext];
        
      } completion:^(BOOL success, NSError *error) {
          successBlock(task, responseObject);
      }];
      
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            failureBlock(task.responseObject,error);
      }
    }];
}

#pragma mark Update User

- (AFHTTPRequestOperation *)updateUser:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
    return [self baseRequestWithHTTPMethod:@"PATCH" URLString:@"/update" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      
      NSDictionary *dict = [responseObject valueForKey:@"user"];
          
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
         [User entityFromDictionary:dict inContext:localContext];
      }completion:^(BOOL success, NSError *error) {
        successBlock(task, responseObject);

      }];
      
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
            failureBlock(task, error);
        }
    }];
}



#pragma mark- Forgot password

- (AFHTTPRequestOperation *)forgotPassword:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/forget_password" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    successBlock(task, responseObject);
    
  } failure:failureBlock];}

#pragma mark - SignOut user

- (AFHTTPRequestOperation *)signOutUser:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    return [self baseRequestWithHTTPMethod:@"DELETE" URLString:@"/sessions/logout" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      successBlock(task, responseObject);
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        failureBlock(task, error);
    }];
}



#pragma mark - userclass and basic info


- (AFHTTPRequestOperation *)userDefaultCls:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/default_classes_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {

    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserDefaultClsList entityFromArray:arrClass inContext:localContext];

    } completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:failureBlock];
}


#pragma mark - baseRequestWithHTTPMethod

- (AFHTTPRequestOperation *)baseRequestWithHTTPMethod:(NSString *)method
                                            URLString:(NSString *)URLString
                                           parameters:(id)parameters
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failureBlock{
  
  if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == NotReachable) {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Please check your netconection."
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                          otherButtonTitles:nil];
    [alert show];
    return NO;
  }else{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    void (^baseSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *task, id responseObject) {
      NSLog(@"%@",responseObject);
      successBlock(task,responseObject);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    };
    void (^baseFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *task, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      NSLog(@"%@",error);
      failureBlock(task,error);
    };
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",kAppAPIBaseURLString,URLString];
    if([method isEqualToString:@"GET"]){
      return [self GET:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else if ([method isEqualToString:@"POST"]){
      return [self POST:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else if ([method isEqualToString:@"PATCH"]){
      return [self PATCH:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else if ([method isEqualToString:@"DELETE"]){
      return [self DELETE:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else{
      return nil;
    }
  }
}

#pragma mark - user Learn Class

- (AFHTTPRequestOperation *)userLearnCls:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/learn_classes_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserLearnClsList entityFromArray:arrClass inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
  } failure:failureBlock];
}


#pragma mark - user Learned Class


- (AFHTTPRequestOperation *)userLearnedCls:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
 
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/learned_classes_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserLearnedClsList entityFromArray:arrClass inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:failureBlock];
}



#pragma mark - Call Free Class Api

- (AFHTTPRequestOperation *)freeClass:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  NSString * strToken = [aParams valueForKey:@"auth_token"];
  [self.requestSerializer setValue:strToken forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/free_class" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrCategory = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [FreeClsCat entityFromArray:arrCategory inContext:localContext];
      for (int i=0; i < arrCategory.count; i++) {
        NSMutableArray *arrSubCategory = [[arrCategory objectAtIndex:i] valueForKey:@"sub_categories"];
         NSDictionary *dict = [arrCategory objectAtIndex:i];
        [FreeSubCat entityFromArray:arrSubCategory inContext:localContext catID:[dict objectForKey:@"id"]];
      }
      
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
    
  } failure:failureBlock];
}

#pragma mark - Call user Free Classes list

- (AFHTTPRequestOperation *)freeClsList:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/free_class/class_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
   
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSNumber *subCategoryId = [aParams objectForKey:@"sub_category_id"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [FreeCls entityFromArray:arrClsList withSubcategoryId:subCategoryId inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_subcategory_Id CONTAINS %i", subCategoryId.integerValue];
      NSArray *arrFetchCat  = [FreeCls MR_findAllWithPredicate:predicate];
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, arrFetchCat);
    }];
  } failure:failureBlock];
}

#pragma mark - Call user Free Classes Videos list

- (AFHTTPRequestOperation *)freeClsVideoList:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/free_class/class_list/videos" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"video"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      
      [FreeClssVideo entityFromArray:arrClsList inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_id CONTAINS %i",[[aParams objectForKey:@"class_id"]integerValue]];
      NSArray *arryVideo = [FreeClssVideo MR_findAllWithPredicate:predicate];
      NSLog(@"%lu",(unsigned long)arryVideo.count);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, arryVideo);
    }];
  } failure:failureBlock];
}


#pragma mark - Call Pay Class Api

- (AFHTTPRequestOperation *)payClass:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  NSString * strToken = [aParams valueForKey:@"auth_token"];
  
  [self.requestSerializer setValue:strToken forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/pay_class" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
   
    NSMutableArray *arrCategory = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [PayClsCat entityFromArray:arrCategory inContext:localContext];
      for (int i=0; i < arrCategory.count; i++) {
        NSMutableArray *arrSubCategory = [[arrCategory objectAtIndex:i] valueForKey:@"sub_categories"];
        NSDictionary *dict = [arrCategory objectAtIndex:i];
        [PaySubCat entityFromArray:arrSubCategory inContext:localContext catID:[dict objectForKey:@"id"]];
      }
      
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark - Call user Pay Classes list

- (AFHTTPRequestOperation *)payClsList:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
 
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/pay_class/class_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
   
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSLog(@"%lu",(unsigned long)arrClsList.count);
    NSNumber *subCategoryId = [aParams objectForKey:@"sub_category_id"];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [PayCls entityFromArray:arrClsList withSubcategoryId:subCategoryId inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_subcategory_Id CONTAINS %i", subCategoryId.integerValue];
      NSArray *arrFetchCat  = [PayCls MR_findAllWithPredicate:predicate];
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, arrFetchCat);
    }];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Call user Host Pay Classes list

- (AFHTTPRequestOperation *)hostpayClass:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/host/class_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [HostPayCls entityFromArray:arrClsList inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, responseObject);
    }];
  } failure:failureBlock];
}


#pragma mark - Call user Class Vedio Api

- (AFHTTPRequestOperation *)userClassVideo:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/pay_class/class_list/videos" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrVideoList = [[responseObject objectForKey:@"data"] objectForKey:@"video"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserClsVideo entityFromArray:arrVideoList inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_id CONTAINS %i",[[aParams objectForKey:@"class_id"]integerValue]];
      NSArray *arryAdmin = [UserClsVideo MR_findAllWithPredicate:predicate];
      successBlock(task, arryAdmin);
    }];
    

  } failure:failureBlock];
}


#pragma mark - Call Addvertiesment Api

- (AFHTTPRequestOperation *)addvertiesment:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
   return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/advertiesment" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dict = [[NSDictionary alloc ]init];
    dict = [responseObject valueForKey:@"advertiesment"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Addvertiesment entityWithDictionaty:dict  inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSArray *arryAdd = [Addvertiesment MR_findAll];
      successBlock(task, arryAdd);
    }];
    
   } failure:failureBlock];
}


#pragma mark - Call Get All Topic a Class Discus Api

- (AFHTTPRequestOperation *)discusAllTopic:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/user_a_class_topics" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary * dict1 = [responseObject valueForKey:@"data"];
    NSArray * arrAdmin = [[dict1 valueForKey:@"disscuss" ]valueForKey:@"admin"];
    NSArray * arrUser = [[dict1 valueForKey:@"disscuss" ]valueForKey:@"user"];
    NSMutableArray *adminData = [[NSMutableArray alloc]init];
    NSMutableArray *userData = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in arrAdmin) {
      [adminData addObject:dict];
    }
    
    for (NSDictionary *dict in arrUser) {
      [userData addObject:dict];
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisAdminTopic entityFromArray:adminData inContext:localContext];
       [DisUserToic entityFromArray:userData inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSArray *arryAdmin = [DisAdminTopic MR_findAll];
      NSArray *arryUser = [DisUserToic MR_findAll];

      NSDictionary *dictDiscuss = @{@"Admin":arryAdmin,
                             @"User":arryUser};
      successBlock(task, dictDiscuss);
    }];
    
  } failure:failureBlock];
}

#pragma mark - Call Get All Topic a Class Discus Topic Comments Api

- (AFHTTPRequestOperation *)discusTopicComments:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/cls/discuss/topic/get_comments" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
   
    NSDictionary * dict1 = [responseObject valueForKey:@"data"];
    NSArray * arrComments = [[dict1 valueForKey:@"disscuss" ]valueForKey:@"comments"];
   
    NSMutableArray *adminData = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in arrComments) {
      [adminData addObject:dict];
    }
    
    NSNumber *topicId = [aParams valueForKey:@"topic_id"];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisTopicComments entityFromArray:adminData withTopicId:topicId inContext:localContext];
    } completion:^(BOOL success, NSError *error) {

      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"topic_Id CONTAINS %i", topicId.integerValue];
      NSArray *arrComment  = [DisTopicComments MR_findAllWithPredicate:predicate];
      successBlock(task, arrComment);
    }];
    
  } failure:failureBlock];
}



#pragma mark - Call Get All Topic a Class Discus Topic Comments Api

- (AFHTTPRequestOperation *)discusTopicPostComments:(NSDictionary *)aParams
                                        success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                        failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/cls/discuss/topic/comment_post" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary * dict1 = [responseObject valueForKey:@"comment"];
    NSNumber *topicId = [aParams valueForKey:@"topic_id"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisTopicComments entityWithDictionaty:dict1 withTopicId:topicId inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
       successBlock(task, responseObject);
    }];
    
  } failure:failureBlock];
}

#pragma mark - Create a Class Topic Api

- (AFHTTPRequestOperation *)createClassTopic:(NSDictionary *)aParams
                                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];

  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/cls/discuss/add_topic" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary * dict1 = [responseObject valueForKey:@"topic"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisUserToic entityWithDictionaty:dict1 inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:failureBlock];
}


#pragma mark - Class Question Api

- (AFHTTPRequestOperation *)clsQuestion:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/questions" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"question"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Questions entityFromArray:arrQues inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSArray *arry = [Questions MR_findAll];
      successBlock(task, arry);
    }];
  } failure:failureBlock];
}


#pragma mark - Question Answer Api call

- (AFHTTPRequestOperation *)clsQueaAnswer:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/answer" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    //NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"question"];
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//      [Questions entityFromArray:arrQues inContext:localContext];
//    }];
    
    successBlock(task, responseObject);
    
  } failure:failureBlock];
}

#pragma mark - User Answer Admin Comment Api call

- (AFHTTPRequestOperation *)clsAdminComment:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/admin_comments" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"admin_comment"];
    NSNumber *answer_Id = [aParams valueForKey:@"answer_id"];
    
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
          [QuestionComment entityFromArray:arrQues  withAnswerId:answer_Id inContext:localContext];
        }completion:^(BOOL success, NSError *error) {
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"answer_Id CONTAINS %i", answer_Id.integerValue];
          NSArray *arry = [QuestionComment MR_findAllWithPredicate:predicate];
          successBlock(task, arry);
        }];
  } failure:failureBlock];
}



#pragma mark - User Answer Api Call Crossponding Question

- (AFHTTPRequestOperation *)userAnswer:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/get_user_answer" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSArray *arrAns = [responseObject valueForKey:@"answers"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Answer entityFromArray:arrAns inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ques_id CONTAINS %i",[[aParams valueForKey:@"question_id"]integerValue]];
      NSArray *arry = [Answer MR_findAllWithPredicate:predicate];
      successBlock(task, arry);
    }];
  } failure:failureBlock];
}


#pragma mark - Get User Notes Api Call

- (AFHTTPRequestOperation *)getUserNotes:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/get_all_notes" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSArray *arrUserNotes = [responseObject valueForKey:@"user_notes"];
    NSArray *arrOtherUserNotes = [responseObject valueForKey:@"other_user_notes"];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityFromArray:arrUserNotes inContext:localContext];
      [Notes entityFromArray:arrOtherUserNotes inContext:localContext];
    } completion:^(BOOL success, NSError *error) {

      NSArray *arrNotes = [Notes MR_findAll];
      NSArray *arrUserNotes = [UserNotes MR_findAll];

      NSDictionary *dictResponse = @{@"Notes":arrNotes,
                             @"UserNotes":arrUserNotes};
      successBlock(task, dictResponse);
    }];
  } failure:failureBlock];
}



#pragma mark - User Create Note Api call

- (AFHTTPRequestOperation *)createUserNotes:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/user_create_note" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dictUser = [responseObject valueForKey:@"note"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityWithDictionaty:dictUser inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Like Note Api call

- (AFHTTPRequestOperation *)notesLike:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/user_like_note" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    successBlock(task, responseObject);
    
  } failure:failureBlock];
}





#pragma mark Method to Downloading Media Data from server


- (void)downloadMediaData:(NSDictionary *)aParams
                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
    NSString *url = [NSString stringWithFormat:@"%@",[aParams objectForKey:@"url"]];
//   NSString *url = @"http://download.wavetlan.com/SVV/Media/HTTP/MP4/ConvertedFiles/MediaCoder/MediaCoder_test1_1m9s_AVC_VBR_256kbps_640x480_24fps_MPEG2Layer3_CBR_160kbps_Stereo_22050Hz.mp4";
  NSString *strFileNameWithExt = [[NSString alloc] initWithFormat:@"%@",[aParams objectForKey:@"fileName"]];
  NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:strFileNameWithExt];
 
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
  operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
  
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Successfully downloaded file to %@", path);
    
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    BOOL state = [defaults boolForKey:@"state"];
    
    if(state == true){
      UILocalNotification* localNotification = [[UILocalNotification alloc] init];
      localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:30];
      localNotification.alertBody = @"Video Downloaded Successfully";
      localNotification.timeZone = [NSTimeZone defaultTimeZone];
      [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    successBlock(operation, responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"Error: %@", error);
 
  }];
  
  [operation start];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
      double progress = (double)totalBytesRead / totalBytesExpectedToRead;
      NSLog(@"Progress: %.2f", progress);
      
    }];
 }


#pragma mark - Search Class Api call

- (AFHTTPRequestOperation *)callSearchClassApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/cls_search" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSArray *arryNotes = [[responseObject valueForKey:@"data"]valueForKey:@"classes"];
    if(arryNotes.count == 0){
      successBlock(task,arryNotes);
    }else{
      successBlock(task,arryNotes);
    }
    
  } failure:failureBlock];
}




#pragma mark - Search notes Api call

- (AFHTTPRequestOperation *)callSearchNotesApi:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/notes_search" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSArray *arryNotes = [[responseObject valueForKey:@"data"]valueForKey:@"notes"];
     successBlock(task,arryNotes);
  } failure:failureBlock];
}

#pragma mark - Filter notes Api call

- (AFHTTPRequestOperation *)callFilterNotesApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/notes_filter" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSArray *arryNotes = [[responseObject valueForKey:@"data"]valueForKey:@"notes"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(arryNotes.count == 0){
      successBlock(task,arryNotes);
    }else{
      successBlock(task,arryNotes);
    }

  } failure:failureBlock];
}

#pragma mark - Edit Notes api

- (AFHTTPRequestOperation *)callNotesUpdateApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"PATCH" URLString:@"/user_update_note" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dict = [responseObject valueForKey:@"note"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityFromDictionary:dict inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
       successBlock(task, responseObject);
    }];
  } failure:failureBlock];
}
#pragma mark - Delete Notes api
- (AFHTTPRequestOperation *)callNotesDeleteApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"DELETE" URLString:@"/notes_delete" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
  // Magical recodes delete functionality
    
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"notes_id CONTAINS %i",[[aParams valueForKey:@"note_id"] integerValue]];
    NSArray *arryModEle = [UserNotes MR_findAllWithPredicate:predicate];
    
    UserNotes *deleteEntity = [arryModEle objectAtIndex:0];
    [deleteEntity MR_deleteEntity];
    successBlock(task, responseObject);
    
  } failure:failureBlock];
}


#pragma mark - Add Note Api call
- (AFHTTPRequestOperation *)addNotes:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];

  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/user_added_note" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSDictionary *dict = [[responseObject valueForKey:@"data"]valueForKey:@"note"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityFromDictionary:dict inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
  } failure:failureBlock];
}



#pragma mark - About Us Api call

- (AFHTTPRequestOperation *)aboutUS:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/about_us" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dictAbout = [[responseObject valueForKey:@"data"]valueForKey:@"about_us"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      NSNumber *ab_id = [[NSNumber alloc]initWithDouble:1];
      [Aboutus entityWithDictionaty:dictAbout inContext:localContext about_id:ab_id];
    } completion:^(BOOL success, NSError *error) {
      NSArray *arryData = [Aboutus MR_findAll];
      successBlock(task, arryData);
    }];
  } failure:failureBlock];
}

#pragma mark - User Score Api call

- (AFHTTPRequestOperation *)getUserScore:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/get_score" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
     successBlock(task, responseObject);
  } failure:failureBlock];
}



#pragma mark - Class Outline Us Api call

- (AFHTTPRequestOperation *)clsOutline:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/cls_outline" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arryModule = [responseObject valueForKey:@"data"];
    NSMutableArray *arrOutLine = [[NSMutableArray alloc]init];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [ClsOutLineModule entityFromArray:arryModule inContext:localContext classID:[aParams valueForKey:@"cls_id"]];
        for (NSDictionary *dict in arryModule) {
        NSMutableArray *arryElement = [dict valueForKey:@"elements"];
        [ClsModElement entityFromArray:arryElement inContext:localContext modId:[dict valueForKey:@"id"]];
      }
      
    } completion:^(BOOL success, NSError *error) {
      
      NSArray *arryData = [ClsOutLineModule MR_findAll];
      for (int i = 0; i<arryData.count; i++) {
        NSMutableDictionary *dictElement = [[NSMutableDictionary alloc]init];
        ClsOutLineModule *obj = [arryData objectAtIndex:i];
        [dictElement setObject:obj forKey:@"module"];
        NSLog(@"%@",obj.mod_id);
       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"mod_id CONTAINS %i",obj.mod_id.integerValue];
        NSArray *arryModEle = [ClsModElement MR_findAllWithPredicate:predicate];
        NSMutableArray *arry = [[NSMutableArray alloc]init];
        for (int j = 0; j<arryModEle.count;j++) {
          [arry addObject:[arryModEle objectAtIndex:j]];
          [dictElement setObject:arry forKey:@"array"];
        }
        [arrOutLine addObject:dictElement];
      }
      successBlock(task, arrOutLine);
    }];
    
  } failure:failureBlock];
}


#pragma mark - Video Complete Api call Api call

- (AFHTTPRequestOperation *)videoComplete:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/finished_video" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dict = [[responseObject valueForKey:@"data"]valueForKey:@"video"];
    NSMutableDictionary *dictDone = [[NSMutableDictionary alloc]init];
    [dictDone setObject:[dict valueForKey:@"id"] forKey:@"id"];
    [dictDone setObject:[dict valueForKey:@"a_class_id"] forKey:@"cls_id"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [VideoDone entityWithDictionaty:dictDone inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"video_cls_id CONTAINS %i",[[dict valueForKey:@"a_class_id"]integerValue]];
      NSArray *arry = [VideoDone MR_findAllWithPredicate:predicate];
      successBlock(task, arry);
    }];
  } failure:failureBlock];
}


#pragma mark -  Feedback  Api call

- (AFHTTPRequestOperation *)feedback:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/feedback" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    successBlock(task, responseObject);
    
  } failure:failureBlock];
}

#pragma mark -  PaypalApi call

- (AFHTTPRequestOperation *)paypalApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/buy_class" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    successBlock(task, responseObject);
  } failure:failureBlock];
}

#pragma mark -  Get User Class Orders  Api call

- (AFHTTPRequestOperation *)userClassOrders:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/buyclassorder" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSArray *srryOrders = [responseObject valueForKey:@"data"];
   
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    
          [UserClassOrder entityFromArray:srryOrders inContext:localContext];
    
        } completion:^(BOOL success, NSError *error) {
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_buy CONTAINS %i",0];
          NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"is_buy CONTAINS %i",1];
          NSArray *arryTrue = [UserClassOrder MR_findAllWithPredicate:predicate1];
          NSArray *arryFail = [UserClassOrder MR_findAllWithPredicate:predicate];
          NSDictionary *dict = [[NSDictionary alloc]initWithObjects:@[arryTrue,arryFail] forKeys:@[@"True",@"False"]];
          successBlock(task, dict);
    
        }];
  } failure:failureBlock];
}


#pragma mark -  Start Learning Api call

- (AFHTTPRequestOperation *)startLearning:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/start_learn" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    successBlock(task, responseObject);
  } failure:failureBlock];
}

#pragma mark - Wallet Api call
- (AFHTTPRequestOperation *)walletApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/use_wallet" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject)  {
    NSLog(@"%@",responseObject);
      successBlock(task, responseObject);
    
  } failure:failureBlock];
}


- (NSURL *)getDocumentDirectoryFileURL:(NSDictionary *)aParams {
  NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *filePath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
  return [NSURL fileURLWithPath:filePath];
}

-(void)saveDownloadedData:(NSDictionary *)aParams{
  [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    [DownloadedData entityWithDictionaty:aParams inContext:localContext];
  }];

}

@end
