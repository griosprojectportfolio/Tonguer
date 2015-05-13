//
//  PaySubCat.m
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "PaySubCat.h"
#import "PayCls.h"
#import "PayClsCat.h"


@implementation PaySubCat

@dynamic sub_cat_id;
@dynamic sub_cat_name;
@dynamic payclscat;
@dynamic paycls;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  PaySubCat *obj = [PaySubCat MR_findFirstByAttribute:@"sub_cat_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [PaySubCat MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [PaySubCat entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [PaySubCat entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    PaySubCat *obj = (PaySubCat*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.sub_cat_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.sub_cat_name = [aDictionary valueForKey:@"name"] ;
    
    return obj;
  }
  return nil;
}


@end
