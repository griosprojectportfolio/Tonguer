//
//  FreeSubCat.m
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "FreeSubCat.h"
#import "FreeCls.h"
#import "FreeClsCat.h"


@implementation FreeSubCat

@dynamic sub_cat_id;
@dynamic sub_cat_name;
@dynamic freeclscat;
@dynamic freecls;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  FreeSubCat *obj = [FreeSubCat MR_findFirstByAttribute:@"sub_cat_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [FreeSubCat MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [FreeSubCat entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [FreeSubCat entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    FreeSubCat *obj = (FreeSubCat*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.sub_cat_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.sub_cat_name = [aDictionary valueForKey:@"name"] ;
    
    return obj;
  }
  return nil;
}



@end
