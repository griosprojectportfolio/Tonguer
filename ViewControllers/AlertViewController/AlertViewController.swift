
//
//  AlertViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 14/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AlertViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var barRigthBtn :UIBarButtonItem!
  var tblNotification: UITableView!
  let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
  var arryNotification: NSMutableArray! = NSMutableArray()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.defaultUIDesign()
  }
  
  func defaultUIDesign(){
    
    print(arryNotification.count)
    
    self.title = "Notification"
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
        
    tblNotification = UITableView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width,self.view.frame.size.height))
    tblNotification.delegate = self
    tblNotification.dataSource = self
    tblNotification.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    self.view.addSubview(tblNotification)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func btnBackTapped(){
    
     var arryVwController:NSArray = self.navigationController?.viewControllers as! AnyObject as! NSArray
    print(arryVwController)
  
    if arryVwController.objectAtIndex(1).isKindOfClass(AlertViewController){
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("HomeID") as! HomeViewController
      self.navigationController?.pushViewController(vc, animated:false)
      return;
    }else if arryVwController.objectAtIndex(1).isKindOfClass(HomeViewController){
       self.navigationController?.popViewControllerAnimated(true)
    }

  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    var dict = arryNotification.objectAtIndex(indexPath.row) as! NSDictionary
    var dictAlert = dict.valueForKey("aps") as! NSDictionary
    var strNotification = dictAlert.valueForKey("alert") as! NSString
    
    var rect: CGRect! = strNotification.boundingRectWithSize(CGSize(width:self.view.frame.size.width-60,height:300), options:NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(18)], context: nil)
    return (rect.height+40)
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arryNotification.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    if(arryNotification.count > 0){
      var dict = arryNotification.objectAtIndex(indexPath.row)as! NSDictionary
      var dictAlert = dict.valueForKey("aps") as! NSDictionary
      cell.textLabel!.text = dictAlert.valueForKey("alert") as? String
      cell.textLabel!.font = cell.textLabel!.font.fontWithSize(15)
      cell.textLabel!.textColor = UIColor.darkGrayColor()
      cell.textLabel!.numberOfLines = 0
    }else{
      cell.textLabel!.text = ""
      
      
    }
    //cell.backgroundColor = UIColor.redColor()
    return cell
  }
  
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    
    if(editingStyle == UITableViewCellEditingStyle.Delete){
      arryNotification.removeObjectAtIndex(indexPath.row)
      tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation:UITableViewRowAnimation.Fade)
    }
    
  }
    
}
