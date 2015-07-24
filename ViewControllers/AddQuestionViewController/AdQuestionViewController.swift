//
//  AdQuestionViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class AdQuestionViewController: UIViewController {
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var imgVw :UIImageView!
  var vWLine :  UIView!
  var txtViewAddQues : UITextView!
  var btnSend : UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
   self.defaultUIDesign()
  }
  
  func defaultUIDesign(){
    self.title = "Add Your Question"
   
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var btnforword:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    btnforword.setImage(UIImage(named: "whiteforward.png"), forState: UIControlState.Normal)
    btnforword.addTarget(self, action: "btnforwardTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barforwordBtn = UIBarButtonItem(customView: btnforword)
    
    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)
    
    imgVw = UIImageView(frame: CGRectMake(self.view.frame.origin.x+10,90, 20, 20))
    imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
    self.view.addSubview(imgVw);
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(vWLine)
    
    txtViewAddQues = UITextView(frame: CGRectMake(imgVw.frame.width+vWLine.frame.origin.x-5,imgVw.frame.origin.y, self.view.frame.width-100,250))
    txtViewAddQues.text = "Add Your Question"
    //txtViewAddQues.delegate = self
    txtViewAddQues.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    txtViewAddQues.layer.borderWidth = 1
    txtViewAddQues.layer.borderColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0).CGColor
    self.view.addSubview(txtViewAddQues)
    
    btnSend = UIButton(frame: CGRectMake(txtViewAddQues.frame.origin.x,txtViewAddQues.frame.origin.y+txtViewAddQues.frame.size.height+20, txtViewAddQues.frame.width, 40))
    btnSend.setTitle("Send", forState: UIControlState.Normal)
    btnSend.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0);
    btnSend.tintColor = UIColor.whiteColor()
    self.view.addSubview(self.btnSend)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayID") as! PayViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }

  
}
