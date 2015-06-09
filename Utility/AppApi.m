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
    
    NSString *url = [NSString stringWithFormat:@"%@/sessions/login",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      
      NSLog(@"%@",responseObject);
      NSMutableArray *arrResponse = [[NSMutableArray alloc] init];
      [arrResponse addObject:[responseObject valueForKey:@"user"]];
      [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [User entityFromArray:arrResponse inContext:localContext];
      }completion:^(BOOL success, NSError *error) {
        successBlock(task, responseObject);
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      }];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
          
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}



#pragma mark- SignUp User

- (AFHTTPRequestOperation *)signUpUser:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  

    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:aParams];
    [dictParams removeObjectForKey:@"auth_token"];

    NSString *url = [NSString stringWithFormat:@"%@/registration",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    return [self POST:url parameters:dictParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      
      NSLog(@"%@",responseObject);
      NSDictionary *dict = [responseObject valueForKey:@"user"];
      
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      
      [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        [User entityWithDictionaty:dict inContext:localContext];
        
      } completion:^(BOOL success, NSError *error) {
          successBlock(task, responseObject);
      }];
      
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
          
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark Update User

- (AFHTTPRequestOperation *)updateUser:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  
    NSString *url = [NSString stringWithFormat:@"%@/update",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
    
    return [self PATCH:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      
      NSLog(@"%@",responseObject);
      
      NSDictionary *dict = [responseObject valueForKey:@"user"];
          
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [User entityFromDictionary:dict inContext:localContext];
      }];
      
      NSArray *arrFetchCat  = [User MR_findAll];
      NSLog(@"%@",arrFetchCat);
      successBlock(task, responseObject);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
          
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}



#pragma mark- Forgot password

- (AFHTTPRequestOperation *)forgotPassword:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    
    NSString *url = [NSString stringWithFormat:@"%@/forget_password",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      NSLog(@"%@",responseObject);
      successBlock(task, responseObject);
      
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
          
            failureBlock(task, error);
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        }
    }];
}

#pragma mark - SignOut user

- (AFHTTPRequestOperation *)signOutUser:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    NSString *url = [NSString stringWithFormat:@"%@/sessions/logout",kAppAPIBaseURLString];
  

    return [self DELETE:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
       [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
  NSString *url = [NSString stringWithFormat:@"%@/default_classes_list",kAppAPIBaseURLString];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    successBlock(task, responseObject);
    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSLog(@"%lu",(unsigned long)arrClass.count);
   [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserDefaultClsList entityFromArray:arrClass inContext:localContext];
      
      NSArray *arrFetchCat  = [UserDefaultClsList MR_findAll];
      NSLog(@"%@",arrFetchCat);
    } completion:^(BOOL success, NSError *error) {
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


#pragma mark - user Learn Class


- (AFHTTPRequestOperation *)userLearnCls:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/learn_classes_list",kAppAPIBaseURLString];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSLog(@"%lu",(unsigned long)arrClass.count);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserLearnClsList entityFromArray:arrClass inContext:localContext];
      
      NSArray *arrFetchCat  = [UserLearnClsList MR_findAll];
      NSLog(@"%@",arrFetchCat);
    } completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      NSLog(@"%@",error);
      failureBlock(task, error);
    }
  }];
}

#pragma mark - user Learned Class


- (AFHTTPRequestOperation *)userLearnedCls:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/learned_classes_list",kAppAPIBaseURLString];
  
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    successBlock(task, responseObject);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSMutableArray *arrClass = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSLog(@"%lu",(unsigned long)arrClass.count);
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserLearnedClsList entityFromArray:arrClass inContext:localContext];
      
      NSArray *arrFetchCat  = [UserLearnedClsList MR_findAll];
      NSLog(@"%@",arrFetchCat);
    }completion:^(BOOL success, NSError *error) {
      successBlock(task, responseObject);
    }];
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      NSLog(@"%@",error);
      failureBlock(task, error);
    }
  }];
}



#pragma mark - Call Free Class Api

