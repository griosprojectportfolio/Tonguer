//
//  UserLearnClsList.m
//  Tonguer
//
//  Created by GrepRuby on 07/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "UserLearnClsList.h"


@implementation UserLearnClsList

@dynamic cls_id;
@dynamic cls_name;
@dynamic cls_price;
@dynamic cls_progress;
@dynamic cls_score;
@dynamic cls_vaild_days;
@dynamic cls_img_url;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  UserLearnClsList *obj = [UserLearnClsList MR_findFirstByAttribute:@"cls_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [UserLearnClsList MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [UserLearnClsList entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [UserLearnClsList entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"a_class_id"] isKindOfClass:[NSNull class]]){
    
    UserLearnClsList *obj = (UserLearnClsList*)[self findOrCreateByID:[aDictionary objectForKey:@"a_class_id"] inContext:localContext];
    
    
    obj.cls_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"a_class_id"] integerValue]];
    
    if (![[[aDictionary objectForKey:@"a_class"] objectForKey:@"price"] isKindOfClass:[NSNull class]])
      obj.cls_price = [NSNumber numberWithInteger:[[[aDictionary objectForKey:@"a_class"] objectForKey:@"price"] doubleValue]];
    
    if (![[[aDictionary objectForKey:@"a_class"] objectForKey:@"name"] isKindOfClass:[NSNull class]])
      obj.cls_name = [[aDictionary valueForKey:@"a_class"] objectForKey:@"name"] ;
    
    if (![[[[aDictionary objectForKey:@"a_class"] valueForKey:@"image"] objectForKey:@"url"] isKindOfClass:[NSNull class]])
      obj.cls_img_url = [[[aDictionary objectForKey:@"a_class"] valueForKey:@"image"] objectForKey:@"url"];
    
    if (![[aDictionary objectForKey:@"learn_status"] isKindOfClass:[NSNull class]])
      obj.cls_progress = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"learn_status"] doubleValue]];
    
    if (![[[aDictionary objectForKey:@"a_class"] objectForKey:@"score"] isKindOfClass:[NSNull class]])
      obj.cls_score =[NSNumber numberWithInteger:[[[aDictionary objectForKey:@"a_class"] objectForKey:@"score"] integerValue]];
    
    if (![[[aDictionary objectForKey:@"a_class"] objectForKey:@"valid_days"] isKindOfClass:[NSNull class]])
      obj.cls_vaild_days =[NSNumber numberWithInteger:[[[aDictionary objectForKey:@"a_class"] objectForKey:@"valid_days"] integerValue]];
    
    return obj;
  }
  return nil;
}



@end
