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
    lblmoney.text = str1 + " " + NSString(format: "%i",(clsDict.objectForKey("price")?.integerValue)!)
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
    
    segment = UISegmentedControl(items: arryItem)
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
      var vc = self.storyboard?.instantiateViewControllerWithIdentifier("PaypalVC") as PayPalViewController
      vc.dictCls = clsDict
      vc.method = "payment"
      self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func btnforwardTapped(){
    let vc = self.storyboard?.instantiateViewControllerWithIdentifier("OrderConfID") as OrderConfViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  //************ Wallet Api methode Call*********
  
  func walletApiCall(){

    var aParams: NSMutableDictionary = NSMutableDictionary()
        aParams.setValue(self.auth_token[0], forKey:"auth_token")
        aParams.setValue(clsDict.valueForKey("id"), forKey: "cls_id")
        aParams.setValue(clsDict.valueForKey("price"), forKey: "money")
    
    self.api.walletApi(aParams as NSDictionary,success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
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
    let arrFetchedData : NSArray = User.MR_findAll()
    let userObject : User = arrFetchedData.objectAtIndex(0) as User
    if((userObject.money) != nil){
      money = userObject.money.integerValue
    }
    remainingMoney = money - cls_amount
    var aParam:NSMutableDictionary = NSMutableDictionary()
    aParam.setValue(self.auth_token[0], forKey: "auth_token")
    aParam.setValue(remainingMoney, forKey: "user[money]")    
    self.api.userMoneyUpdate(aParam)
  }


  
}
