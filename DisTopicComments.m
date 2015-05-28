//
//  DisTopicComments.m
//  Tonguer
//
//  Created by GrepRuby on 11/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "DisTopicComments.h"


@implementation DisTopicComments

@dynamic comment_id;
@dynamic commment;
@dynamic name;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  DisTopicComments *obj = [DisTopicComments MR_findFirstByAttribute:@"comment_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [DisTopicComments MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray withTopicId:(NSNumber *)topicId  inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [DisTopicComments entityFromDictionary:aDictionary withTopicId:topicId   inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary withTopicId:(NSNumber *)topicId inContext:(NSManagedObjectContext *)localContext {
  [DisTopicComments entityFromDictionary:adictionary withTopicId:topicId  inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary withTopicId:(NSNumber *)topicId inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    DisTopicComments *obj = (DisTopicComments*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.comment_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"comment"] isKindOfClass:[NSNull class]])
      obj.commment = [aDictionary valueForKey:@"comment"] ;
    
    if (![[aDictionary objectForKey:@"comment_userable_type"] isKindOfClass:[NSNull class]])
      obj.name = [aDictionary valueForKey:@"comment_userable_type"] ;
    
    obj.topic_Id = topicId;
    
    return obj;
  }
  return nil;
}


@end
