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
      successBlock(task, responseObject);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
      
      
      
      [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [User entityFromDictionary:aParams inContext:localContext];
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
      for (int i=0; i < arrCategory.count; i++) {
        NSMutableArray *arrSubCategory = [[arrCategory objectAtIndex:i] valueForKey:@"sub_categories"];
        [FreeSubCat entityFromArray:arrSubCategory inContext:localContext];
      }
      [FreeClsCat entityFromArray:arrCategory inContext:localContext];
      
      NSArray *arrFetchCat  = [FreeClsCat MR_findAll];
      NSLog(@"%@",arrFetchCat);
    }];
    
       successBlock(task, responseObject);
    
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
      for (int i=0; i < arrCategory.count; i++) {
        NSMutableArray *arrSubCategory = [[arrCategory objectAtIndex:i] valueForKey:@"sub_categories"];
        [PaySubCat entityFromArray:arrSubCategory inContext:localContext];
      }
      [PayClsCat entityFromArray:arrCategory inContext:localContext];
      
      NSArray *arrFetchCat  = [FreeClsCat MR_findAll];
      NSLog(@"%@",arrFetchCat);
      
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
    NSDictionary *dictImg = [dict valueForKey:@"img_url"];
    NSString *strImg = [dictImg valueForKey:@"url"];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      //[Addvertiesment entityFromArray:arrVideoList inContext:localContext];
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
      NSArray *arry = [Answer MR_findAll];
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
    
    NSArray *arrUserNotes = [responseObject valueForKey:@"note"];
   
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [UserNotes entityFromArray:arrUserNotes inContext:localContext];
     
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
  
 // NSString *url = [NSString stringWithFormat:@"%@",[aParams objectForKey:@"url"]];
   NSString *url = @"http://download.wavetlan.com/SVV/Media/HTTP/MP4/ConvertedFiles/MediaCoder/MediaCoder_test1_1m9s_AVC_VBR_256kbps_640x480_24fps_MPEG2Layer3_CBR_160kbps_Stereo_22050Hz.mp4";
//  NSString *strFileNameWithExt = [[NSString alloc] initWithFormat:@"%@",[aParams objectForKey:@"fileName"]];
//  NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//  NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:strFileNameWithExt];
 
  NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
  
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
  operation.outputStream = [NSOutputStream outputStreamToFileAtPath:path append:NO];
  
  [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Successfully downloaded file to %@", path);
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


#pragma mark - Search notes Api call

- (AFHTTPRequestOperation *)callSearchNotesApi:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
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

#pragma mark - Filter notes Api call

- (AFHTTPRequestOperation *)callFilterNotesApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
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

  //Edit Notes api
- (AFHTTPRequestOperation *)callNotesUpdateApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  return [self PUT:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
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

//Delete Notes api
- (AFHTTPRequestOperation *)callNotesDeleteApi:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{

  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

  return [self DELETE:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
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


#pragma mark - About Us Api call

- (AFHTTPRequestOperation *)aboutUS:(NSDictionary *)aParams
                                       success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                       failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
//  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
   NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
     
      [Aboutus entityFromDictionary:responseObject inContext:localContext];
      
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
  
  //  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      
      [ClsOutLineModule entityFromDictionary:responseObject inContext:localContext];
      
    } completion:^(BOOL success, NSError *error) {
      NSArray *arryData = [ClsOutLineModule MR_findAll];
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


#pragma mark - Video Complete Api call Api call

- (AFHTTPRequestOperation *)videoComplete:(NSDictionary *)aParams
                               success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                               failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      
      [ClsOutLineModule entityFromDictionary:responseObject inContext:localContext];
      
    } completion:^(BOOL success, NSError *error) {
      NSArray *arryData = [ClsOutLineModule MR_findAll];
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


#pragma mark -  Feedback  Api call

- (AFHTTPRequestOperation *)feedback:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      
      [ClsOutLineModule entityFromDictionary:responseObject inContext:localContext];
      
    } completion:^(BOOL success, NSError *error) {
      NSArray *arryData = [ClsOutLineModule MR_findAll];
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

#pragma mark -  User Buy class  Api call

- (AFHTTPRequestOperation *)buyClass:(NSDictionary *)aParams
                             success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                             failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock {
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    successBlock(task, responseObject);
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//      
//      [ClsOutLineModule entityFromDictionary:responseObject inContext:localContext];
//      
//    } completion:^(BOOL success, NSError *error) {
//      NSArray *arryData = [ClsOutLineModule MR_findAll];
//      
//    }];
    
    
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
  NSString *url = [NSString stringWithFormat:@"%@/",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    successBlock(task, responseObject);
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    
          [UserClassOrder entityFromDictionary:responseObject inContext:localContext];
    
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

- (NSURL *)getDocumentDirectoryFileURL:(NSDictionary *)aParams {
  NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *filePath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:[aParams objectForKey:@"fileName"]];
  return [NSURL fileURLWithPath:filePath];
}

@end
