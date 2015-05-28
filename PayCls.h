//
//  PayCls.h
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PayCls : NSManagedObject

@property (nonatomic, retain) NSNumber * cls_id;
@property (nonatomic, retain) NSNumber * cls_subcategory_Id;
@property (nonatomic, retain) NSString * cls_name;
@property (nonatomic, retain) NSString * cls_img_url;
@property (nonatomic, retain) NSNumber * cls_days;
@property (nonatomic, retain) NSNumber * cls_price;
@property (nonatomic, retain) NSString * cls_arrange;
@property (nonatomic, retain) NSString * cls_suitable;
@property (nonatomic, retain) NSString * cls_target;
@property (nonatomic, retain) NSNumber * cls_score;
@property (nonatomic, retain) NSNumber * cls_progress;

@property (nonatomic, retain) NSManagedObject *paysubcat;

+ (void)entityFromArray:(NSArray *)aArray withSubcategoryId:(NSNumber *)categoryId inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary withSubcategoryId:(NSNumber *)categoryId inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary withSubcategoryId:(NSNumber *)categoryId inContext:(NSManagedObjectContext *)localContext;

@end
