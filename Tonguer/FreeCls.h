//
//  FreeCls.h
//  Tonguer
//
//  Created by GrepRuby on 27/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FreeSubCat;

@interface FreeCls : NSManagedObject

@property (nonatomic, retain) NSDate * cls_date;
@property (nonatomic, retain) NSNumber * cls_id;
@property (nonatomic, retain) NSString * cls_name;
@property (nonatomic, retain) NSString * img_url;
@property (nonatomic, retain) FreeSubCat *freesubcat;

@end
