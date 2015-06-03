//
//  ClsOutLineModule.m
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "ClsOutLineModule.h"


@implementation ClsOutLineModule

@dynamic mod_id;
@dynamic mod_content;
@dynamic cls_id;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  ClsOutLineModule *obj = [ClsOutLineModule MR_findFirstByAttribute:@"mod_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [ClsOutLineModule MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext classID:(NSNumber *)class_id {
  for(NSDictionary *aDictionary in aArray) {
    [ClsOutLineModule entityFromDictionary:aDictionary inContext:localContext classID:class_id];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext classID:(NSNumber *)class_id {
  [ClsOutLineModule entityFromDictionary:adictionary inContext:localContext classID:class_id];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext classID:(NSNumber *)class_id{
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    ClsOutLineModule *obj = (ClsOutLineModule*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.mod_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    obj.cls_id = class_id;
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.mod_content = [aDictionary valueForKey:@"name"] ;
    

    return obj;
  }
  return nil;
}


@end
