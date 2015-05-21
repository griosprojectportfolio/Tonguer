//
//  Notes.h
//  Tonguer
//
//  Created by GrepRuby on 19/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Notes : NSManagedObject

@property (nonatomic, retain) NSNumber * notes_id;
@property (nonatomic, retain) NSString * notes_content;
@property (nonatomic, retain) NSDate * notes_date;
@property (nonatomic, retain) NSNumber * notes_cls_id;
@property (nonatomic, retain) NSString * notes_cls_name;
@property (nonatomic, retain) NSNumber * isenable;
@property (nonatomic, retain) NSNumber * notes_like_cont;
@property (nonatomic, retain) NSString * notes_img;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;


@end
