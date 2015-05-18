//
//  ShareViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 14/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class ShareViewController: BaseViewController {
  
   var barBackBtn :UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()

       self.defaultUIDesign()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func defaultUIDesign(){
    
    self.title = "Share"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
  }
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
   
}
