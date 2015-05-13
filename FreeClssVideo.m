//
//  FreeClssVideo.m
//  Tonguer
//
//  Created by GrepRuby on 01/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "FreeClssVideo.h"


@implementation FreeClssVideo

@dynamic video_id;
@dynamic video_img_url;
@dynamic video_url;
@dynamic video_name;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  FreeClssVideo *obj = [FreeClssVideo MR_findFirstByAttribute:@"video_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [FreeClssVideo MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    
    [FreeClssVideo entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [FreeClssVideo entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    FreeClssVideo *obj = (FreeClssVideo*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.video_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"image"] isKindOfClass:[NSNull class]])
      obj.video_img_url = [aDictionary valueForKey:@"image"] ;
    
    if (![[aDictionary objectForKey:@"video"] isKindOfClass:[NSNull class]])
      obj.video_url = [aDictionary valueForKey:@"video"] ;
    
    if (![[aDictionary objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.video_name = [aDictionary valueForKey:@"name"] ;
    
    return obj;
  }
  return nil;
}


@end
