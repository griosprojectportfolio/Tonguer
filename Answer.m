//
//  Answer.m
//  Tonguer
//
//  Created by GrepRuby on 15/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "Answer.h"


@implementation Answer

@dynamic ans_id;
@dynamic answer;
@dynamic ques_id;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  Answer *obj = [Answer MR_findFirstByAttribute:@"ans_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [Answer MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [Answer entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [Answer entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    Answer *obj = (Answer*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.ans_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"answer"] isKindOfClass:[NSNull class]])
      obj.answer = [aDictionary valueForKey:@"answer"] ;
    
    if (![[aDictionary objectForKey:@"question_id"] isKindOfClass:[NSNull class]])
      obj.ques_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"question_id"] integerValue]];

    
    
    return obj;
  }
  return nil;
}


@end
