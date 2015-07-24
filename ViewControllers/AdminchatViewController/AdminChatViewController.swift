//
//  AdminChatViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 07/07/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AdminChatViewController:BaseViewController {
  
  var barBackBtn :UIBarButtonItem!
  var api: AppApi!
  var lblDetails: UILabel!
  var lblskypeid: UILabel!
  var btnskype: UIButton!
  var txtViewID: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
      defaultUIDesign()
      dataFetchAdminContact()
    }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    adminContactApi()
  }
  
  func defaultUIDesign(){
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    api = AppApi.sharedClient()
   
    lblDetails = UILabel(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.origin.y+84,self.view.frame.size.width-40,30))
    lblDetails.text = "Hey! if you want to chat with admin please use below id in red mark and you have first need to send request then you will be able to connect with admin."
    lblDetails.textColor = UIColor.grayColor()
    lblDetails.numberOfLines = 0
    lblDetails.sizeToFit()
    lblDetails.lineBreakMode = NSLineBreakMode.ByWordWrapping
    self.view.addSubview(lblDetails)
    
    txtViewID = UITextView(frame: CGRectMake(lblDetails.frame.origin.x+(lblDetails.frame.width-250)/2,lblDetails.frame.origin.y+lblDetails.frame.height+20,250,40))
    txtViewID.editable = false
     self.view.addSubview(txtViewID)
    
    btnskype = UIButton(frame: CGRectMake(self.view.frame.origin.x+20,txtViewID.frame.origin.y+txtViewID.frame.height+20,self.view.frame.width-40,40))
    btnskype.setTitle("Connect on skype", forState: UIControlState.Normal)
    btnskype.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    btnskype.addTarget(self, action:"btnskyfunction", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnskype)
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  func btnskyfunction(){
   var installed = UIApplication.sharedApplication().canOpenURL(NSURL(string: "skype:")!)
   if(installed){
     UIApplication.sharedApplication().openURL(NSURL(string: "skype:echo123?call")!)
    }else{
      UIApplication.sharedApplication().openURL(NSURL(string: "http://itunes.com/apps/skype/skype")!)
    }
  }
  
  
  func adminContactApi(){
    
    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])
    
    self.api.getAdminContact(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.dataFetchAdminContact()
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
  }
  
  func dataFetchAdminContact(){
    var arry = AdminContact .MR_findAll() as NSArray
    if(arry.count>0){
      var obj = arry.objectAtIndex(0) as! AdminContact
      var skypeid = obj.admin_email
      txtViewID.text = skypeid
      txtViewID.font = UIFont(name: txtViewID.font.fontName, size: 18)
      txtViewID.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
      txtViewID.sizeToFit()
    
    }
    
  }

  
    
  
}
