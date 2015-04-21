//
//  MyOrderViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class MyOrderViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
  
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  var myordertableview :UITableView!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var btnsVw :UIView!
  var btn1:UIButton!
  var btn2:UIButton!
  var btn3:UIButton!
  
  var HorizVw : UIView!
  var vertiVw :UIView!
  var HorizVw2 : UIView!
  var vertiVw2 :UIView!
  var HorizVw3 : UIView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    self.title = "My Order"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "sideIcon.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "rightswipeGestureRecognizer", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var btnforword:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    btnforword.setImage(UIImage(named: "whiteforward.png"), forState: UIControlState.Normal)
    btnforword.addTarget(self, action: "btnforwardTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barforwordBtn = UIBarButtonItem(customView: btnforword)
    
    self.navigationItem.setRightBarButtonItem(barforwordBtn, animated: true)

    
    btnsVw = UIView(frame: CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+70,self.view.frame.width, 50))
    //btnsVw.backgroundColor = UIColor.greenColor()
    self.view.addSubview(btnsVw)
    
    btn1 = UIButton(frame: CGRectMake(10,5,(self.view.frame.width-40)/2, 40))
    //btn1.backgroundColor = UIColor.grayColor()
    btn1.setTitle("Course list order", forState: UIControlState.Normal)
    btn1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn1.addTarget(self, action: "btn1Tapped", forControlEvents: UIControlEvents.TouchDragInside)
    btnsVw.addSubview(btn1)
    
    HorizVw = UIView(frame: CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y+btn1.frame.size.height , btn1.frame.size.width, 1))
    HorizVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnsVw.addSubview(HorizVw)
   
    vertiVw = UIView(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,1, btn1.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    btnsVw.addSubview(vertiVw)
    
    btn2 = UIButton(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width+10,btn1.frame.origin.y,btn1.frame.width, 40))
    //btn2.backgroundColor = UIColor.grayColor()
    btn2.setTitle("Credit order", forState: UIControlState.Normal)
    btn2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn2.addTarget(self, action: "btn2Tapped", forControlEvents: UIControlEvents.TouchDragInside)
    btnsVw.addSubview(btn2)
    
    HorizVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x,btn2.frame.origin.y+btn2.frame.size.height , btn2.frame.size.width, 1))
    HorizVw2.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnsVw.addSubview(HorizVw2)
    
//    vertiVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x+btn2.frame.size.width,btn2.frame.origin.y,1, btn2.frame.height))
//    vertiVw2.backgroundColor = UIColor.grayColor()
//    btnsVw.addSubview(vertiVw2)
//    
//    btn3 = UIButton(frame: CGRectMake(btn2.frame.origin.x+btn2.frame.size.width+10,btn2.frame.origin.y,btn2.frame.width, 40))
//     //btn3.backgroundColor = UIColor.grayColor()
//    btn3.setTitle("Dolor", forState: UIControlState.Normal)
//    btn3.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
//    btn3.addTarget(self, action: "btn3Tapped", forControlEvents: UIControlEvents.TouchDragInside)
//    btnsVw.addSubview(btn3)
//    
//    HorizVw3 = UIView(frame: CGRectMake(btn3.frame.origin.x,btn3.frame.origin.y+btn3.frame.size.height, btn3.frame.size.width, 1))
//    HorizVw3.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
//    btnsVw.addSubview(HorizVw3)
    
   
  
    myordertableview = UITableView(frame: CGRectMake(btnsVw.frame.origin.x,btnsVw.frame.origin.y+btnsVw.frame.size.height+10,self.view.frame.width,self.view.frame.height-64-btnsVw.frame.height-20))
    myordertableview.backgroundColor = UIColor.grayColor()
    myordertableview.delegate = self
    myordertableview.dataSource = self
    self.view.addSubview(myordertableview)
    
     myordertableview.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")

  }
  
//  func btnBackTapped(){
//    self.navigationController?.popViewControllerAnimated(true)
//  }
  
  func rightswipeGestureRecognizer(){
    
    UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)
    
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("LearnID") as StartLearnViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btn1Tapped(){
    HorizVw.hidden = false
    HorizVw2.hidden = true
   // HorizVw3.hidden = true
  }
  
  func btn2Tapped(){
    HorizVw.hidden = true
    HorizVw2.hidden = false
    //HorizVw3.hidden = true
  }
  
  func btn3Tapped(){
    HorizVw.hidden = true
    HorizVw2.hidden = true
    HorizVw3.hidden = false
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell:UITableViewCell!
    
    cell = myordertableview.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
    
        if(cell == nil){

      var vWcell:UIView! = UIView(frame: CGRectMake(cell.frame.origin.x+10, cell.frame.origin.y+5,cell.frame.size.width-20,100))
      //vWcell.backgroundColor = UIColor.blackColor()
      vWcell.layer.borderWidth = 1
      vWcell.layer.borderColor = UIColor.grayColor().CGColor
      cell.contentView.addSubview(vWcell)
      
      var vWVertical: UIView! = UIView(frame: CGRectMake(vWcell.frame.width-100,0,1,vWcell.frame.height))
      vWVertical.backgroundColor = UIColor.grayColor()
      vWcell.addSubview(vWVertical)
      
      var lblDeatil:UILabel! = UILabel(frame: CGRectMake(5, 2,vWVertical.frame.origin.x-20,60))
      lblDeatil.text = "This is a preliminary document for an API or technology in development. Apple is supplying this."
      lblDeatil.numberOfLines = 0
      lblDeatil.font = lblDeatil.font.fontWithSize(12)
      //lblDeatil.backgroundColor = UIColor.yellowColor()
      lblDeatil.textColor = UIColor.blackColor()
      vWcell.addSubview(lblDeatil)
      
      var lblName: UILabel! = UILabel(frame: CGRectMake(5,vWcell.frame.height-30,150,30))
      lblName.text = "Preliminarydocument"
      lblName.font = lblDeatil.font.fontWithSize(12)
      //lblName.backgroundColor = UIColor.greenColor()
      lblName.textColor = UIColor.grayColor()
      vWcell.addSubview(lblName)
      
      var lblMoney:UILabel! = UILabel(frame: CGRectMake((vWcell.frame.width-80),20,100,40))
      lblMoney.text = "$15.00"
      lblMoney.font = lblMoney.font.fontWithSize(20)
      lblMoney.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
      vWcell.addSubview(lblMoney)
    
    }
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 120
  }
  
}
