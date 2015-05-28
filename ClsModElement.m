//
//  ClsModElement.m
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "ClsModElement.h"


@implementation ClsModElement

@dynamic mod_element_id;
@dynamic mod_element_content;
@dynamic mod_id;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  ClsModElement *obj = [ClsModElement MR_findFirstByAttribute:@"mod_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [ClsModElement MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [ClsModElement entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [ClsModElement entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    ClsModElement *obj = (ClsModElement*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.mod_element_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    obj.mod_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"mod_id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"content"] isKindOfClass:[NSNull class]])
      obj.mod_element_content = [aDictionary valueForKey:@"content"] ;
    
    
    return obj;
  }
  return nil;
}


@end
