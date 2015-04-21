//
//  AnswersViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit
import Foundation

class AnswersViewController: UIViewController{
  
  var barBackBtn :UIBarButtonItem!
  var txtViewQues :UITextView!
  var imgVw :UIImageView!
  var vWLine :  UIView!
  var ansTableview:UITableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  func defaultUIDesign(){
    
    self.title = "Answers"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    imgVw = UIImageView(frame: CGRectMake(self.view.frame.origin.x+10,90, 20, 20))
    imgVw.backgroundColor = UIColor.grayColor()
    imgVw.image = UIImage(named: "Q.png")
    self.view.addSubview(imgVw);
    
    vWLine = UIView(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10, imgVw.frame.origin.y, 1, imgVw.frame.height))
    vWLine.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(vWLine)
    
    txtViewQues = UITextView(frame: CGRectMake(imgVw.frame.size.width+vWLine.frame.size.width+30,80, self.view.frame.size.width-80,(self.view.frame.height-250)/2))
    txtViewQues.text = "This is a preliminary document for an API or technology in development. Apple is supplying this information to help you plan for the adoption of the technologies and programming interfaces described herein for use on Apple-branded products. This information is subject to change, and software implemented according to this document should be tested with final operating system software and final documentation. Newer versions of this document may be."
    //txtViewQues.backgroundColor = UIColor.grayColor()
    txtViewQues.textColor = UIColor.grayColor()
    txtViewQues.allowsEditingTextAttributes = false
    self.view.addSubview(txtViewQues)
    
    ansTableview = UITableView(frame: CGRectMake(self.view.frame.origin.x+20, txtViewQues.frame.height+100,self.view.frame.width-40,(self.view.frame.height-50)/2))
    // ansTableview.delegate = self
    //ansTableview.dataSource = self
    ansTableview.scrollEnabled = true
    self.view.addSubview(ansTableview)
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  /*
  // MARK: - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */
  
}
