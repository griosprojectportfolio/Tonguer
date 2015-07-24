//
//  OrderConfViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 06/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class OrderConfViewController: BaseViewController,UITextFieldDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var imgVw :UIImageView!
  var lblDetail,lblmoney,lblVaild,lblNeed,lblNeedmoney:UILabel!
  var txtFieldMoney,txtFieldContact : CustomTextFieldBlurView!
  var btnConfirmpay :UIButton!
  var clsDict: NSDictionary = NSDictionary()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    print(clsDict)
    self.title = "Order Confirm"
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  
  func defaultUIDesign(){
  
    imgVw = UIImageView(frame: CGRectMake(self.view.frame.origin.x+30, self.view.frame.origin.y+84, 80, 60))
    let url = NSURL(string: clsDict.objectForKey("image") as!  String)
    imgVw.sd_setImageWithURL(url, placeholderImage:UIImage(named:"defaultImg.png"))
    self.view.addSubview(imgVw)
    
    lblDetail = UILabel(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.size.width+10,imgVw.frame.origin.y+(imgVw.frame.height-40)/2, self.view.frame.width-150,40))
    lblDetail.numberOfLines = 2
    //lblDetail.backgroundColor = UIColor.redColor()
    lblDetail.textColor = UIColor.darkGrayColor()
    lblDetail.font = lblDetail.font.fontWithSize(15)
    let strName = clsDict.valueForKey("name") as! String
    lblDetail.text = strName
    self.view.addSubview(lblDetail)
    
     var str = "$" as String
    lblmoney = UILabel(frame: CGRectMake(imgVw.frame.origin.x+(imgVw.frame.width - 70)/2,imgVw.frame.origin.y+imgVw.frame.height+5,100,50))
    lblmoney.text = str + "  " + (NSString(format: "%i",(clsDict.objectForKey("price")?.integerValue)!) as String)
    lblmoney.font = lblmoney.font.fontWithSize(20)
    lblmoney.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    self.view.addSubview(lblmoney)
    
    var strValid: NSString = "Vaild to days:"
    lblVaild = UILabel(frame: CGRectMake((self.view.frame.width-150)-20, lblmoney.frame.origin.y,150, 40))
    lblVaild.text = (strValid as String) + "  " + (NSString(format: "%i",(clsDict.objectForKey("valid_days")?.integerValue)!) as String)
    lblVaild.font = lblmoney.font.fontWithSize(12)
    lblVaild.textColor = UIColor.grayColor()
    self.view.addSubview(lblVaild)
    
    var txtmoneyframe:CGRect = CGRectMake(self.view.frame.origin.x+20,lblmoney.frame.origin.y+lblmoney.frame.size.height+20, self.view.frame.width-40, 40)
    
    txtFieldMoney = CustomTextFieldBlurView(frame:txtmoneyframe, imgName:"")
    txtFieldMoney.attributedPlaceholder = NSAttributedString(string:"Money",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    txtFieldMoney.text =  NSString(format: "%i",(clsDict.objectForKey("price")?.integerValue)!) as String
    txtFieldMoney.userInteractionEnabled = false
    txtFieldMoney.delegate = self;
    txtFieldMoney.returnKeyType = UIReturnKeyType.Done
    txtFieldMoney.clearButtonMode = UITextFieldViewMode.Always
    self.view.addSubview(txtFieldMoney)
    
    var txtcontactframe:CGRect = CGRectMake(txtmoneyframe.origin.x,txtmoneyframe.origin.y + txtmoneyframe.height+10, txtmoneyframe.width, 40)
    
    txtFieldContact = CustomTextFieldBlurView(frame:txtcontactframe, imgName:"")
    txtFieldContact.attributedPlaceholder = NSAttributedString(string:"Contact No.",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    // custxtEmail.returnKeyType = UIReturnType.Done
    txtFieldContact.delegate = self;
    txtFieldContact.returnKeyType = UIReturnKeyType.Done
    txtFieldContact.clearButtonMode = UITextFieldViewMode.Always
    self.view.addSubview(txtFieldContact)
    
    lblNeed = UILabel(frame: CGRectMake(txtFieldContact.frame.origin.x,txtFieldContact.frame.origin.y+txtFieldContact.frame.size.height+20, 100, 40))
    lblNeed.text = "You Need to Pay"
    lblNeed.font = lblmoney.font.fontWithSize(12)
    lblNeed.textColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    self.view.addSubview(lblNeed)
    
    var str1: NSString = "$"
    lblNeedmoney = UILabel(frame: CGRectMake(txtFieldContact.frame.width-40, lblNeed.frame.origin.y,100,40))
    lblNeedmoney.text = (str1 as String) + "  " + (NSString(format: "%i",(clsDict.objectForKey("price")?.integerValue)!) as String)
    lblNeedmoney.font = lblmoney.font.fontWithSize(20)
    lblNeedmoney.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    self.view.addSubview(lblNeedmoney)
    
    btnConfirmpay = UIButton(frame: CGRectMake(txtFieldContact.frame.origin.x, self.view.frame.size.height-50, txtFieldContact.frame.width, 40))
    btnConfirmpay.setTitle("Confirm Pay", forState: UIControlState.Normal)
    btnConfirmpay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnConfirmpay.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnConfirmpay.addTarget(self, action: "btnConfirmpayTapped", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnConfirmpay)

  }
  
  func btnConfirmpayTapped(){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayID") as! PayViewController
        vc.clsDict = clsDict
    self.navigationController?.pushViewController(vc, animated: true)
  }

func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  

  
}
