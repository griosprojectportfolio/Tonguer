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
#import "AdminContact.h"
#import <AVFoundation/AVFoundation.h>

/* API Constants */
//static NSString * const kAppAPIBaseURLString = @"https://tonguer.herokuapp.com/api/v1";
//static NSString * const kAppMediaBaseURLString = @"http://192.168.10.30:1234";
 static NSString * const kAppAPIBaseURLString = @"http://52.25.127.168/api/v1";

UIProgressView *progressVW;
NSInteger vdoProgress;
BOOL vdoDownlodFalg = false;

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
  [self initializeOperationQueueForDownload];
    self = [super initWithBaseURL:url];
  
    if (!self) {
        return nil;
    }
    return self;
}

/* API Deallocation */

-(void)dealloc {
    
}


-(void)initializeOperationQueueForDownload{
  self.downloadQueue = [[NSOperationQueue alloc] init];
  self.downloadQueue.maxConcurrentOperationCount = 3;
  self.downloadQueue.name = @"com.Tounger.app.downloadQueue";
}

#pragma mark- Login User

- (AFHTTPRequestOperation *)loginUser:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
    return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/sessions/login" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      dispatch_async(dispatch_get_main_queue(), ^{
        successBlock(task, responseObject);
      });
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
    [dictParams removeObjectForKey:@"auth-token"];

    return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/registration" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      dispatch_async(dispatch_get_main_queue(), ^{
        successBlock(task, responseObject);
      });
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
      if(failureBlock){
        failureBlock(task, error);
      }
    }];
}

#pragma mark Update User

//- (AFHTTPRequestOperation *)updateUser:(NSDictionary *)aParams
//                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
//                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
//    
//    [self.requestSerializer setValue:[aParams objectForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
//    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:aParams];
//   [dictParams removeObjectForKey:@"auth-token"];
//  
////         [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
////         [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Accept"];
//  
//    return [self baseRequestWithHTTPMethod:@"PATCH" URLString:@"update" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
//      
//      dispatch_async(dispatch_get_main_queue(), ^{
//        successBlock(task, responseObject);
//      });
//    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
//      if(failureBlock){
//        failureBlock(task, error);
//      }
//    }];
//}

//******
- (AFHTTPRequestOperation *)updateUser:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:aParams];
  [dictParams removeObjectForKey:@"auth-token"];
  NSDictionary *disct = [[NSDictionary alloc]initWithDictionary:dictParams];
  
  NSString *url = [NSString stringWithFormat:@"%@/update",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self PATCH:url parameters:disct success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    dispatch_async(dispatch_get_main_queue(), ^{
      successBlock(task, responseObject);
    });
    
      } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      ;
      failureBlock(task, error);
      NSLog(@"%@",task.responseString);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/default_classes_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSArray *arrNotes = [UserDefaultClsList MR_findAll];
    if(arrNotes.count > 0){
      [UserDefaultClsList MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }

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
    AFHTTPRequestOperation *requestOperation;
    NSString *url = [NSString stringWithFormat:@"%@/%@",kAppAPIBaseURLString,URLString];
    if([method isEqualToString:@"GET"]){
      requestOperation =[self GET:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else if ([method isEqualToString:@"POST"]){
      requestOperation = [self POST:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else if ([method isEqualToString:@"PATCH"]){
      requestOperation = [self PATCH:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else if ([method isEqualToString:@"DELETE"]){
      requestOperation = [self DELETE:url parameters:parameters success:baseSuccessBlock failure:baseFailureBlock];
    }else{
      requestOperation = nil;
    }
    //requestOperation
    
    return requestOperation;
  }
}

#pragma mark - user Learn Class

- (AFHTTPRequestOperation *)userLearnCls:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/learn_classes_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSArray *arrNotes = [UserLearnClsList MR_findAll];
    if(arrNotes.count > 0){
      [UserLearnClsList MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserLearnClsList entityFromArray:arrClass inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      successBlock(task, arrClass);
    }];
  } failure:failureBlock];
}


#pragma mark - user Learned Class


- (AFHTTPRequestOperation *)userLearnedCls:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
 
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/learned_classes_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSArray *arrNotes = [UserLearnedClsList MR_findAll];
    if(arrNotes.count > 0){
      [UserLearnedClsList MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserLearnedClsList entityFromArray:arrClass inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, arrClass);
    }];
    
  } failure:failureBlock];
}



#pragma mark - Call Free Class Api

