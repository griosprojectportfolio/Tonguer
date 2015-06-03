//
//  Aboutus.h
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Aboutus : NSManagedObject

@property (nonatomic, retain) NSNumber * ab_id;
@property (nonatomic, retain) NSString * ab_content;
@property (nonatomic, retain) NSString * ab_videourl;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext about_id:(NSNumber*)ab_id;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext about_id:(NSNumber*)ab_id;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext about_id:(NSNumber*)ab_id;

@end
