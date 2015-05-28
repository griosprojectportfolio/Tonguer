//
//  QuestionComment.h
//  Tonguer
//
//  Created by GrepRuby on 12/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface QuestionComment : NSManagedObject

@property (nonatomic, retain) NSNumber * comt_id;
@property (nonatomic, retain) NSNumber * answer_Id;
@property (nonatomic, retain) NSString * comment;

+ (void)entityFromArray:(NSArray *)aArray withAnswerId:(NSNumber *)answer_Id inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary withAnswerId:(NSNumber *)answer_Id  inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary withAnswerId:(NSNumber *)answer_Id  inContext:(NSManagedObjectContext *)localContext;

@end
