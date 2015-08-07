//
//  AppDelegate.swift
//  Tonguer
//
//  Created by GrepRuby3 on 02/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  var objSideBar:SideBarView!
  var deviceTokenString:NSString!
  var arryNotification:NSMutableArray = NSMutableArray()
  var dictUserInfo:NSDictionary!
  var temp : NSDictionary!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

      var frame1:CGRect = UIScreen.mainScreen().bounds
      var frame2:CGRect = CGRectMake(-frame1.width, frame1.origin.y, frame1.width, frame1.height)
       objSideBar = SideBarView(frame: frame2)
      self.window?.makeKeyAndVisible()
      self.window?.addSubview(objSideBar)
      self.window?.bringSubviewToFront(objSideBar)

    PayPalMobile.initializeWithClientIdsForEnvironments([PayPalEnvironmentSandbox:"AXR3L7aTpquYVo0y_CRbqRRnmcCmGpN_kKbCfqje4HcIwHUnm1CP-isSN6729iUaRrizAWuhfST6KHJa"])
      // [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentProduction : @"YOUR_CLIENT_ID_FOR_PRODUCTION",

      MagicalRecord.setupCoreDataStack()
      
      // Set up Fabric
      Fabric.with([Crashlytics()])

      // For Push Notification
      var types: UIUserNotificationType = UIUserNotificationType.Badge | UIUserNotificationType.Alert | UIUserNotificationType.Sound
      var settings: UIUserNotificationSettings = UIUserNotificationSettings( forTypes: types, categories: nil )
      application.registerUserNotificationSettings(settings)
      application.registerForRemoteNotifications()
      UIApplication.sharedApplication().applicationIconBadgeNumber = 0
      return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.Tonguer.Apps.Tonguer" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = NSBundle.mainBundle().URLForResource("Tonguer", withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Tonguer.sqlite")
        var error: NSError? = nil
        var failureReason = "There was an error creating or loading the application's saved data."
        if coordinator!.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: nil, error: &error) == nil {
            coordinator = nil
            // Report any error we got.
            let dict = NSMutableDictionary()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data"
            dict[NSLocalizedFailureReasonErrorKey] = failureReason
            dict[NSUnderlyingErrorKey] = error
            error = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict as [NSObject : AnyObject])
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(error), \(error!.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if let moc = self.managedObjectContext {
            var error: NSError? = nil
            if moc.hasChanges && !moc.save(&error) {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error!.userInfo)")
                abort()
            }
        }
    }
  
  
     // Push Notification Methods
  
    func application( application: UIApplication!, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData! ) {
    
      var characterSet: NSCharacterSet = NSCharacterSet( charactersInString: "<>" )
    
       deviceTokenString = ( deviceToken.description as NSString ).stringByTrimmingCharactersInSet( characterSet ).stringByReplacingOccurrencesOfString( " ", withString: "" ) as String
    
    }
  
    func application( application: UIApplication!, didFailToRegisterForRemoteNotificationsWithError error: NSError! ) {
    
      println( error.localizedDescription )
    }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    
    println("Recived: \(userInfo)")
    //Parsing userinfo:
    temp  = userInfo
    if let info = userInfo["aps"] as? NSDictionary
    {
      var mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
      let nvc = mainstoryboard.instantiateViewControllerWithIdentifier("AlertID") as! AlertViewController
      nvc.arryNotification.addObject(temp)
      self.window?.rootViewController?.presentViewController(nvc, animated: true, completion:nil)
    }
  }

}


/*

grepruby0-facilitator@gmail.com
Endpoint:
api.sandbox.paypal.com
Client ID:
AeXH1pDAunezMi2uSCm_nav3jV8QnUhly1GB0IlqxtUlgQBiTCRDEgt0Dq_TXLkCjlAoIabdE_N3Wc_R
Secret: EIJn9d2fJ5Rc71Zg1MDmINlszHccet8pG9EcRammFGemm2BJXYMzQTY3fjWR9BHm5V7AEHOAymv8KeIq

//credential

Main Sendbox account

//https://developer.paypal.com/developer

grepruby0@gmail.com
grepruby@123

At Merchant test side
grepruby0-facilitator@gmail.com
grepruby@123


At buyer test side
grepruby0-buyer@gmail.com
grepruby@123

*/
