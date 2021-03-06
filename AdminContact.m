//
//  AdminContact.m
//  Tonguer
//
//  Created by GrepRuby on 02/07/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "AdminContact.h"


@implementation AdminContact

@dynamic admin_id;
@dynamic admin_email;
@dynamic admin_contact_no;

+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  AdminContact *obj = [AdminContact MR_findFirstByAttribute:@"admin_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [AdminContact MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext adminid:(NSNumber *)adminid {
  for(NSDictionary *aDictionary in aArray) {
    [AdminContact entityFromDictionary:aDictionary inContext:localContext adminid:adminid];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext adminid:(NSNumber *)adminid {
  [AdminContact entityFromDictionary:adictionary inContext:localContext adminid:adminid];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext adminid:(NSNumber *)adminid {
  
  if (![adminid isKindOfClass:[NSNull class]]){
    
    AdminContact *obj = (AdminContact*)[self findOrCreateByID:adminid inContext:localContext];
    
    obj.admin_id = adminid;
    
    if (![[aDictionary objectForKey:@"skype_id"] isKindOfClass:[NSNull class]])
      obj.admin_email = [aDictionary valueForKey:@"skype_id"];
    
    if (![[aDictionary objectForKey:@"contact_no"] isKindOfClass:[NSNull class]])
      obj.admin_contact_no = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"contact_no"] integerValue]];
   
    return obj;
  }
  return nil;
}




@end