- (AFHTTPRequestOperation *)freeClass:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  NSString * strToken = [aParams valueForKey:@"auth_token"];
  
  [self.requestSerializer setValue:strToken forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/free_class",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrCategory = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
    NSLog(@"%lu",(unsigned long)arrCategory.count);
    
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
    
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      
      NSLog(@"%@",error);
      
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      failureBlock(task,error);
    }
  }];
  
}

#pragma mark - Call user Free Classes list

- (AFHTTPRequestOperation *)freeClsList:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/free_class/class_list",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSLog(@"%lu",(unsigned long)arrClsList.count);
    NSNumber *subCategoryId = [aParams objectForKey:@"sub_category_id"];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [FreeCls entityFromArray:arrClsList withSubcategoryId:subCategoryId inContext:localContext];
    } completion:^(BOOL success, NSError *error) {

      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_subcategory_Id CONTAINS %i", subCategoryId.integerValue];
      NSArray *arrFetchCat  = [FreeCls MR_findAllWithPredicate:predicate];
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, arrFetchCat);
    }];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      failureBlock(task,error);
    }
  }];
}

#pragma mark - Call user Free Classes Videos list

- (AFHTTPRequestOperation *)freeClsVideoList:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/free_class/class_list/videos",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"video"];
    NSLog(@"%lu",(unsigned long)arrClsList.count);
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      
      [FreeClssVideo entityFromArray:arrClsList inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_id CONTAINS %i",[[aParams objectForKey:@"class_id"]integerValue]];
      NSArray *arryVideo = [FreeClssVideo MR_findAllWithPredicate:predicate];
      NSLog(@"%lu",(unsigned long)arryVideo.count);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, arryVideo);
    }];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Call Pay Class Api

- (AFHTTPRequestOperation *)payClass:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  NSString * strToken = [aParams valueForKey:@"auth_token"];
  
  [self.requestSerializer setValue:strToken forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/pay_class",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrCategory = [[responseObject objectForKey:@"data"] objectForKey:@"category"];
    NSLog(@"%lu",(unsigned long)arrCategory.count);
    
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
  NSString *url = [NSString stringWithFormat:@"%@/pay_class/class_list",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
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
  NSString *url = [NSString stringWithFormat:@"%@/host/class_list",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrClsList = [[responseObject objectForKey:@"data"] objectForKey:@"classes"];
    NSLog(@"%lu",(unsigned long)arrClsList.count);
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      
      [HostPayCls entityFromArray:arrClsList inContext:localContext];
      
      NSArray *arrFetchCat  = [HostPayCls MR_findAll];
      NSLog(@"%@",arrFetchCat);
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}




#pragma mark - Call user Class Vedio Api

- (AFHTTPRequestOperation *)userClassVideo:(NSDictionary *)aParams
                              success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                              failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/pay_class/class_list/videos",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSMutableArray *arrVideoList = [[responseObject objectForKey:@"data"] objectForKey:@"video"];
    NSLog(@"%lu",(unsigned long)arrVideoList.count);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserClsVideo entityFromArray:arrVideoList inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cls_id CONTAINS %i",[[aParams objectForKey:@"class_id"]integerValue]];
      NSArray *arryAdmin = [UserClsVideo MR_findAllWithPredicate:predicate];
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
      successBlock(task, arryAdmin);
    }];
    

  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Call Addvertiesment Api

- (AFHTTPRequestOperation *)addvertiesment:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/advertiesment",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    NSDictionary *dict = [[NSDictionary alloc ]init];
    dict = [responseObject valueForKey:@"advertiesment"];
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Addvertiesment entityWithDictionaty:dict  inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSArray *arryAdd = [Addvertiesment MR_findAll];
      successBlock(task, arryAdd);
    }];
    
    
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Call Get All Topic a Class Discus Api

- (AFHTTPRequestOperation *)discusAllTopic:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/user_a_class_topics",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
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


    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
    

  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark - Call Get All Topic a Class Discus Topic Comments Api

- (AFHTTPRequestOperation *)discusTopicComments:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/cls/discuss/topic/get_comments",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
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
    

    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}