- (AFHTTPRequestOperation *)freeClass:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  NSString * strToken = [aParams valueForKey:@"auth-token"];
  [self.requestSerializer setValue:strToken forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/free_class" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrCategory = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
    
    NSArray *arrNotes = [FreeClsCat MR_findAll];
    if(arrNotes.count > 0){
      [FreeClsCat MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/free_class/class_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSArray *arrNotes = [FreeCls MR_findAll];
    if(arrNotes.count > 0){
      [FreeCls MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
   
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSNumber *subCategoryId = [aParams objectForKey:@"sub_category_id"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [FreeCls entityFromArray:arrClsList withSubcategoryId:subCategoryId inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_subcategory_Id CONTAINS %i", subCategoryId.integerValue];
      NSArray *arrFetchCat  = [FreeCls MR_findAllSortedBy:@"cls_name" ascending:true withPredicate:predicate];
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, arrFetchCat);
    }];
  } failure:failureBlock];
}

#pragma mark - Call user Free Classes Videos list

- (AFHTTPRequestOperation *)freeClsVideoList:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/free_class/class_list/videos" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"video"];
    
//    NSArray *arrNotes = [FreeClssVideo MR_findAll];
//    if(arrNotes.count > 0){
//      [FreeClssVideo MR_truncateAll];
//      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    }
    
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
  NSString * strToken = [aParams valueForKey:@"auth-token"];
  
  [self.requestSerializer setValue:strToken forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/pay_class" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
   
    NSMutableArray *arrCategory = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
    
    NSArray *arrNotes = [PayClsCat MR_findAll];
    if(arrNotes.count > 0){
      [PayClsCat MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
 
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/pay_class/class_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
   
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSLog(@"%lu",(unsigned long)arrClsList.count);
    NSNumber *subCategoryId = [aParams objectForKey:@"sub_category_id"];
    
    NSArray *arrNotes = [PayCls MR_findAll];
    if(arrNotes.count > 0){
      [PayCls MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [PayCls entityFromArray:arrClsList withSubcategoryId:subCategoryId inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_subcategory_Id CONTAINS %i", subCategoryId.integerValue];
      NSArray *arrFetchCat  = [PayCls MR_findAllSortedBy:@"cls_name" ascending:true withPredicate:predicate];
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/host/class_list" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    
    NSArray *arrNotes = [HostPayCls MR_findAll];
    if(arrNotes.count > 0){
      [HostPayCls MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
    
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/pay_class/class_list/videos" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arrVideoList = [[responseObject objectForKey:@"data"] objectForKey:@"video"];
    NSArray *arrNotes = [UserClsVideo MR_findAll];
    if(arrNotes.count > 0){
      [UserClsVideo MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
      }
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserClsVideo entityFromArray:arrVideoList inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_id CONTAINS %i",[[aParams objectForKey:@"class_id"]integerValue]];
      //NSArray *arryAdmin = [UserClsVideo MR_findAllWithPredicate:predicate];
      NSArray *arryAdmin = [UserClsVideo MR_findAllSortedBy:@"vdo_id" ascending:true withPredicate:predicate];
      successBlock(task, arryAdmin);
    }];
    

  } failure:failureBlock];
}


#pragma mark - Get Admin Contact details

- (AFHTTPRequestOperation *)getAdminContact:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/get_admin_contacts" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrVideoList = [[responseObject objectForKey:@"data"] objectForKey:@"contacts"];
    NSArray *arry = [arrVideoList objectAtIndex:0];
    NSDictionary *dict =[arry objectAtIndex:0];
    NSNumber *adminid = [[NSNumber alloc]initWithUnsignedInteger:1];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [AdminContact entityWithDictionaty:dict inContext:localContext adminid:adminid];
    } completion:^(BOOL success, NSError *error) {
       successBlock(task, responseObject);
    }];
    
  } failure:failureBlock];
}




#pragma mark - Call Addvertiesment Api

