//
//  PayViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 06/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class PayViewController: BaseViewController {
  
  var barBackBtn :UIBarButtonItem!
  
  var lblText : UILabel!
  var lblmoney : UILabel!
  var btnpaypal : UIButton!
  var btnmakesure : UIButton!
  var strMoney: NSString! = "0"
  var clsDict: NSDictionary!
  var segment: UISegmentedControl!
  var choosMethod:NSInteger = 0
  var api: AppApi!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func defaultUIDesign(){
    
     print(clsDict)
    
    self.title = "Select the way to pay"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    lblText = UILabel(frame: CGRectMake(self.view.frame.origin.x+30, self.view.frame.origin.y+84, 150, 30))
    lblText.text = "You Need to Pay"
    lblText.font = lblText.font.fontWithSize(15)
    lblText.textColor = UIColor.grayColor()
    self.view.addSubview(lblText)
    
    var str1: NSString = "$"
    lblmoney = UILabel(frame: CGRectMake(lblText.frame.origin.x,lblText.frame.origin.y+lblText.frame.size.height,200, 50))
    lblmoney.text = (str1 as String) + " " + (NSString(format: "%i",(clsDict.objectForKey("price")?.integerValue)!) as String)
    lblmoney.font = lblmoney.font.fontWithSize(30)
    lblmoney.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    self.view.addSubview(lblmoney)
    
//    btnpaypal = UIButton(frame: CGRectMake(self.view.frame.origin.x+20,lblmoney.frame.origin.y+lblmoney.frame.size.height , self.view.frame.width-40, 60))
//    btnpaypal.setTitle("Paypal For charge", forState: UIControlState.Normal)
//    btnpaypal.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
//    btnpaypal.layer.borderWidth = 1
//    btnpaypal.layer.borderColor = UIColor.lightGrayColor().CGColor
//    self.view.addSubview(btnpaypal)
    
    var arryItem: NSArray = NSArray(objects: "Wallet","PayPal")
    
    segment = UISegmentedControl(items: arryItem as! [String])
    segment.frame = CGRectMake(self.view.frame.origin.x+20,lblmoney.frame.origin.y+lblmoney.frame.size.height+20, self.view.frame.width-40,40)
    segment.tintColor =  UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    segment.selectedSegmentIndex = 0
    segment.addTarget(self, action: "segmentTapped:", forControlEvents:UIControlEvents.ValueChanged)
    self.view.addSubview(segment)
    
    btnmakesure = UIButton(frame: CGRectMake(self.view.frame.origin.x+20,self.view.frame.height-50, self.view.frame.width-40, 40))
    btnmakesure.setTitle("OK", forState: UIControlState.Normal)
    btnmakesure.addTarget(self, action: "btnTappedOK:", forControlEvents: UIControlEvents.TouchUpInside)
    btnmakesure.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnmakesure.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    
    self.view.addSubview(btnmakesure)
  }
  
  func segmentTapped(segment:UISegmentedControl){
    choosMethod = segment.selectedSegmentIndex
  }
  
  func btnTappedOK(sender:UIButton){
    if(choosMethod == 0){
      walletApiCall()
    }else if(choosMethod == 1){
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("PaypalVC") as! PayPalViewController
      vc.dictCls = clsDict
      vc.method = "payment"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OrderConfID") as! OrderConfViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //************ Wallet Api methode Call*********
  
  func walletApiCall(){

    var aParams: NSMutableDictionary = NSMutableDictionary()
        aParams.setValue(self.auth_token[0], forKey:"auth-token")
        aParams.setValue(clsDict.valueForKey("id"), forKey: "cls_id")
        aParams.setValue(clsDict.valueForKey("price"), forKey: "money")
    
    self.api.walletApi(aParams as NSDictionary as [NSObject : AnyObject],success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.UserUpadteApiCall()
      var alert: UIAlertView = UIAlertView(title: "Alert", message: "Your Transaction Successfully", delegate:self, cancelButtonTitle:"OK")
      alert.show()
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "You have not sufficent amount in your wallet, please charge your wallet or select another payment method", delegate:self, cancelButtonTitle:"OK")
        alert.show()
    })
  }
  
  //****** Update User Recodes ans Api call ************
  
  func UserUpadteApiCall(){
    var money: NSInteger!
    var cls_amount: NSInteger!
    var remainingMoney: NSInteger!
    cls_amount = clsDict.valueForKey("price")?.integerValue

    let userObject:NSDictionary = CommonUtilities.sharedDelegate().dictUserInfo

    if(userObject.valueForKey("money") as! String).isEmpty == false {
      var strmoney = userObject.valueForKey("money") as! NSString
      money = strmoney.integerValue
    }
    remainingMoney = money - cls_amount
    var strmoney = NSString(format: "%i",remainingMoney)
    self.updateUserRecode(strmoney)
    var aParam:NSMutableDictionary = NSMutableDictionary()
    aParam.setValue(self.auth_token[0], forKey: "auth-token")
    aParam.setValue(remainingMoney, forKey: "user[money]")    
   // self.api.userMoneyUpdate(aParam)
  }
  
  func updateUserRecode(money:NSString){
    
    var userDefault:NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var data:NSData = userDefault.objectForKey("user") as! NSData
    var dictFetchedData:NSDictionary = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! NSDictionary
    
    CommonUtilities.sharedDelegate().dictUserInfo = dictFetchedData
    print(dictFetchedData)
    var userDict:NSMutableDictionary = NSMutableDictionary()
    
    userDict.setValue(dictFetchedData.valueForKey("batch_count"), forKey: "batch_count")
    userDict.setValue(dictFetchedData.valueForKey("created_at"), forKey: "created_at")
    userDict.setValue(dictFetchedData.valueForKey("device_token"), forKey: "device_token")
    userDict.setValue(dictFetchedData.valueForKey("email"), forKey: "email")
    userDict.setValue(dictFetchedData.valueForKey("first_name"), forKey: "first_name")
    userDict.setValue(dictFetchedData.valueForKey("id"), forKey: "id")
    userDict.setValue(dictFetchedData.valueForKey("last_name"), forKey: "last_name")
    userDict.setValue(money, forKey: "money")
    userDict.setValue(dictFetchedData.valueForKey("updated_at"), forKey: "updated_at")
    
    var img = dictFetchedData.valueForKey("image") as! NSObject
    if(img.isKindOfClass(NSDictionary)){
      userDict.setValue(dictFetchedData.valueForKey("image")?.valueForKey("url"), forKey: "image")
    }else if(img.isKindOfClass(NSString)){
      userDict.setValue(dictFetchedData.valueForKey("image"), forKey: "image")
    }
    CommonUtilities.addUserInformation(userDict)
  }


  
}
