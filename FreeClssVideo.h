//
//  FreeClssVideo.h
//  Tonguer
//
//  Created by GrepRuby on 01/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FreeClssVideo : NSManagedObject

@property (nonatomic, retain) NSNumber * video_id;
@property (nonatomic, retain) NSString * video_img_url;
@property (nonatomic, retain) NSString * video_url;
@property (nonatomic, retain) NSString * video_name;

+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext*)localContext;
+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext;
+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext;


@end
