//
//  VideoDone.m
//  Tonguer
//
//  Created by GrepRuby on 06/06/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "VideoDone.h"


@implementation VideoDone

@dynamic video_id;
@dynamic video_is;
@dynamic video_cls_id;
@dynamic user_id;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  VideoDone *obj = [VideoDone MR_findFirstByAttribute:@"video_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [VideoDone MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext userid:(NSNumber *)userid{
  for(NSDictionary *aDictionary in aArray) {
    [VideoDone entityFromDictionary:aDictionary inContext:localContext userid:userid];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext userid:(NSNumber *)userid {
  [VideoDone entityFromDictionary:adictionary inContext:localContext userid:userid];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext userid:(NSNumber *)userid {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    VideoDone *obj = (VideoDone*)[self findOrCreateByID:[aDictionary objectForKey:@"video_id"] inContext:localContext];
    
    obj.video_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"video_id"] integerValue]];
    obj.video_cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"cls_id"] integerValue]];
    obj.user_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"userId"] integerValue]];;
      NSNumber *done = [[NSNumber alloc]initWithDouble:1];
      obj.video_is = done;//[NSNumber numberWithInteger:[[aDictionary objectForKey:@"video_is"]boolValue]];
    
    return obj;
  }
  return nil;
}


@end
