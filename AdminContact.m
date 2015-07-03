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


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [AdminContact entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [AdminContact entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    AdminContact *obj = (AdminContact*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    obj.admin_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"email"] isKindOfClass:[NSNull class]])
      obj.admin_email = [aDictionary valueForKey:@"email"];
    
    if (![[aDictionary objectForKey:@"contactNo"] isKindOfClass:[NSNull class]])
      obj.admin_contact_no = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"contactNo"] integerValue]];
   
    return obj;
  }
  return nil;
}




@end
