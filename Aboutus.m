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


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext about_id:(NSNumber*)ab_id{
  for(NSDictionary *aDictionary in aArray) {
    [Aboutus entityFromDictionary:aDictionary inContext:localContext about_id:ab_id];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext about_id:(NSNumber*)ab_id {
  [Aboutus entityFromDictionary:adictionary inContext:localContext about_id:ab_id];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext about_id:(NSNumber*)ab_id{
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    Aboutus *obj = (Aboutus*)[self findOrCreateByID:ab_id inContext:localContext];
    
    obj.ab_id = ab_id;
    
    if (![[aDictionary objectForKey:@"message"] isKindOfClass:[NSNull class]])
      obj.ab_content = [aDictionary valueForKey:@"message"] ;
    
    if (![[aDictionary objectForKey:@"video_url"] isKindOfClass:[NSNull class]])
      obj.ab_videourl = [aDictionary valueForKey:@"video_url"] ;

    
    return obj;
  }
  return nil;
}


@end
