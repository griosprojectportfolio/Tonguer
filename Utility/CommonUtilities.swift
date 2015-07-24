//
//  CommonUtilities.swift
//  Rondogo
//
//  Created by GrepRuby3 on 20/03/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation

class CommonUtilities: NSObject {
    
//    class func isValidEmail(testStr:String) -> Bool {
//        println("validate calendar: \(testStr)")
//      var emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}" as String
//      
//        if let emailTest = NSPredicate(format:"SELF MATCHES %@",emailRegEx) {
//            return emailTest.evaluateWithObject(testStr)
//        }
//        return false
//    }
  
  class func checkNetconnection() ->Bool {
    
  let reachability: Reachability = Reachability.reachabilityForInternetConnection()
  let networkStatus = reachability.currentReachabilityStatus().value
    
  return networkStatus != 0
  
  }


  class func sharedDelegate ()-> AppDelegate! {
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  return appDelegate

  }
  
  class func addUserInformation(var aParam:NSDictionary) {
    var userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var data:NSData = NSKeyedArchiver.archivedDataWithRootObject(aParam);
    userDefault.setObject(data, forKey: "user")
    NSUserDefaults.standardUserDefaults().synchronize()
  }
  class func removeUserInformation() {
    NSUserDefaults.standardUserDefaults().removeObjectForKey("user")
  }
}
