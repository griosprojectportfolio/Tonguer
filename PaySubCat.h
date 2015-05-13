//
//  PaySubCat.h
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PayCls, PayClsCat;

@interface PaySubCat : NSManagedObject

@property (nonatomic, retain) NSNumber * sub_cat_id;
@property (nonatomic, retain) NSString * sub_cat_name;
@property (nonatomic, retain) PayClsCat *payclscat;
@property (nonatomic, retain) NSSet *paycls;
@end

@interface PaySubCat (CoreDataGeneratedAccessors)

- (void)addPayclsObject:(PayCls *)value;
- (void)removePayclsObject:(PayCls *)value;
- (void)addPaycls:(NSSet *)values;
- (void)removePaycls:(NSSet *)values;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;

@end
