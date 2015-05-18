//
//  Answer.h
//  Tonguer
//
//  Created by GrepRuby on 15/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Answer : NSManagedObject

@property (nonatomic, retain) NSNumber * ans_id;
@property (nonatomic, retain) NSString * answer;
@property (nonatomic, retain) NSNumber * ques_id;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;

@end
