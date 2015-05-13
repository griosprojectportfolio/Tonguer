//
//  PayClsCat.h
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface PayClsCat : NSManagedObject

@property (nonatomic, retain) NSNumber * cat_id;
@property (nonatomic, retain) NSString * cat_name;
@property (nonatomic, retain) NSSet *paysubcat;
@end

@interface PayClsCat (CoreDataGeneratedAccessors)

- (void)addPaysubcatObject:(NSManagedObject *)value;
- (void)removePaysubcatObject:(NSManagedObject *)value;
- (void)addPaysubcat:(NSSet *)values;
- (void)removePaysubcat:(NSSet *)values;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;


@end
