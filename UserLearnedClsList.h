//
//  UserLearnedClsList.h
//  Tonguer
//
//  Created by GrepRuby on 07/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserLearnedClsList : NSManagedObject

@property (nonatomic, retain) NSString * cls_img_url;
@property (nonatomic, retain) NSString * cls_name;
@property (nonatomic, retain) NSNumber * cls_price;
@property (nonatomic, retain) NSNumber * cls_progress;
@property (nonatomic, retain) NSNumber * cls_id;
@property (nonatomic, retain) NSNumber * cls_score;
@property (nonatomic, retain) NSNumber * cls_vaild_days;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;


@end
