//
//  UserClsVideo.m
//  Tonguer
//
//  Created by GrepRuby on 08/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "UserClsVideo.h"


@implementation UserClsVideo

@dynamic vdo_id;
@dynamic cls_id;
@dynamic vdo_name;
@dynamic vdo_img;
@dynamic vdo_url;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  UserClsVideo *obj = [UserClsVideo MR_findFirstByAttribute:@"vdo_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [UserClsVideo MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    
    [UserClsVideo entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [UserClsVideo entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    UserClsVideo *obj = (UserClsVideo*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.vdo_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    obj.cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"a_class_id"] integerValue]];

    if (![[[aDictionary objectForKey:@"image"] valueForKey:@"url"] isKindOfClass:[NSNull class]])
      obj.vdo_img = [[aDictionary valueForKey:@"image"] valueForKey:@"url"] ;
    
    if (![[aDictionary objectForKey:@"video"] isKindOfClass:[NSNull class]])
      obj.vdo_url = [aDictionary valueForKey:@"video"] ;
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.vdo_name = [aDictionary valueForKey:@"name"] ;

    
    return obj;
  }
  return nil;
}


@end
