//
//  UserClassOrder.h
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserClassOrder : NSManagedObject

@property (nonatomic, retain) NSNumber * order_id;
@property (nonatomic, retain) NSNumber * cls_id;
@property (nonatomic, retain) NSString * cls_name;
@property (nonatomic, retain) NSNumber * is_buy;
@property (nonatomic, retain) NSString * date;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;

@end
