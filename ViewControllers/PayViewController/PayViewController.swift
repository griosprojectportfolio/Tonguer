//
//  PayViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 06/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class PayViewController: UIViewController {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  
  var lblText : UILabel!
  var lblmoney : UILabel!
  var btnpaypal : UIButton!
  var btnmakesure : UIButton!
  var strMoney: NSString! = "0"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func defaultUIDesign(){
    self.title = "Select the way to pay"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
//    var btnforword:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
//    btnforword.setImage(UIImage(named: "whiteforward.png"), forState: UIControlState.Normal)
//    btnforword.addTarget(self, action: "btnforwardTapped", forControlEvents: UIControlEvents.TouchUpInside)
//    
//    barforwordBtn = UIBarButtonItem(customView: btnforword)
//    
//    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)
    
    lblText = UILabel(frame: CGRectMake(self.view.frame.origin.x+30, self.view.frame.origin.y+84, 150, 30))
    lblText.text = "You Need to Pay"
    lblText.font = lblText.font.fontWithSize(15)
    lblText.textColor = UIColor.grayColor()
    self.view.addSubview(lblText)
    
    lblmoney = UILabel(frame: CGRectMake(lblText.frame.origin.x,lblText.frame.origin.y+lblText.frame.size.height, 50, 50))
    lblmoney.text = "$"+strMoney
    lblmoney.font = lblmoney.font.fontWithSize(30)
    lblmoney.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    self.view.addSubview(lblmoney)
    
    btnpaypal = UIButton(frame: CGRectMake(self.view.frame.origin.x+20,lblmoney.frame.origin.y+lblmoney.frame.size.height , self.view.frame.width-40, 60))
    btnpaypal.setTitle("Paypal For charge", forState: UIControlState.Normal)
    btnpaypal.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnpaypal.layer.borderWidth = 1
    btnpaypal.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.view.addSubview(btnpaypal)
    
    btnmakesure = UIButton(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.height-50, self.view.frame.width-40, 40))
    btnmakesure.setTitle("Free Open Try class", forState: UIControlState.Normal)
    btnmakesure.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnmakesure.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    
    self.view.addSubview(btnmakesure)
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OrderConfID") as OrderConfViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
}
