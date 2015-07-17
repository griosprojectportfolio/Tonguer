//
//  BaseViewController.swift
//  Tonguer
//
//  Created by GrepRuby3 on 02/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    let isiPhone5orLower    =   UIScreen.mainScreen().bounds.size.width == 320
    let isiPhone6           =   UIScreen.mainScreen().bounds.size.width == 375
    let isiPhone6plus       =   UIScreen.mainScreen().bounds.size.width == 414
    
  
    var auth_token : [NSString] {
        get {
            var returnValue: [NSString]? = NSUserDefaults.standardUserDefaults().objectForKey("auth-token") as? [NSString]
            if returnValue == nil //Check for first run of app
            {
                returnValue = [""] //Default value
            }
            return returnValue!
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "auth-token")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    var is_Admin : [Bool] {
        get {
            var returnValue: [Bool]? = NSUserDefaults.standardUserDefaults().objectForKey("is_Admin") as? [Bool]
            if returnValue == nil //Check for first run of app
            {
                returnValue = [false] //Default value
            }
            return returnValue!
        }
        set (newValue) {
            NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: "is_Admin")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 52.0/255.0, green: 119.0/255.0, blue: 162.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    }
    
}