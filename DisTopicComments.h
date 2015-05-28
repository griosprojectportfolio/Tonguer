//
//  DisTopicComments.h
//  Tonguer
//
//  Created by GrepRuby on 11/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DisTopicComments : NSManagedObject

@property (nonatomic, retain) NSNumber * comment_id;
@property (nonatomic, retain) NSString * commment;
@property (nonatomic, retain) NSNumber * topic_Id;
@property (nonatomic, retain) NSString * name;

+ (void)entityFromArray:(NSArray *)aArray withTopicId:(NSNumber *)topicId inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary withTopicId:(NSNumber *)topicId  inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary withTopicId:(NSNumber *)topicId  inContext:(NSManagedObjectContext *)localContext;

@end
