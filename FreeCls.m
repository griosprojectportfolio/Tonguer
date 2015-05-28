//
//  FreeCls.m
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "FreeCls.h"
#import "FreeSubCat.h"


@implementation FreeCls

@dynamic cls_day;
@dynamic cls_id;
@dynamic cls_name;
@dynamic img_url;
@dynamic freesubcat;
@dynamic cls_price;
@dynamic cls_arrange;
@dynamic cls_suitable;
@dynamic cls_target;
@dynamic cls_score;
@dynamic cls_progress;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  FreeCls *obj = [FreeCls MR_findFirstByAttribute:@"cls_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [FreeCls MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray withSubcategoryId:(NSNumber *)categoryId inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [FreeCls entityFromDictionary:aDictionary withSubcategoryId:categoryId inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary withSubcategoryId:(NSNumber *)categoryId inContext:(NSManagedObjectContext *)localContext {
  [FreeCls entityFromDictionary:adictionary withSubcategoryId:categoryId inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary withSubcategoryId:(NSNumber *)categoryId inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    FreeCls *obj = (FreeCls*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.cls_name = [aDictionary valueForKey:@"name"] ;
    
    if (![[aDictionary objectForKey:@"image"] isKindOfClass:[NSNull class]])
      obj.img_url = [aDictionary valueForKey:@"image"] ;
    
    if (![[aDictionary objectForKey:@"left_days"] isKindOfClass:[NSNull class]])
      obj.cls_day = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"left_days"] integerValue]];
    
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

      obj.cls_subcategory_Id = categoryId;
    return obj;
  }
  return nil;
}


@end