- (AFHTTPRequestOperation *)addvertiesment:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
   return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/advertiesment" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dict = [responseObject valueForKey:@"advertiesment"];
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/user_a_class_topics" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary * dict1 = [responseObject valueForKey:@"data"];
    NSNumber *class_id = [[responseObject valueForKey:@"data"] valueForKey:@"class_id"];
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
      [DisAdminTopic entityFromArray:adminData inContext:localContext class_id:class_id];
       [DisUserToic entityFromArray:userData inContext:localContext class_id:class_id];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class_id CONTAINS %i", [[aParams objectForKey:@"class_id"] integerValue]];
      NSArray *arryAdmin  = [DisAdminTopic MR_findAllWithPredicate:predicate];

      NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"class_id CONTAINS %i", [[aParams objectForKey:@"class_id"]integerValue]];
      NSArray *arryUser  = [DisUserToic MR_findAllWithPredicate:predicate1];
     
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];

  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/cls/discuss/add_topic" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary * dict1 = [responseObject valueForKey:@"topic"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisUserToic entityWithDictionaty:dict1 inContext:localContext class_id:[aParams valueForKey:@"class_id"]];
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:failureBlock];
}


#pragma mark - Class Question Api

- (AFHTTPRequestOperation *)clsQuestion:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/questions" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"question"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Questions entityFromArray:arrQues inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
       NSPredicate *predicate = [NSPredicate predicateWithFormat:@"class_id CONTAINS %i",[[aParams valueForKey:@"class_id"]integerValue]];
      NSArray *arry = [Questions MR_findAllSortedBy:@"ques_id" ascending:true withPredicate:predicate];
      successBlock(task, arry);
    }];
  } failure:failureBlock];
}


#pragma mark - Question Answer Api call

- (AFHTTPRequestOperation *)clsQueaAnswer:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/get_user_answer" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSArray *arrAns = [responseObject valueForKey:@"answers"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Answer entityFromArray:arrAns inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSNumber *userid = [aParams objectForKey:@"userId"];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ques_id CONTAINS %i && user_id CONTAINS %i",[[aParams valueForKey:@"question_id"]integerValue], userid.integerValue];
      NSArray *arry = [Answer MR_findAllWithPredicate:predicate];
      successBlock(task, arry);
    }];
  } failure:failureBlock];
}

#pragma mark - User Answer Update  Api Call Crossponding Question

- (AFHTTPRequestOperation *)userAnswerUpdateApi:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/update_answer" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSDictionary *dictAns = [[responseObject valueForKey:@"data"]valueForKey:@"answers"];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Answer entityFromDictionary:dictAns inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSNumber *userid = [aParams objectForKey:@"userId"];
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ques_id CONTAINS %i && user_id CONTAINS %i",[[aParams valueForKey:@"question_id"]integerValue], userid.integerValue];
      NSArray *arry = [Answer MR_findAllWithPredicate:predicate];
      successBlock(task, arry);
    }];
  } failure:failureBlock];
}



#pragma mark - Get User Notes Api Call

- (AFHTTPRequestOperation *)getUserNotes:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/get_all_notes" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSArray *arrUserNotes = [responseObject valueForKey:@"user_notes"];
    NSArray *arrOtherUserNotes = [responseObject valueForKey:@"other_user_notes"];
    
    NSArray *arrNotes = [Notes MR_findAll];
    if(arrNotes.count > 0){
      [Notes MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//      for (Notes *entity in arrNotes) {
//        [entity MR_deleteEntity];
//      }
    }
    

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityFromArray:arrUserNotes inContext:localContext];
      [Notes entityFromArray:arrOtherUserNotes inContext:localContext];
    } completion:^(BOOL success, NSError *error) {

      NSArray *arrNotes = [Notes MR_findAllSortedBy:@"notes_id" ascending:true];
      NSArray *arrUserNotes = [UserNotes MR_findAllSortedBy:@"notes_id" ascending:true];

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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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
//  NSString *strFileNameWithExt = [[NSString alloc] initWithFormat:@"%@",[aParams objectForKey:@"fileName"]];
//  NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:strFileNameWithExt];

  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
   _operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
  _operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
  
  [self.operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//    NSLog(@"Successfully downloaded file to %@", path);
//    NSLog(@"Successfully downloaded file to %@",path.lastPathComponent);
    NSString *strOld = path.lastPathComponent;
    
    NSArray* foo = [strOld componentsSeparatedByString: @"temp"];
    NSString* strFile = [foo objectAtIndex:1];
    NSFileManager *filemaneger = [NSFileManager defaultManager];
    
    if([filemaneger fileExistsAtPath:path]){
      NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
      NSString *pathNew = [[paths objectAtIndex:0] stringByAppendingPathComponent:strFile];
      NSLog(@"Successfully downloaded file to %@", pathNew);
      BOOL fm = [filemaneger moveItemAtPath:path toPath:pathNew error:nil];
      if(fm){
        NSLog(@"********Success");
      }else{
        NSLog(@"********Fail");
      }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSUserDefaults *defaults = [[NSUserDefaults alloc]init];
    BOOL state = [defaults boolForKey:@"state"];
    
    if(state == true){
      UILocalNotification* localNotification = [[UILocalNotification alloc] init];
      localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
      localNotification.alertBody = @"Video Downloaded Successfully";
      localNotification.timeZone = [NSTimeZone defaultTimeZone];
      [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    
    successBlock(operation, responseObject);
  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    failureBlock(operation,error);
     NSLog(@"Error: %@", error);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
 
  }];
  [self.downloadQueue addOperation:self.operation];
  [self.operation start];
    [self.operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
      double progress = (double)totalBytesRead / totalBytesExpectedToRead;
      [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
     // NSLog(@"Progress: %.2f", progress);
      vdoProgress = progress;
       [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_PROGRESS" object:aParams userInfo:[NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%f",progress] forKey:@"progress"]];
    }];
  
 }




