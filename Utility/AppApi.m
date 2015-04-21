//
//  AppApi.m
//  Rondogo
//
//  Created by GrepRuby3 on 14/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//
#import "AppApi.h"

/* API Constants */
static NSString * const kAppAPIBaseURLString = @"http://192.168.10.21:3000/api/v1";
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
    //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    return [self POST:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
      
      NSLog(@"%@",responseObject);
      successBlock(task, responseObject);
      
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        if(failureBlock){
          
            failureBlock(task, error);
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
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
    NSMutableDictionary *dictParams = [[NSMutableDictionary alloc] initWithDictionary:aParams];
    [dictParams removeObjectForKey:@"auth_token"];
    
    NSString *url = [NSString stringWithFormat:@"%@/update",kAppAPIBaseURLString];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return [self PATCH:url parameters:dictParams success:^(AFHTTPRequestOperation *task, id responseObject) {

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
        if(failureBlock){
          
          
        }
    }];
}



#pragma mark - userclass and basic info


- (AFHTTPRequestOperation *)userClass:(NSDictionary *)aParams
                                success:(void (^)(AFHTTPRequestOperation *task, id responseObject))successBlock
                                failure:(void (^)(AFHTTPRequestOperation *task, NSError *error))failureBlock{
  
  [self.requestSerializer setValue:[aParams valueForKey:@"auth_token"] forHTTPHeaderField:@"auth_token"];
  NSString *url = [NSString stringWithFormat:@"%@/class_list",kAppAPIBaseURLString];
  [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
  
  return [self GET:url parameters:aParams success:^(AFHTTPRequestOperation *task, id responseObject) {
    
    NSLog(@"%@",responseObject);
    successBlock(task, responseObject);
    
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    if(failureBlock){
      
      NSLog(@"%@",error);
    }
  }];
}




@end
