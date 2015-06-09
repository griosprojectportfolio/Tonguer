//
//  HostPayCls.m
//  Tonguer
//
//  Created by GrepRuby on 08/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "HostPayCls.h"


@implementation HostPayCls

@dynamic cls_id;
@dynamic cls_name;
@dynamic cls_img;
@dynamic cls_days;
@dynamic cls_price;
@dynamic cls_score;
@dynamic cls_progress;
@dynamic cls_arrange;
@dynamic cls_suitable;
@dynamic cls_target;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  HostPayCls *obj = [HostPayCls MR_findFirstByAttribute:@"cls_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [HostPayCls MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [HostPayCls entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [HostPayCls entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    HostPayCls *obj = (HostPayCls*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.cls_name = [aDictionary valueForKey:@"name"] ;
    
    if (![[aDictionary objectForKey:@"image"] isKindOfClass:[NSNull class]])
      obj.cls_img = [aDictionary valueForKey:@"image"] ;
    
    if (![[aDictionary objectForKey:@"valid_days"] isKindOfClass:[NSNull class]])
      obj.cls_days = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"valid_days"] integerValue]];
    
    if (![[aDictionary objectForKey:@"price"] isKindOfClass:[NSNull class]])
      obj.cls_price = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"price"] integerValue]];
    
    if (![[aDictionary objectForKey:@"progress"] isKindOfClass:[NSNull class]])
      obj.cls_progress = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"progress"] integerValue]];
    
    if (![[aDictionary objectForKey:@"score"] isKindOfClass:[NSNull class]])
      obj.cls_score = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"score"] integerValue]];
    
    
    if (![[aDictionary objectForKey:@"arrange"] isKindOfClass:[NSNull class]])
      obj.cls_arrange = [aDictionary valueForKey:@"arrange"] ;
    
    if (![[aDictionary objectForKey:@"suitable"] isKindOfClass:[NSNull class]])
      obj.cls_suitable = [aDictionary valueForKey:@"suitable"] ;
    
    if (![[aDictionary objectForKey:@"target"] isKindOfClass:[NSNull class]])
      obj.cls_target = [aDictionary valueForKey:@"target"] ;
    
    return obj;
  }
  return nil;
}


@end
