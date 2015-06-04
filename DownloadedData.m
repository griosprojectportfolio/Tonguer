//
//  DownloadedData.m
//  Tonguer
//
//  Created by GrepRuby on 03/06/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "DownloadedData.h"


@implementation DownloadedData

@dynamic download_id;
@dynamic download_data;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  DownloadedData *obj = [DownloadedData MR_findFirstByAttribute:@"download_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [DownloadedData MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [DownloadedData entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [DownloadedData entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    DownloadedData *obj = (DownloadedData*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.download_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
  
    if (![[aDictionary objectForKey:@"data"] isKindOfClass:[NSNull class]])
      obj.download_data = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"data"]doubleValue]];
    
    
    return obj;
  }
  return nil;
}


@end
