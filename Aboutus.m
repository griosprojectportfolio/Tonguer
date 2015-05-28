//
//  Aboutus.m
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "Aboutus.h"


@implementation Aboutus

@dynamic ab_id;
@dynamic ab_content;
@dynamic ab_videourl;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  Aboutus *obj = [Aboutus MR_findFirstByAttribute:@"ab_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [Aboutus MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [Aboutus entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [Aboutus entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    Aboutus *obj = (Aboutus*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.ab_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    
    if (![[aDictionary objectForKey:@"content"] isKindOfClass:[NSNull class]])
      obj.ab_content = [aDictionary valueForKey:@"content"] ;
    
    if (![[aDictionary objectForKey:@"video"] isKindOfClass:[NSNull class]])
      obj.ab_videourl = [aDictionary valueForKey:@"video"] ;

    
    return obj;
  }
  return nil;
}


@end
