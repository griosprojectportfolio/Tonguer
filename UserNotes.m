//
//  UserNotes.m
//  Tonguer
//
//  Created by GrepRuby on 19/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "UserNotes.h"


@implementation UserNotes

@dynamic notes_id;
@dynamic notes_content;
@dynamic notes_img;
@dynamic notes_date;
@dynamic notes_cls_id;
@dynamic notes_cls_name;
@dynamic notes_like_count;
@dynamic isenable;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  UserNotes *obj = [UserNotes MR_findFirstByAttribute:@"notes_id" withValue:anID inContext:localContext];
  
  if (!obj || [obj isEqual:[NSNull class]] ) {
    obj = [UserNotes MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [UserNotes entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [UserNotes entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    UserNotes *obj = (UserNotes*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.notes_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    
    if (![[aDictionary objectForKey:@"content"] isKindOfClass:[NSNull class]])
      obj.notes_content = [aDictionary valueForKey:@"content"] ;
    
    if (![[aDictionary objectForKey:@"like_count"] isKindOfClass:[NSNull class]])
      obj.notes_like_count = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"like_count"] integerValue]];
    
    if (![[aDictionary objectForKey:@"created_at"] isKindOfClass:[NSNull class]]){
      NSString *createsDate = [aDictionary objectForKey:@"created_at"];
      NSString *strDate = [createsDate substringToIndex:(createsDate.length - 5)];
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      dateFormatter.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss";
      
      NSDate *crDate = [dateFormatter dateFromString:strDate];
      NSLog(@"%@",crDate);
      obj.notes_date = crDate;

      
    }
    
    if (![[[aDictionary objectForKey:@"image"]valueForKey:@"url"] isKindOfClass:[NSNull class]]){
      
//      NSString *strImgBaseUrl = @"https://tonguer.herokuapp.com";
//      NSString *imgUrl = [strImgBaseUrl stringByAppendingString:[[aDictionary valueForKey:@"image"]valueForKey:@"url"]];
      obj.notes_img = [[aDictionary valueForKey:@"image"]valueForKey:@"url"];
      
    }
    
    
    if (![[aDictionary objectForKey:@"is_enable"] isKindOfClass:[NSNull class]])
      obj.isenable = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"is_enable"] integerValue]];
    
    if (![[aDictionary objectForKey:@"a_class_id"] isKindOfClass:[NSNull class]])
      obj.notes_cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"a_class_id"] integerValue]];
    
    if (![[[aDictionary objectForKey:@"a_class"]valueForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.notes_cls_name =  [[aDictionary valueForKey:@"a_class"]valueForKey:@"name"];

    
    return obj;
  }
  return nil;
}


@end