#pragma mark - Call Get All Topic a Class Discus Topic Comments Api

- (AFHTTPRequestOperation *)discusTopicPostComments:(NSDictionary *)aParams
                                        success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                        failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/cls/discuss/topic/comment_post",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
   
   
    NSDictionary * dict1 = [responseObject valueForKey:@"comment"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSNumber *topicId = [aParams valueForKey:@"topic_id"];

    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisTopicComments entityWithDictionaty:dict1 withTopicId:topicId inContext:localContext];
    }];
    
    
  /////////
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark - Create a Class Topic Api

- (AFHTTPRequestOperation *)createClassTopic:(NSDictionary *)aParams
                                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/cls/discuss/add_topic",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    
    NSDictionary * dict1 = [responseObject valueForKey:@"topic"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisUserToic entityWithDictionaty:dict1 inContext:localContext];
    }];
    
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Class Question Api

- (AFHTTPRequestOperation *)clsQuestion:(NSDictionary *)aParams
                                     success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                     failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/questions",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    
    NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"question"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Questions entityFromArray:arrQues inContext:localContext];
    }completion:^(BOOL success, NSError *error) {
      NSArray *arry = [Questions MR_findAll];
      successBlock(task, arry);
    }];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Question Answer Api call

- (AFHTTPRequestOperation *)clsQueaAnswer:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/answer",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    
    //NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"question"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//      [Questions entityFromArray:arrQues inContext:localContext];
//    }];
    
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark - User Answer Admin Comment Api call

- (AFHTTPRequestOperation *)clsAdminComment:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/admin_comments",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    
    NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"admin_comment"];
    NSNumber *answer_Id = [aParams valueForKey:@"answer_id"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
          [QuestionComment entityFromArray:arrQues  withAnswerId:answer_Id inContext:localContext];
        }completion:^(BOOL success, NSError *error) {

          NSPredicate *predicate = [NSPredicate predicateWithFormat:@"answer_Id CONTAINS %i", answer_Id.integerValue];
          NSArray *arry = [QuestionComment MR_findAllWithPredicate:predicate];
          successBlock(task, arry);
        }];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}



#pragma mark - User Answer Api Call Crossponding Question

- (AFHTTPRequestOperation *)userAnswer:(NSDictionary *)aParams
                                   success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                   failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/get_user_answer",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSArray *arrAns = [responseObject valueForKey:@"answers"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [Answer entityFromArray:arrAns inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
      NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ques_id CONTAINS %i",[[aParams valueForKey:@"question_id"]integerValue]];
      NSArray *arry = [Answer MR_findAllWithPredicate:predicate];
      successBlock(task, arry);
    }];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Get User Notes Api Call

- (AFHTTPRequestOperation *)getUserNotes:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/get_all_notes",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSArray *arrUserNotes = [responseObject valueForKey:@"user_notes"];
    NSArray *arrOtherUserNotes = [responseObject valueForKey:@"other_user_notes"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}



#pragma mark - User Create Note Api call

