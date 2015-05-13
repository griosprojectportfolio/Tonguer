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
      }];
      successBlock(task, responseObject);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
    NSString *url = [NSString stringWithFormat:@"%@/sessions/logout",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self DELETE:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
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
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
  
      [FreeCls entityFromArray:arrClsList inContext:localContext];
  
      NSArray *arrFetchCat  = [FreeCls MR_findAll];
      NSLog(@"%@",arrFetchCat);
    }];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    successBlock(task, responseObject);
    
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
      
      NSArray *arrFetchCat  = [FreeClssVideo MR_findAll];
      NSLog(@"%@",arrFetchCat);
      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      
      [PayCls entityFromArray:arrClsList inContext:localContext];
      
      NSArray *arrFetchCat  = [PayCls MR_findAll];
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
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisTopicComments entityFromArray:adminData inContext:localContext];
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
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
      [DisTopicComments entityWithDictionaty:dict1 inContext:localContext];
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

#pragma mark - Question Comment Api call

- (AFHTTPRequestOperation *)clsQueaComment:(NSDictionary *)aParams
                                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/admin_comments",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSLog(@"%@",responseObject);
    
    
    NSArray *arrQues = [[responseObject valueForKey:@"data"]valueForKey:@"admin_comment"];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
          [QuestionComment entityFromArray:arrQues inContext:localContext];
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



#pragma mark Method to Downloading Media Data from server


- (void)downloadMediaData:(NSDictionary *)aParams
                  success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                  failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  NSString *url = [NSString stringWithFormat:@"%@",[aParams objectForKey:@"url"]];
  NSString *strFileNameWithExt = [[NSString alloc] initWithFormat:@"%@",[aParams objectForKey:@"fileName"]];
  NSArray *docDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *mediaPath = [[docDirPath objectAtIndex:0] stringByAppendingPathComponent:strFileNameWithExt];
  //BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:mediaPath];
  
  AFHTTPRequestOperation *operation = [self GET:url
                                     parameters:nil
                                        success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                          NSLog(@"successful download to %@", mediaPath);
                                          successBlock(operation, responseObject);
                                        }
                                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                          NSLog(@"Error: %@", error);
                                          failureBlock(operation, error);
                                        }];
  operation.outputStream = [NSOutputStream outputStreamToFileAtPath:mediaPath append:NO];
}



@end
