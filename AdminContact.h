//
//  AdminContact.h
//  Tonguer
//
//  Created by GrepRuby on 02/07/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AdminContact : NSManagedObject

@property (nonatomic, retain) NSNumber * admin_id;
@property (nonatomic, retain) NSString * admin_email;
@property (nonatomic, retain) NSNumber * admin_contact_no;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;

@end
