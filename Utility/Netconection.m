//
//  Netconection.m
//  Tonguer
//
//  Created by GrepRuby on 22/06/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

#import "Netconection.h"

@implementation Netconection

+(BOOL)checkNetconection{
  
  Reachability *reachability = [Reachability reachabilityForInternetConnection];
  NSInteger networkStatus = [reachability currentReachabilityStatus];
  return networkStatus != 0;
  
}

@end