#pragma mark - Search Class Api call

- (AFHTTPRequestOperation *)callSearchClassApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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

  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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

  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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

  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
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

  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"DELETE" URLString:@"/notes_delete" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
  // Magical recodes delete functionality
    
   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"notes_id CONTAINS %i",[[aParams valueForKey:@"note_id"] integerValue]];
    NSArray *arryModEle = [UserNotes MR_findAllWithPredicate:predicate];
    
    UserNotes *deleteEntity = [arryModEle objectAtIndex:0];
    [deleteEntity MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    successBlock(task, responseObject);
    
  } failure:failureBlock];
}


#pragma mark - Video Delete api

- (AFHTTPRequestOperation *)videoDelete:(NSDictionary *)aParams 
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  NSString * classActive = [aParams valueForKey:@"active"];
  NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:aParams];
  [dict removeObjectForKey:@"active"];
  [dict removeObjectForKey:@"auth-token"];
  NSDictionary *aDict = [[NSDictionary alloc]initWithDictionary:dict];
  
  return [self baseRequestWithHTTPMethod:@"DELETE" URLString:@"delete_users_videos" parameters:aDict success:^(AFHTTPRequestOperation *task, id responseObject) {
    // Magical recodes delete functionality
    NSLog(@"%@",responseObject);
    NSString *strObj = [aParams valueForKey:@"video_ids"];
    NSArray *arrVieodObj = [strObj componentsSeparatedByString:@","];
    
    for (int i=0;i<arrVieodObj.count; i++) {
      if([classActive  isEqual: @"Paied"]){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"vdo_id CONTAINS %i",[[arrVieodObj objectAtIndex:i]integerValue]];
        NSArray *arryModEle = [UserClsVideo MR_findAllWithPredicate:predicate];
        if(arryModEle.count != 0){
        UserClsVideo *deleteEntity = [arryModEle objectAtIndex:0];
        [deleteEntity MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
        
      }else{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"video_id CONTAINS %i",[[arrVieodObj objectAtIndex:i]integerValue]];
        NSArray *arryModEle = [FreeClssVideo MR_findAllWithPredicate:predicate];
        
        FreeClssVideo *deleteEntity = [arryModEle objectAtIndex:0];
        [deleteEntity MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

      }
    }
   
    successBlock(task, responseObject);
    
  } failure:failureBlock];
}





#pragma mark - Add Note Api call
- (AFHTTPRequestOperation *)addNotes:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];

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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/about_us" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dictAbout = [[responseObject valueForKey:@"data"]valueForKey:@"about_us"];
    if(dictAbout != nil){
      [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSNumber *ab_id = [[NSNumber alloc]initWithDouble:1];
        [Aboutus entityWithDictionaty:dictAbout inContext:localContext about_id:ab_id];
      } completion:^(BOOL success, NSError *error) {
        NSArray *arryData = [Aboutus MR_findAll];
        successBlock(task, arryData);
      }];
    }
    
  } failure:failureBlock];
}

#pragma mark - User Score Api call

- (AFHTTPRequestOperation *)getUserScore:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/get_score" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
     successBlock(task, responseObject);
  } failure:failureBlock];
}



#pragma mark - Class Outline Us Api call

