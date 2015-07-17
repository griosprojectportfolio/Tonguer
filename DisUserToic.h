//
//  DisUserToic.h
//  Tonguer
//
//  Created by GrepRuby on 09/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DisUserToic : NSManagedObject

@property (nonatomic, retain) NSNumber * topic_id;
@property (nonatomic, retain) NSNumber * class_id;
@property (nonatomic, retain) NSString * topic_name;
@property (nonatomic, retain) NSString * topic_content;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext class_id:(NSNumber*)class_id;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext class_id:(NSNumber*)class_id;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext class_id:(NSNumber*)class_id;


@end
