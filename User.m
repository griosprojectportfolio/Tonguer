//
//  User.m
//  Tonguer
//
//  Created by GrepRuby on 07/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "User.h"


@implementation User

@dynamic email;
@dynamic fname;
@dynamic lname;
@dynamic money;
@dynamic pro_img;
@dynamic score;
@dynamic user_id;
@dynamic device_token;
@dynamic batch_count;


+ (id)findOrCreateByID:(id)anID inContext:(NSManagedObjectContext*)localContext {
  
  User *obj = [User MR_findFirstByAttribute:@"user_id" withValue:anID inContext:localContext];
  
  if (!obj) {
    obj = [User MR_createInContext:localContext];
  }
  return obj;
}


+ (void)entityFromArray:(NSArray *)aArray inContext:(NSManagedObjectContext *)localContext {
  for(NSDictionary *aDictionary in aArray) {
    [User entityFromDictionary:aDictionary inContext:localContext];
  }
}

+ (void)entityWithDictionaty:(NSDictionary *)adictionary inContext:(NSManagedObjectContext *)localContext {
  [User entityFromDictionary:adictionary inContext:localContext];
}

+ (id)entityFromDictionary:(NSDictionary *)aDictionary inContext:(NSManagedObjectContext *)localContext {
  
  if (![[aDictionary objectForKey:@"id"] isKindOfClass:[NSNull class]]){
    
    User *obj = (User*)[self findOrCreateByID:[aDictionary objectForKey:@"id"] inContext:localContext];
    
    
    obj.user_id = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"id"] integerValue]];
    
    if (![[aDictionary objectForKey:@"money"] isKindOfClass:[NSNull class]])
      obj.money = [NSNumber numberWithInteger:[[aDictionary objectForKey:@"money"] integerValue]];
    
    if (![[aDictionary objectForKey:@"email"] isKindOfClass:[NSNull class]])
      obj.email = [aDictionary valueForKey:@"email"] ;
    
    if (![[aDictionary objectForKey:@"first_name"] isKindOfClass:[NSNull class]])
      obj.fname = [aDictionary objectForKey:@"first_name"];
    
    if (![[aDictionary objectForKey:@"last_name"] isKindOfClass:[NSNull class]])
      obj.lname = [aDictionary valueForKey:@"last_name"];
    
    if (![[aDictionary objectForKey:@"score"] isKindOfClass:[NSNull class]])
      obj.score =[NSNumber numberWithInteger:[[aDictionary objectForKey:@"score"] integerValue]];
    
    if (![[[aDictionary objectForKey:@"image"]valueForKey:@"url"] isKindOfClass:[NSNull class]]){
//      NSString *strImgBaseUrl = @"https://pro-tonguer.s3.amazonaws.com";
//      NSString *imgUrl = [strImgBaseUrl stringByAppendingString:[[aDictionary valueForKey:@"image"]valueForKey:@"url"]];
      obj.pro_img =[[aDictionary valueForKey:@"image"]valueForKey:@"url"];
    }
    
    
    if (![[aDictionary objectForKey:@"device_token"] isKindOfClass:[NSNull class]])
      obj.device_token =[aDictionary valueForKey:@"device_token"];
    
    if (![[aDictionary objectForKey:@"batch_count"] isKindOfClass:[NSNull class]])
      obj.batch_count =[aDictionary valueForKey:@"batch_count"];
    
    return obj;
  }
  return nil;
}


  //MARK : Function to delete table
+ (void)deleteAllEntityObjects {
  [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
    NSArray *arrEntities = [[NSArray alloc] initWithObjects:@"User", @"UserClsVideo",@"UserDefaultClsList", @"UserLearnClsList", @"UserLearnedClsList",@"Questions",@"QuestionComment",@"Answer",@"Notes",@"UserNotes",@"DisAdminTopic", @"FreeCls",nil];
    for (int i=0; i < arrEntities.count; i++) {

      NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
      NSEntityDescription *entity = [NSEntityDescription entityForName:[arrEntities objectAtIndex:i] inManagedObjectContext:localContext];
      [fetchRequest setEntity:entity];
      NSError *error;
      NSArray *items = [localContext executeFetchRequest:fetchRequest error:&error];
      for (NSManagedObject *managedObject in items) {
        [localContext deleteObject:managedObject];
      }
      if (![localContext save:&error]) {

      }
    }
  }];
}

@end
