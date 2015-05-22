//
//  ChargeViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 14/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class ChargeViewController: UIViewController,UITextFieldDelegate {
  
  let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
  var barBackBtn :UIBarButtonItem!
  var lblAmount: UILabel!
  var lbl$: UILabel!
  var lblMoney: UILabel!
  var cusTxtMobileNum:CustomTextFieldBlurView!
  var cusTxtQuantity:CustomTextFieldBlurView!
  var btnCharge: UIButton!
  
  var scrollview: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    self.title = "Charge"
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "sideIcon.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "rightswipeGestureRecognizer", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    scrollview = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y, self.view.frame.width, self.view.frame.height))
    scrollview.scrollEnabled = true
    scrollview.showsHorizontalScrollIndicator = true
    scrollview.scrollEnabled = true
    scrollview.userInteractionEnabled = true
    //scrollview.backgroundColor = UIColor.grayColor()
    scrollview.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    self.view.addSubview(scrollview)
    
    lblAmount = UILabel(frame: CGRectMake(scrollview.frame.origin.x+10,scrollview.frame.origin.y,100, 40))
    lblAmount.text = "Amount:"
    lblAmount.font = lblAmount.font.fontWithSize(15)
    scrollview.addSubview(lblAmount)
    
    lbl$ = UILabel(frame: CGRectMake((lblAmount.frame.origin.x+lblAmount.frame.width)-30, lblAmount.frame.origin.y,20, 40))
    lbl$.text = "$"
    lbl$.font = lbl$.font.fontWithSize(25)
    //lbl$.backgroundColor = UIColor.blackColor()
    lbl$.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    scrollview.addSubview(lbl$)
    
    lblMoney = UILabel(frame: CGRectMake(lbl$.frame.origin.x+lbl$.frame.width,lbl$.frame.origin.y,100,lbl$.frame.height))
    lblMoney.text = "0.0"
    lblMoney.font = lbl$.font.fontWithSize(25)
    //lblMoney.backgroundColor = UIColor.blackColor()
    lblMoney.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    scrollview.addSubview(lblMoney)
    
    var btnBarDone: UIBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "btnTappedToolbarDone:")
    
    var btnFlexSpace: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
    
//    var btnBaCancel: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: nil, action: nil)

    var toolbar: UIToolbar! = UIToolbar(frame: CGRectMake(0, 0,self.view.frame.width, 50))
    var arrItems: NSArray! = NSArray(objects:btnFlexSpace,btnBarDone)
    toolbar.items = arrItems
    toolbar.sizeToFit()
    
    
    var frameMobile:CGRect = CGRectMake(self.view.frame.origin.x+20,lblMoney.frame.origin.y+lblMoney.frame.height+80, self.view.frame.width-40, 40)
    
    cusTxtMobileNum = CustomTextFieldBlurView(frame:frameMobile, imgName:"")
    cusTxtMobileNum.attributedPlaceholder = NSAttributedString(string:"Type Your Mobile",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    //custxtEmail.returnKeyType = UIReturnType.Done
    cusTxtMobileNum.delegate = self;
    cusTxtMobileNum.returnKeyType = UIReturnKeyType.Done
    cusTxtMobileNum.clearButtonMode = UITextFieldViewMode.Always
    cusTxtMobileNum.keyboardType = UIKeyboardType.NumberPad
    cusTxtMobileNum.inputAccessoryView = toolbar
    scrollview.addSubview(cusTxtMobileNum)
    
    var frameQuatity:CGRect = CGRectMake(cusTxtMobileNum.frame.origin.x,cusTxtMobileNum.frame.origin.y+cusTxtMobileNum.frame.height+20, cusTxtMobileNum.frame.width, cusTxtMobileNum.frame.height)
    
    cusTxtQuantity = CustomTextFieldBlurView(frame:frameQuatity, imgName:"")
    cusTxtQuantity.attributedPlaceholder = NSAttributedString(string:"The Quantity You Need",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    //custxtEmail.returnKeyType = UIReturnType.Done
    cusTxtQuantity.delegate = self;
    cusTxtQuantity.returnKeyType = UIReturnKeyType.Done
    cusTxtQuantity.clearButtonMode = UITextFieldViewMode.Always
    cusTxtQuantity.keyboardType = UIKeyboardType.NumberPad
    cusTxtQuantity.inputAccessoryView = toolbar
    scrollview.addSubview(cusTxtQuantity)
    
    btnCharge = UIButton(frame: CGRectMake(cusTxtQuantity.frame.origin.x,cusTxtQuantity.frame.origin.y+cusTxtQuantity.frame.height+40, cusTxtQuantity.frame.width, 40))
    btnCharge.setTitle("charge", forState: UIControlState.Normal)
    btnCharge.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnCharge.backgroundColor = UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)
    btnCharge.addTarget(self, action: "btnChargetapped:", forControlEvents: UIControlEvents.TouchUpInside)
    scrollview.addSubview(btnCharge)

    
  }
  
  func rightswipeGestureRecognizer(){
    
    UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
      self.appDelegate.objSideBar.frame = self.view.bounds
      self.appDelegate.objSideBar.sideNavigation = self.navigationController
      }, completion: nil)
    
  }
  
  func btnTappedToolbarDone(sender:AnyObject){
    scrollview.contentOffset = CGPoint(x:0, y:0)
    cusTxtMobileNum.resignFirstResponder()
    cusTxtQuantity.resignFirstResponder()
  }
  
  func btnChargetapped(sender:AnyObject){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("PayID") as PayViewController
    vc.strMoney = cusTxtQuantity.text
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
    scrollview.contentOffset = CGPoint(x:0, y:(40))
    return true
  }

  
}
