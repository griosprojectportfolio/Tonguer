//
//  Notes.m
//  Tonguer
//
//  Created by GrepRuby on 19/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "Notes.h"



@implementation Notes

@dynamic notes_id;
@dynamic notes_content;
@dynamic notes_date;
@dynamic notes_cls_id;
@dynamic notes_cls_name;
@dynamic isenable;
@dynamic notes_like_cont;
@dynamic notes_img;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  Notes *obj = [Notes MR_findFirstByAttribute:@"notes_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [Notes MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [Notes entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [Notes entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    Notes *obj = (Notes*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.notes_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    obj.notes_cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"a_class_id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"content"] isKindOfClass:[NSNull class]])
      obj.notes_content = [aDictionary valueForKey:@"content"] ;
    
    if (![[aDictionary objectForKey:@"like_count"] isKindOfClass:[NSNull class]])
      obj.notes_like_cont = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"like_count"] integerValue]];
    
    if (![[aDictionary objectForKey:@"created_at"] isKindOfClass:[NSNull class]]){
      
      NSString *createsDate = [aDictionary objectForKey:@"created_at"];
      NSString *strDate = [createsDate substringToIndex:(createsDate.length - 5)];
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss";
      
      NSDate *crDate = [dateFormatter dateFromString:strDate];
      NSLog(@"%@",crDate);
      obj.notes_date = crDate;
    }
    
    if (![[[aDictionary objectForKey:@"image"] objectForKey:@"url"] isKindOfClass:[NSNull class]])
      obj.notes_img = [[aDictionary valueForKey:@"image"] objectForKey:@"url"] ;
    
    if (![[aDictionary objectForKey:@"is_enable"] isKindOfClass:[NSNull class]])
      obj.isenable = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_enable"] integerValue]];
    
    return obj;
  }
  return nil;
}


@end
