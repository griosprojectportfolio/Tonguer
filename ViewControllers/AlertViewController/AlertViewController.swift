//
//  AlertViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 14/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController {
  
  var barBackBtn :UIBarButtonItem!
  var barRigthBtn :UIBarButtonItem!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
    
  }
  
  func defaultUIDesign(){
    self.title = "Notification"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var rightbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    rightbtn.setImage(UIImage(named: "deleteicon.png"), forState: UIControlState.Normal)
    //rightbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barRigthBtn = UIBarButtonItem(customView: rightbtn)
    self.navigationItem.setRightBarButtonItem(barRigthBtn, animated: true)


  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
    
}
