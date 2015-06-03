//
//  FreeSubCat.h
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FreeCls, FreeClsCat;

@interface FreeSubCat : NSManagedObject

@property (nonatomic, retain) NSNumber * sub_cat_id;
@property (nonatomic, retain) NSNumber * cat_id;
@property (nonatomic, retain) NSString * sub_cat_name;
@property (nonatomic, retain) FreeClsCat *freeclscat;
@property (nonatomic, retain) NSSet *freecls;
@end

@interface FreeSubCat (CoreDataGeneratedAccessors)

- (void)addFreeclsObject:(FreeCls *)value;
- (void)removeFreeclsObject:(FreeCls *)value;
- (void)addFreecls:(NSSet *)values;
- (void)removeFreecls:(NSSet *)values;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext catID:(NSNumber*)cat_id;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext catID:(NSNumber*)cat_id;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext catID:(NSNumber*)cat_id;

@end
