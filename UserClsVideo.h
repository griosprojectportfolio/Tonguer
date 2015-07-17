//
//  UserClsVideo.h
//  Tonguer
//
//  Created by GrepRuby on 08/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface UserClsVideo : NSManagedObject

@property (nonatomic, retain) NSNumber * vdo_id;
@property (nonatomic, retain) NSNumber * cls_id;
@property (nonatomic, retain) NSString * vdo_name;
@property (nonatomic, retain) NSString * vdo_img;
@property (nonatomic, retain) NSString * vdo_url;
@property (nonatomic, retain) NSNumber * finished_video;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;


@end
