//
//  UserDefaultClsList.m
//  Tonguer
//
//  Created by GrepRuby on 07/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "UserDefaultClsList.h"


@implementation UserDefaultClsList

@dynamic cls_id;
@dynamic cls_img_url;
@dynamic cls_name;
@dynamic cls_price;
@dynamic cls_progress;
@dynamic cls_score;
@dynamic cls_vaild_days;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  UserDefaultClsList *obj = [UserDefaultClsList MR_findFirstByAttribute:@"cls_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [UserDefaultClsList MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [UserDefaultClsList entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [UserDefaultClsList entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    UserDefaultClsList *obj = (UserDefaultClsList*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    
    obj.cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"price"] isKindOfClass:[NSNull class]])
      obj.cls_price = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"price"] doubleValue]];
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.cls_name = [aDictionary valueForKey:@"name"] ;
    
    if (![[aDictionary objectForKey:@"image"] isKindOfClass:[NSNull class]])
      obj.cls_img_url = [aDictionary objectForKey:@"image"];
    
    if (![[aDictionary objectForKey:@"progress"] isKindOfClass:[NSNull class]])
      obj.cls_progress = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"progress"] doubleValue]];
    
    if (![[aDictionary objectForKey:@"score"] isKindOfClass:[NSNull class]])
      obj.cls_score =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"score"] integerValue]];
    
    if (![[aDictionary objectForKey:@"valid_days"] isKindOfClass:[NSNull class]])
      obj.cls_vaild_days =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"valid_days"] integerValue]];
    
    
    return obj;
  }
  return nil;
}


@end
