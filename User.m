//
//  User.m
//  Tonguer
//
//  Created by GrepRuby on 07/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic email;
@dynamic fname;
@dynamic lname;
@dynamic money;
@dynamic pro_img;
@dynamic score;
@dynamic user_id;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  User *obj = [User MR_findFirstByAttribute:@"user_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [User MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [User entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [User entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    User *obj = (User*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    
    obj.user_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"money"] isKindOfClass:[NSNull class]])
      obj.money = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"money"] integerValue]];
    
    if (![[aDictionary objectForKey:@"email"] isKindOfClass:[NSNull class]])
      obj.email = [aDictionary valueForKey:@"email"] ;
    
    if (![[aDictionary objectForKey:@"first_name"] isKindOfClass:[NSNull class]])
      obj.fname = [aDictionary objectForKey:@"first_name"];
    
    if (![[aDictionary objectForKey:@"last_name"] isKindOfClass:[NSNull class]])
      obj.lname = [aDictionary valueForKey:@"last_name"];
    
    if (![[aDictionary objectForKey:@"score"] isKindOfClass:[NSNull class]])
      obj.score =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"score"] integerValue]];
    
    if (![[aDictionary objectForKey:@"userimage"] isKindOfClass:[NSNull class]])
      obj.pro_img =[aDictionary valueForKey:@"userimage"];
    
    
    return obj;
  }
  return nil;
}


@end