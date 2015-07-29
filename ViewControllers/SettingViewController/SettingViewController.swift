//
//  SettingViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 15/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
@IBOutlet  var tableview: UITableView!
  var VwUserDetail: UIView!
  var imgVwPPic: UIImageView!
  var lblname: UILabel!
  var btnLogout: UIButton!
  
  var userDict,dictParam: NSDictionary!

  var api: AppApi!
  var arrSettData: NSArray!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    userDict = NSDictionary(objects: ["img2","Test User"], forKeys: ["image","name"])
    
    arrSettData = NSArray(objects:"Alreday downloaded","Download reminder","Feedback","Recommand to friend","About us")
    
    self.defaultUIDesign()
    
  }
  
  func defaultUIDesign(){
    
    self.title = "Setting"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)


    
    VwUserDetail = UIView(frame: CGRectMake(self.view.frame.origin.x+20, self.view.frame.origin.y+74, self.view.frame.width-50, 60))
    VwUserDetail.layer.borderWidth = 0.5
    VwUserDetail.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.view.addSubview(VwUserDetail)
    
    imgVwPPic = UIImageView(frame: CGRectMake(5,5,50,50))
    //imgVwPPic.image = UIImage(named: userDict.objectForKey("image")as NSString)
    VwUserDetail.addSubview(imgVwPPic)
    
    lblname = UILabel(frame: CGRectMake(imgVwPPic.frame.origin.x+10 + imgVwPPic.frame.width+2,10,VwUserDetail.frame.width-120,40))
    //lblname.backgroundColor = UIColor.grayColor()
    lblname.text = ""
    lblname.font = lblname.font.fontWithSize(15)
    VwUserDetail.addSubview(lblname)
    
    btnLogout = UIButton(frame: CGRectMake(lblname.frame.origin.x+lblname.frame.width+1, 0,VwUserDetail.frame.width-(lblname.frame.origin.x+lblname.frame.width),VwUserDetail.frame.height))
    btnLogout.setTitle("Logout", forState: UIControlState.Normal)
    btnLogout.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
    btnLogout.titleLabel?.font = btnLogout.titleLabel?.font.fontWithSize(12)
    btnLogout.layer.borderWidth = 1
    btnLogout.layer.borderColor = UIColor.lightGrayColor().CGColor
    btnLogout.addTarget(self, action:"btnLogoutTapped", forControlEvents: UIControlEvents.TouchUpInside)
    //btnLogout.backgroundColor = UIColor.blackColor()
    VwUserDetail.addSubview(btnLogout)
    
    tableview.frame =  CGRectMake(self.view.frame.origin.x,VwUserDetail.frame.origin.y+VwUserDetail.frame.height, self.view.frame.width, self.view.frame.height - (VwUserDetail.frame.origin.y+VwUserDetail.frame.height+10))
   // tableview.backgroundColor = UIColor.grayColor()
    tableview.delegate = self
    tableview.dataSource = self
    tableview.separatorStyle = UITableViewCellSeparatorStyle.None
    tableview.contentInset = UIEdgeInsets(top:-(VwUserDetail.frame.origin.y-20), left: 0, bottom: 0, right: 0)
  
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    fetchDataFromdataBase()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return arrSettData.count
  }
  
  func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 80
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableview.dequeueReusableCellWithIdentifier("cell") as! SettingTableViewCell
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.defaultUICellContent(arrSettData.objectAtIndex(indexPath.row) as! NSString, index: indexPath.row,frame: self.view.frame)
    cell.swtRemind.addTarget(self, action: "setDownloadReminder:", forControlEvents:UIControlEvents.ValueChanged)
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var state = userDefaults.objectForKey("state") as! Bool
    if(state){
      cell.swtRemind.setOn(true, animated:false)
    }else{
      cell.swtRemind.setOn(false, animated:false)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
   switch (indexPath.row){
    
   case 0://Alreday downloaded
    print(arrSettData.objectAtIndex(indexPath.row))
    
   case 1://Download reminder
    print(arrSettData.objectAtIndex(indexPath.row))
    
   case 2://Feedback
    print(arrSettData.objectAtIndex(indexPath.row))
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FeedbackID") as! FeedbackViewController
    self.navigationController?.pushViewController(vc, animated: true)
   case 3://Recommand to friend
    print(arrSettData.objectAtIndex(indexPath.row))
  
    let firstActivityItem = "Tounger"
    let url:NSURL = NSURL(string: "http://roadfiresoftware.com/2014/02/how-to-add-facebook-and-twitter-sharing-to-an-ios-app/")!
    let image: UIImage! = UIImage(named: "Splash")
    
    let activityViewController : UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem,url,image], applicationActivities: nil)
    self.presentViewController(activityViewController, animated: true, completion:nil)
    
   case 4: //About us
    print(arrSettData.objectAtIndex(indexPath.row))
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AppFlowID") as! AppFlowViewController
    self.navigationController?.pushViewController(vc, animated: true)
   default:
     print("******** Error**********")
    }
  }
  
  
  func setDownloadReminder(switchss:UISwitch){
    var state:Bool = false
    if switchss.on{
      state = true
    }else{
      state = false
    }
    let userDefaults = NSUserDefaults.standardUserDefaults()
    userDefaults.setValue(state, forKey: "state")
    userDefaults.synchronize()
  }
  
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
 //*********** logOut Api calling *********
  func btnLogoutTapped(){
    
    var aParams: NSDictionary = NSDictionary(objects: self.auth_token, forKeys: ["auth-token"])
    
    self.api.signOutUser(aParams as [NSObject : AnyObject], success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      //var aParam: NSDictionary! = responseObject?.objectForKey("data") as NSDictionary

      User.deleteAllEntityObjects() // delete all table
      NSUserDefaults.standardUserDefaults().removeObjectForKey("auth-token")
      NSUserDefaults.standardUserDefaults().synchronize()
      CommonUtilities.removeUserInformation()
      self.navigationController?.popToRootViewControllerAnimated(false)
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        
    })
}
  
  func fetchDataFromdataBase(){

    let userObject:NSDictionary = CommonUtilities.sharedDelegate().dictUserInfo

    let fname = userObject.valueForKey("first_name") as! String
      let lname = userObject.valueForKey("last_name") as! String
      var name: String!
      if((fname.isEmpty == false && lname.isEmpty == false )){
        name = fname+" "+lname
        lblname.text = name
      }else{
        name = ""
      }
    
    var img = userObject.valueForKey("image") as! NSObject
    if(img.isKindOfClass(NSDictionary)){
      var dict = userObject.valueForKey("image") as! NSDictionary
      var strim:NSObject = dict.valueForKey("url") as! NSObject
      
      if (strim.isKindOfClass(NSNull)){
        let url = NSURL(string: "http://idebate.org/sites/live/files/imagecache/150x150/default_profile.png" as String)
        imgVwPPic.sd_setImageWithURL(url)
      }else if((strim.isKindOfClass(NSString))){
        let url = NSURL(string:strim as! String)
        imgVwPPic.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))
        
      }
    }else if(img.isKindOfClass(NSString)){
      let url = NSURL(string:img as! String)
      imgVwPPic.sd_setImageWithURL(url, placeholderImage:UIImage(named: "User.png"))
      
    }
    
    }
}
