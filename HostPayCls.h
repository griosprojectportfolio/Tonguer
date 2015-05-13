//
//  HostPayCls.h
//  Tonguer
//
//  Created by GrepRuby on 08/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface HostPayCls : NSManagedObject

@property (nonatomic, retain) NSNumber * cls_id;
@property (nonatomic, retain) NSString * cls_name;
@property (nonatomic, retain) NSString * cls_img;
@property (nonatomic, retain) NSNumber * cls_days;
@property (nonatomic, retain) NSNumber * cls_price;
@property (nonatomic, retain) NSNumber * cls_score;
@property (nonatomic, retain) NSNumber * cls_progress;
@property (nonatomic, retain) NSString * cls_arrange;
@property (nonatomic, retain) NSString * cls_suitable;
@property (nonatomic, retain) NSString * cls_target;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;

@end
