//
//  DisUserToic.m
//  Tonguer
//
//  Created by GrepRuby on 09/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "DisUserToic.h"


@implementation DisUserToic

@dynamic topic_id;
@dynamic topic_name;
@dynamic topic_content;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  DisUserToic *obj = [DisUserToic MR_findFirstByAttribute:@"topic_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [DisUserToic MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [DisUserToic entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [DisUserToic entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    DisUserToic *obj = (DisUserToic*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.topic_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"title"] isKindOfClass:[NSNull class]])
      obj.topic_name = [aDictionary valueForKey:@"title"] ;
    
    if (![[aDictionary objectForKey:@"content"] isKindOfClass:[NSNull class]])
      obj.topic_content = [aDictionary valueForKey:@"content"] ;
    
    return obj;
  }
  return nil;
}


@end
