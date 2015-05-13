//
//  Addvertiesment.h
//  Tonguer
//
//  Created by GrepRuby on 08/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Addvertiesment : NSManagedObject

@property (nonatomic, retain) NSNumber * add_id;
@property (nonatomic, retain) NSString * add_name;
@property (nonatomic, retain) NSString * add_img;
@property (nonatomic, retain) NSString * add_video;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;


@end
