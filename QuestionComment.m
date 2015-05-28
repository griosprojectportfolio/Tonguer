//
//  QuestionComment.m
//  Tonguer
//
//  Created by GrepRuby on 12/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "QuestionComment.h"


@implementation QuestionComment

@dynamic comt_id;
@dynamic comment;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  QuestionComment *obj = [QuestionComment MR_findFirstByAttribute:@"comt_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [QuestionComment MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray withAnswerId:(NSNumber *)answer_Id inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [QuestionComment entityFromDictionary:aDictionary withAnswerId:answer_Id inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary withAnswerId:(NSNumber *)answer_Id inContext:(NSManagedObjectContext *)localContext {
  [QuestionComment entityFromDictionary:adictionary  withAnswerId:answer_Id  inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary withAnswerId:(NSNumber *)answer_Id inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    QuestionComment *obj = (QuestionComment*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.comt_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"comment"] isKindOfClass:[NSNull class]])
      obj.comment = [aDictionary valueForKey:@"comment"] ;
    
   obj.answer_Id = answer_Id;
    
    return obj;
  }
  return nil;
}


@end
