//
//  FreeClsCat.m
//  Tonguer
//
//  Created by GrepRuby on 24/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "FreeClsCat.h"


@implementation FreeClsCat

@dynamic cat_id;
@dynamic cat_name;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  FreeClsCat *obj = [FreeClsCat MR_findFirstByAttribute:@"cat_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [FreeClsCat MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    
    [FreeClsCat entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [FreeClsCat entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    FreeClsCat *obj = (FreeClsCat*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.cat_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];

    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.cat_name = [aDictionary valueForKey:@"name"] ;
    
    
    return obj;
  }
  return nil;
}


@end
