//
//  UserClassOrder.m
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "UserClassOrder.h"


@implementation UserClassOrder

@dynamic order_id;
@dynamic cls_id;
@dynamic cls_name;
@dynamic is_buy;
@dynamic date;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  UserClassOrder *obj = [UserClassOrder MR_findFirstByAttribute:@"order_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [UserClassOrder MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [UserClassOrder entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [UserClassOrder entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    UserClassOrder *obj = (UserClassOrder*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.order_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    obj.cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"class_id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.cls_name = [aDictionary valueForKey:@"name"];
    
    if (![[aDictionary objectForKey:@"date"] isKindOfClass:[NSNull class]])
      obj.date = [aDictionary valueForKey:@"date"];
    
    if (![[aDictionary objectForKey:@"is_buy"] isKindOfClass:[NSNull class]])
      obj.is_buy = [aDictionary valueForKey:@"is_buy"];
    
    return obj;
  }
  return nil;
}


@end
