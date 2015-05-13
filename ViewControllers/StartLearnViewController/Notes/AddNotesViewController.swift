//
//  AddNotesViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AddNotesViewController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var sWPublish: UISwitch!
  var btnUpload: UIButton!
  var btnSelectCourse: UIButton!
  var txtVwContent: UITextView!
  var lblTxtVwPlace: UILabel!
  var imagePicker = UIImagePickerController()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var btnBarSave: UIBarButtonItem! = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "btnSaveTapped:")
    btnBarSave.tintColor = UIColor.whiteColor()
    
    sWPublish = UISwitch(frame: CGRectMake(0, 0,30,30))
//    sWPublish.layer.cornerRadius = 16
//    sWPublish.transform = CGAffineTransformMakeScale(0.90, 0.70)
    
    var btnBarPublish: UIBarButtonItem! = UIBarButtonItem(customView: sWPublish)
    
    btnUpload = UIButton(frame: CGRectMake(0, 0,30,30))
    btnUpload.setImage(UIImage(named: "imgUpload.png"), forState: UIControlState.Normal)
    btnUpload.addTarget(self, action: "btnUploadTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    
    var btnBarUpload: UIBarButtonItem! = UIBarButtonItem(customView: btnUpload)
    
    self.navigationItem.setRightBarButtonItems([btnBarSave,btnBarPublish,btnBarUpload], animated: true)
    
    btnSelectCourse = UIButton(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y+64, self.view.frame.width, 40))
    btnSelectCourse.setTitle("Course Select", forState: UIControlState.Normal)
    btnSelectCourse.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnSelectCourse.addTarget(self, action: "btnSelectCoursTapped:", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(btnSelectCourse)
    
    var lbl: UILabel! = UILabel(frame: CGRectMake(self.view.frame.width-20,btnSelectCourse.frame.origin.y+(btnSelectCourse.frame.height-20)/2,10, 20))
    lbl.text = ">"
    lbl.textColor = UIColor.grayColor()
    //lbl.backgroundColor = UIColor.redColor()
    self.view.addSubview(lbl)
    self.view.bringSubviewToFront(lbl)
    
    var vWHori: UIView! = UIView(frame: CGRectMake(btnSelectCourse.frame.origin.x,(btnSelectCourse.frame.origin.y+btnSelectCourse.frame.height), btnSelectCourse.frame.width, 1))
    vWHori.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    self.view.addSubview(vWHori)
    
    txtVwContent = UITextView(frame: CGRectMake(self.view.frame.origin.x+10,vWHori.frame.origin.y+10, self.view.frame.width-20, 150))
    txtVwContent.delegate = self
    txtVwContent.layer.borderWidth = 1
    txtVwContent.layer.borderColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0).CGColor
    self.view.addSubview(txtVwContent)
    
   lblTxtVwPlace = UILabel(frame: CGRectMake((self.txtVwContent.frame.width-200)/2,(self.txtVwContent.frame.height-30)/2,200, 30))
    //lblTxtVwPlace.backgroundColor = UIColor.redColor()
    lblTxtVwPlace.text = "Fill the Content for notes"
    lblTxtVwPlace.textAlignment = NSTextAlignment.Center
    lblTxtVwPlace.font = lblTxtVwPlace.font.fontWithSize(12)
    lblTxtVwPlace.textColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    txtVwContent.addSubview(lblTxtVwPlace)
    
  }
  
  func btnSelectCoursTapped(sender:AnyObject){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseListID") as CourselistViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func btnUploadTapped(sender:AnyObject){
    print("212112")
    if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.SavedPhotosAlbum){
      
      imagePicker.delegate = self
      imagePicker.sourceType = UIImagePickerControllerSourceType.SavedPhotosAlbum;
      imagePicker.allowsEditing = false
      
      self.presentViewController(imagePicker, animated: true, completion: nil)
    }

  }
  
  func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
    self.dismissViewControllerAnimated(true, completion: { () -> Void in
      
    })
//    imgVwProfilrPic.image = image
//    imgVwblur.image = image
//    self.UserUpadteApiCall(image)
  }

  
  
  func btnSaveTapped(sender:AnyObject){
    
  }
  
  func btnBackTapped(){
    self.navigationController?.popViewControllerAnimated(true)
  }
  
  func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    
    if(text == "\n"){
      textView.resignFirstResponder()
      return false
    }
    return true
  }
  
  func textViewShouldBeginEditing(textView: UITextView) -> Bool {
    lblTxtVwPlace.hidden = true
    return true
  }
  

}
