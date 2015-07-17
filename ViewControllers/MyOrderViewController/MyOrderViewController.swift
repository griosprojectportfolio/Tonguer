//
//  MyOrderViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class MyOrderViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate{
  
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  
  @IBOutlet var myordertableview :UITableView!
  
  var barBackBtn :UIBarButtonItem!
  var barforwordBtn :UIBarButtonItem!
  var btnsVw :UIView!
  var btn1,btn2:UIButton!
  var api: AppApi!
  var btnTag: NSInteger = 1
  var HorizVw,vertiVw,HorizVw2,vertiVw2,HorizVw3: UIView!
  var arryTrue: NSArray! = NSArray()
  var arryFalse: NSArray! = NSArray()
  var lblNoData:UILabel!
  var imagViewNoData:UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
     setDataNofoundImg()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
     userClassOrdersApiCall()
  }
  
  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if(arryTrue.count == 0){
      if(btnTag == 2){
        showSetDataNofoundImg()
      }
    }else {
      resetShowSetDataNofoundImg()
    }
    if(arryFalse.count == 0){
      if(btnTag == 1){
        showSetDataNofoundImg()
      }
    }else{
      resetShowSetDataNofoundImg()
    }

  }

  
  func defaultUIDesign(){
    
    self.title = "My Order"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "sideIcon.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "rightswipeGestureRecognizer", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    
    btn1 = UIButton(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64,(self.view.frame.width)/2,40))
    //btn1.backgroundColor = UIColor.redColor()
    btn1.userInteractionEnabled = true
    btn1.setTitle("Course list order", forState: UIControlState.Normal)
    btn1.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn1.tag = 1
    btn1.addTarget(self, action: "btn1Tapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btn1)
    self.view.bringSubviewToFront(btn1)
    
    HorizVw = UIView(frame: CGRectMake(btn1.frame.origin.x,btn1.frame.origin.y+btn1.frame.size.height , btn1.frame.size.width, 1))
    HorizVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    self.view.addSubview(HorizVw)
    
    vertiVw = UIView(frame: CGRectMake(btn1.frame.origin.x+btn1.frame.size.width,btn1.frame.origin.y,1, btn1.frame.height))
    vertiVw.backgroundColor = UIColor.grayColor()
    self.view.addSubview(vertiVw)
    
    btn2 = UIButton(frame: CGRectMake(vertiVw.frame.origin.x+1,btn1.frame.origin.y,btn1.frame.width, 40))
    //btn2.backgroundColor = UIColor.greenColor()
    btn2.userInteractionEnabled = true
    btn2.setTitle("Credit order", forState: UIControlState.Normal)
    btn2.tag = 2
    btn2.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btn2.addTarget(self, action: "btn2Tapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btn2)
    self.view.bringSubviewToFront(btn2)
    
    HorizVw2 = UIView(frame: CGRectMake(btn2.frame.origin.x,btn2.frame.origin.y+btn2.frame.size.height , btn2.frame.size.width, 1))
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
    self.view.addSubview(HorizVw2)
    
    myordertableview.frame = CGRectMake(btn1.frame.origin.x,HorizVw2.frame.origin.y+HorizVw2.frame.size.height+10,self.view.frame.width,self.view.frame.height-64-HorizVw2.frame.height-10)
    //myordertableview.backgroundColor = UIColor.grayColor()
    myordertableview.contentInset = UIEdgeInsetsMake(-64,0,0,0)

    myordertableview.separatorStyle = UITableViewCellSeparatorStyle.None
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func rightswipeGestureRecognizer(){
    
    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)
    
  }
  
  
  func btn1Tapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    HorizVw.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw2.backgroundColor = UIColor.lightGrayColor()
    myordertableview.reloadData()
    if(arryFalse.count == 0){
      showSetDataNofoundImg()
    }else{
      resetShowSetDataNofoundImg()
    }

  }
  
  func btn2Tapped(sender:AnyObject){
    var btn = sender as UIButton
    btnTag = btn.tag
    HorizVw2.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    HorizVw.backgroundColor = UIColor.lightGrayColor()
     myordertableview.reloadData()
    if(arryTrue.count == 0){
      showSetDataNofoundImg()
    }else{
      resetShowSetDataNofoundImg()
    }
    
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    var count: NSInteger!
    if(btnTag == 1){
      count = arryFalse.count
    }else if(btnTag == 2){
      count = arryTrue.count
    }
    return count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    var cell:UITableViewCell!
    
    if(btnTag == 1){
      var cell:CourseOrderTableViewCell!
      cell = myordertableview.dequeueReusableCellWithIdentifier("courseCell") as CourseOrderTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      if(arryFalse.count == 0){
        
      }else{
        cell.defaultCellContents(arryFalse.objectAtIndex(indexPath.row) as UserClassOrder, frame: self.view.frame)
        cell.btnNotPay.tag = indexPath.row
        cell.btnNotPay.addTarget(self, action:"btnNotPayTapped:", forControlEvents:UIControlEvents.TouchUpInside)
      }
      return cell
      }else if(btnTag == 2){
      var cell:CreditTableViewCell!
      cell = myordertableview.dequeueReusableCellWithIdentifier("creditCell") as CreditTableViewCell
      cell.selectionStyle = UITableViewCellSelectionStyle.None
      if(arryTrue.count == 0){
        
      }else{
      cell.defaultCellContents(arryTrue.objectAtIndex(indexPath.row) as UserClassOrder, frame: self.view.frame)
      }
      return cell
    }
    
    return cell
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    var height:CGFloat = 100
    if(btnTag == 2){
      if(arryTrue.count > 0){
      var obj =  arryTrue.objectAtIndex(indexPath.row) as UserClassOrder
      var strMessage = obj.cls_name
      var rect: CGRect! = strMessage.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
        height = height+rect.height
      }
    }else if(btnTag == 1){
      if(arryFalse.count > 0){
        var obj =  arryFalse.objectAtIndex(indexPath.row) as UserClassOrder
        var strMessage = obj.cls_name
        var rect: CGRect! = strMessage.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(12)], context: nil)
        height = height+rect.height
      }

    }
    
    return height
  }

  //**************** User Classes Orders Api Call **************
  
  func userClassOrdersApiCall(){
    var aParam: NSDictionary = NSDictionary(objects: [auth_token[0]], forKeys: ["auth-token"])
    
    self.api.userClassOrders(aParam, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.dataFetchFromDatabase(responseObject as NSDictionary)
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
    })
    
  }

  func dataFetchFromDatabase(dicrOrders:NSDictionary){
    arryTrue = dicrOrders.objectForKey("True") as NSArray
    arryFalse = dicrOrders.objectForKey("False") as NSArray
    
    if(arryTrue.count > 0 || arryFalse.count > 0){
      myordertableview.reloadData()
    }
    
  }
  
  func btnNotPayTapped(sender:UIButton){
    var btn = sender as UIButton
    var obj = arryFalse.objectAtIndex(btn.tag) as UserClassOrder
    var dictCls:NSMutableDictionary = NSMutableDictionary()
    if((obj.cls_id) != nil){
      dictCls.setValue(obj.cls_id, forKey:"id")
    }else{
      dictCls.setValue(0, forKey:"id")
    }
    if((obj.cls_name) != nil){
      dictCls.setValue(obj.cls_name, forKey:"name")
    }else{
       dictCls.setValue("", forKey:"name")
    }
    if((obj.cls_amount) != nil){
      dictCls.setValue(obj.cls_amount, forKey:"price")
    }else{
      dictCls.setValue(0.0, forKey:"price")
    }
    if((obj.cls_image) != nil){
      dictCls.setValue(obj.cls_image, forKey:"image")
    }else{
      dictCls.setValue("http://www.popular.com.my/images/no_image.gif", forKey:"image")
    }
    if((obj.cls_days) != nil){
      dictCls.setValue(obj.cls_days, forKey:"valid_days")
    }else{
      dictCls.setValue(0, forKey:"valid_days")
    }
    
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OrderConfID") as OrderConfViewController
    vc.clsDict = dictCls
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  
  func setDataNofoundImg(){
    lblNoData = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+120,self.view.frame.width-40, 30))
    lblNoData.text = "Sorry no data found."
    lblNoData.textAlignment = NSTextAlignment.Center
    lblNoData.hidden = true
    self.view.addSubview(lblNoData)
    self.view.bringSubviewToFront(lblNoData)
    imagViewNoData = UIImageView(frame: CGRectMake((self.view.frame.width-100)/2,(self.view.frame.height-100)/2,100,100))
    imagViewNoData.image = UIImage(named:"smile")
    imagViewNoData.hidden = true
    self.view.addSubview(imagViewNoData)
    self.view.bringSubviewToFront(imagViewNoData)
  }
  
  func showSetDataNofoundImg(){
    lblNoData.hidden = false
    imagViewNoData.hidden = false
  }
  
  func resetShowSetDataNofoundImg(){
    lblNoData.hidden = true
    imagViewNoData.hidden = true
  }
  
  
}
