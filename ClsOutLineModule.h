//
//  ClsOutLineModule.h
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ClsOutLineModule : NSManagedObject

@property (nonatomic, retain) NSNumber * mod_id;
@property (nonatomic, retain) NSString * mod_content;
@property (nonatomic, retain) NSNumber * cls_id;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;


@end