- (AFHTTPRequestOperation *)clsOutline:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/cls_outline" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSMutableArray *arryModule = [responseObject valueForKey:@"data"];
    NSMutableArray *arrOutLine = [[NSMutableArray alloc]init];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [ClsOutLineModule entityFromArray:arryModule inContext:localContext classID:[aParams valueForKey:@"cls_id"]];
        for (NSDictionary *dict in arryModule) {
        NSMutableArray *arryElement = [dict valueForKey:@"elements"];
          if(arryElement.count != 0 ){
        [ClsModElement entityFromArray:arryElement inContext:localContext modId:[dict valueForKey:@"id"]];
          }
      }
      
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_id CONTAINS %i",[[aParams valueForKey:@"cls_id"]integerValue]];
      NSArray *arryData = [ClsOutLineModule MR_findAllWithPredicate:predicate];
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
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/finished_video" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dict = [[responseObject valueForKey:@"data"]valueForKey:@"video"];
    NSMutableDictionary *dictDone = [[NSMutableDictionary alloc]init];
    [dictDone setObject:[dict valueForKey:@"id"] forKey:@"id"];
    [dictDone setObject:[dict valueForKey:@"a_class_id"] forKey:@"cls_id"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    successBlock(task, responseObject);
    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//      [VideoDone entityFromDictionary:aParams inContext:localContext];
//      
//    } completion:^(BOOL success, NSError *error) {
//      
//    }];
    
  } failure:failureBlock];
}


#pragma mark -  Feedback  Api call

- (AFHTTPRequestOperation *)feedback:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/feedback" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    successBlock(task, responseObject);
    
  } failure:failureBlock];
}

#pragma mark -  PaypalApi call

- (AFHTTPRequestOperation *)paypalApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/buy_class" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    successBlock(task, responseObject);
  } failure:failureBlock];
}

#pragma mark -  Get User Class Orders  Api call

- (AFHTTPRequestOperation *)userClassOrders:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  
  return [self baseRequestWithHTTPMethod:@"GET" URLString:@"/buyclassorder" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSArray *srryOrders = [responseObject valueForKey:@"data"];
    NSArray *arry = [UserClassOrder MR_findAll];
    if(arry.count > 0){
      [UserClassOrder MR_truncateAll];
      [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    
          [UserClassOrder entityFromArray:srryOrders inContext:localContext];
    
        } completion:^(BOOL success, NSError *error) {
          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_buy CONTAINS %i",0];
          NSPredicate *predicate1 = [NSPredicate predicateWithFormat:@"is_buy CONTAINS %i",1];
          NSArray *arryTrue = [UserClassOrder MR_findAllSortedBy:@"cls_name" ascending:true withPredicate:predicate1];
          NSArray *arryFail = [UserClassOrder MR_findAllSortedBy:@"cls_name" ascending:true withPredicate:predicate];
          NSDictionary *dict = [[NSDictionary alloc]initWithObjects:@[arryTrue,arryFail] forKeys:@[@"True",@"False"]];
          successBlock(task, dict);
    
        }];
  } failure:failureBlock];
}


#pragma mark -  Start Learning Api call

- (AFHTTPRequestOperation *)startLearning:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
  return [self baseRequestWithHTTPMethod:@"POST" URLString:@"/start_learn" parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    successBlock(task, responseObject);
  } failure:failureBlock];
}

#pragma mark - Wallet Api call
- (AFHTTPRequestOperation *)walletApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth-token"] forHTTPHeaderField:@"auth-token"];
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

-(void)userMoneyUpdate:(NSDictionary *)aParams {
  
  NSArray *arry = [User MR_findAll];
  if(arry.count>0){
    
    User *obj = [arry objectAtIndex:0];
    
    NSNumber *userid = obj.user_id;
    NSNumber *userMoney = [aParams valueForKey:@"user[money]"];
   
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setValue:userid forKey:@"id"];
    [dict setValue:userMoney forKey:@"money"];
    
  [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    [User entityFromDictionary:dict inContext:localContext];
    
  }];
  }
}

-(UIImage *)generateThumbImage:(NSString *)imgUrl
{
  NSURL *Url = [[NSURL alloc]initWithString:imgUrl];
  AVAsset *asset = [AVAsset assetWithURL:Url];
  AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc]initWithAsset:asset];
  CMTime time = CMTimeMake(0,300);
  CGSize maxSize = CGSizeMake(320, 180);
  imageGenerator.maximumSize = maxSize;
  CGImageRef imageRef = [imageGenerator copyCGImageAtTime:time actualTime:NULL error:NULL];
  UIImage *thumbnail = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  
  
  return thumbnail;
}




@end
