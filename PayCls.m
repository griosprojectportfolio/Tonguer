//
//  PayCls.m
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "PayCls.h"


@implementation PayCls

@dynamic cls_id;
@dynamic cls_name;
@dynamic cls_img_url;
@dynamic cls_days;
@dynamic cls_price;
@dynamic paysubcat;
@dynamic cls_arrange;
@dynamic cls_suitable;
@dynamic cls_target;
@dynamic cls_score;
@dynamic cls_progress;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  PayCls *obj = [PayCls MR_findFirstByAttribute:@"cls_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [PayCls MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [PayCls entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [PayCls entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    PayCls *obj = (PayCls*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.cls_name = [aDictionary valueForKey:@"name"] ;
    
    if (![[aDictionary objectForKey:@"image"] isKindOfClass:[NSNull class]])
      obj.cls_img_url = [aDictionary valueForKey:@"image"] ;
    
    if (![[aDictionary objectForKey:@"left_days"] isKindOfClass:[NSNull class]])
      obj.cls_days = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"left_days"] integerValue]];
    
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
      obj.cls_suitable = [aDictionary valueForKey:@"target"] ;

    
    return obj;
  }
  return nil;
}



@end
