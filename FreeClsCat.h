//
//  FreeClsCat.h
//  Tonguer
//
//  Created by GrepRuby on 24/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FreeClsCat : NSManagedObject

@property (nonatomic, retain) NSNumber * cat_id;
@property (nonatomic, retain) NSString * cat_name;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;

@end
