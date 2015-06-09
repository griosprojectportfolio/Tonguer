//
//  VideoDone.h
//  Tonguer
//
//  Created by GrepRuby on 06/06/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface VideoDone : NSManagedObject

@property (nonatomic, retain) NSNumber * video_id;
@property (nonatomic, retain) NSNumber * video_cls_id;
@property (nonatomic, retain) NSNumber * video_is;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;

@end