- (AFHTTPRequestOperation *)createUserNotes:(NSDictionary *)aParams
                                 success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                 failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/user_create_note",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSDictionary *dictUser = [responseObject valueForKey:@"note"];
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityWithDictionaty:dictUser inContext:localContext];
     
    }];
    
    successBlock(task, responseObject);
    
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
  NSString *url = [NSString stringWithFormat:@"%@/user_like_note",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    //NSArray *arrUserNotes = [responseObject valueForKey:@"note"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//      [UserNotes entityFromArray:arrUserNotes inContext:localContext];
//      
//    }];
    
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
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
  NSString *url = [NSString stringWithFormat:@"%@/cls_search",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSArray *arryNotes = [[responseObject valueForKey:@"data"]valueForKey:@"classes"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(arryNotes.count == 0){
      successBlock(task,arryNotes);
    }else{
      successBlock(task,arryNotes);
    }
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}




#pragma mark - Search notes Api call

- (AFHTTPRequestOperation *)callSearchNotesApi:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/notes_search",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSArray *arryNotes = [[responseObject valueForKey:@"data"]valueForKey:@"notes"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(arryNotes.count == 0){
      successBlock(task,arryNotes);
    }else{
    successBlock(task,arryNotes);
    }

  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark - Filter notes Api call

- (AFHTTPRequestOperation *)callFilterNotesApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/notes_filter",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);

    NSArray *arryNotes = [[responseObject valueForKey:@"data"]valueForKey:@"notes"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    if(arryNotes.count == 0){
      successBlock(task,arryNotes);
    }else{
      successBlock(task,arryNotes);
    }


  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

  //Edit Notes api
- (AFHTTPRequestOperation *)callNotesUpdateApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/user_update_note",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  return [self PATCH:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *dict = [responseObject valueForKey:@"note"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityFromDictionary:dict inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
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

//Delete Notes api
- (AFHTTPRequestOperation *)callNotesDeleteApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/notes_delete",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  return [self DELETE:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    // Magical recodes delete functionality
    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id CONTAINS %i",[aParams valueForKey:@"note_id"]];
//    NSArray *arryModEle = [UserNotes MR_findAllWithPredicate:predicate];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Add Note Api call
- (AFHTTPRequestOperation *)addNotes:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/user_added_note",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSDictionary *dict = [[responseObject valueForKey:@"data"]valueForKey:@"note"];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityFromDictionary:dict inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
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



#pragma mark - About Us Api call

- (AFHTTPRequestOperation *)aboutUS:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
   NSString *url = [NSString stringWithFormat:@"%@/about_us",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    NSDictionary *dictAbout = [[responseObject valueForKey:@"data"]valueForKey:@"about_us"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
     
      NSNumber *ab_id = [[NSNumber alloc]initWithDouble:1];
      [Aboutus entityWithDictionaty:dictAbout inContext:localContext about_id:ab_id];
      
    } completion:^(BOOL success, NSError *error) {
      NSArray *arryData = [Aboutus MR_findAll];
      successBlock(task, arryData);
    }];
    
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Class Outline Us Api call

- (AFHTTPRequestOperation *)clsOutline:(NSDictionary *)aParams
                            success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                            failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/cls_outline",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    NSMutableArray *arryModule = [responseObject valueForKey:@"data"];
    NSMutableArray *arrOutLine = [[NSMutableArray alloc]init];
   // NSMutableArray *arrModData = [[NSMutableArray alloc]init];
    
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [ClsOutLineModule entityFromArray:arryModule inContext:localContext classID:[aParams valueForKey:@"cls_id"]];
        for (NSDictionary *dict in arryModule) {
        NSMutableArray *arryElement = [dict valueForKey:@"elements"];
        [ClsModElement entityFromArray:arryElement inContext:localContext modId:[dict valueForKey:@"id"]];
      }
      
    } completion:^(BOOL success, NSError *error) {
      
      NSArray *arryData = [ClsOutLineModule MR_findAll];
      NSArray *arry = [ClsModElement MR_findAll];
      NSLog(@"%lu",(unsigned long)arry.count);
      
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
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark - Video Complete Api call Api call

- (AFHTTPRequestOperation *)videoComplete:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/finished_video",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);

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
    
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark -  Feedback  Api call

- (AFHTTPRequestOperation *)feedback:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/feedback",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark -  PaypalApi call

- (AFHTTPRequestOperation *)paypalApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/buy_class",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    successBlock(task, responseObject);
    
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark -  Get User Class Orders  Api call

- (AFHTTPRequestOperation *)userClassOrders:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/buyclassorder",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
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
    
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}


#pragma mark -  Start Learning Api call

- (AFHTTPRequestOperation *)startLearning:(NSDictionary *)aParams
                                    success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                    failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/start_learn",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
}

#pragma mark - Wallet Api call
- (AFHTTPRequestOperation *)walletApi:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/use_wallet",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
      successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      failureBlock(task, error);
      NSLog(@"%@",error);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }
  }];
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
