//
//  AddNotesViewController.swift
//  Tonguer
//
//  Created by GrepRuby on 29/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit


class AddNotesViewController: BaseViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate {
  
  var barBackBtn :UIBarButtonItem!
  var swtPublish: UISwitch!
  var btnUpload: UIButton!
  var btnSelectCourse: UIButton!
  var txtVwContent: UITextView!
  var lblTxtVwPlace: UILabel!
  var imagePicker = UIImagePickerController()
  var scrollVW: UIScrollView!
  var ImgVW: UIImageView!
  var imagePick: UIImage!
  var api: AppApi!
  var isEnable: Bool!
  var cusTxtFieldCls:CustomTextFieldBlurView!
  var pickerVW: UIPickerView!
  var toolBar: UIToolbar!
  var arrclass:NSMutableArray! = NSMutableArray()
  var cls_id:NSInteger!
  var lblSelectImg: UILabel!
  var lblPublish: UILabel!
  var dictNote: NSDictionary!
  var is_Call: NSString!
  var actiIndecatorVw: ActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    api = AppApi.sharedClient()
    print(dictNote)
    fetchDataFromDBforDefaultCls()
    self.defaultUIDesign()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func defaultUIDesign(){
    
    self.navigationItem.setHidesBackButton(true, animated:false)
    
    var backbtn:UIButton = UIButton(frame: CGRectMake(0, 0,25,25))
    backbtn.setImage(UIImage(named: "whiteback.png"), forState: UIControlState.Normal)
    backbtn.addTarget(self, action: "btnBackTapped", forControlEvents: UIControlEvents.TouchUpInside)
    
    barBackBtn = UIBarButtonItem(customView: backbtn)
    
    self.navigationItem.setLeftBarButtonItem(barBackBtn, animated: true)
    
    var btnBarSave: UIBarButtonItem! = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "btnSaveTapped:")
    btnBarSave.tintColor = UIColor.whiteColor()
    
    swtPublish = UISwitch(frame: CGRectMake(0, 0,30,30))
    swtPublish.addTarget(self, action: "switchIsenable:", forControlEvents: UIControlEvents.TouchUpInside)
//    sWPublish.layer.cornerRadius = 16
//    sWPublish.transform = CGAffineTransformMakeScale(0.90, 0.70)
//    
//    var btnBarPublish: UIBarButtonItem! = UIBarButtonItem(customView: swtPublish)
//    
//    btnUpload = UIButton(frame: CGRectMake(0, 0,30,30))
//    btnUpload.setImage(UIImage(named: "imgUpload.png"), forState: UIControlState.Normal)
//    btnUpload.addTarget(self, action: "btnUploadTapped:", forControlEvents: UIControlEvents.TouchUpInside)
//    
//    var btnBarUpload: UIBarButtonItem! = UIBarButtonItem(customView: btnUpload)
    
    self.navigationItem.setRightBarButtonItems([btnBarSave], animated: true)
    
    
    scrollVW = UIScrollView(frame: CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y,self.view.frame.size.width, self.view.frame.size.height))
    
    scrollVW.showsHorizontalScrollIndicator = true
    scrollVW.scrollEnabled = true
    scrollVW.userInteractionEnabled = true
   // scrollVW.backgroundColor = UIColor.grayColor()
    scrollVW.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)
    self.view.addSubview(scrollVW)

  
    
    txtVwContent = UITextView(frame: CGRectMake(scrollVW.frame.origin.x+10,5,scrollVW.frame.width-20, 150))
    txtVwContent.delegate = self
    txtVwContent.layer.borderWidth = 1
    txtVwContent.layer.borderColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0).CGColor
    scrollVW.addSubview(txtVwContent)
    
   lblTxtVwPlace = UILabel(frame: CGRectMake((self.txtVwContent.frame.width-200)/2,(self.txtVwContent.frame.height-30)/2,200, 30))
    //lblTxtVwPlace.backgroundColor = UIColor.redColor()
    lblTxtVwPlace.text = "Fill the Content for notes"
    lblTxtVwPlace.textAlignment = NSTextAlignment.Center
    lblTxtVwPlace.font = lblTxtVwPlace.font.fontWithSize(12)
    lblTxtVwPlace.textColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    txtVwContent.addSubview(lblTxtVwPlace)
    
    
    pickerVW = UIPickerView(frame: CGRectMake(0, 0,100,250))
    pickerVW.dataSource = self
    pickerVW.delegate = self
    
    var barBtnDone: UIBarButtonItem! = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "barBtnDonTapped:")
    var barSpace: UIBarButtonItem! = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target:self, action: nil)
    
    toolBar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.width,50))
    toolBar.items = [barSpace,barBtnDone]
    
    
    var frameEmail:CGRect = CGRectMake(txtVwContent.frame.origin.x,txtVwContent.frame.size.height+txtVwContent.frame.origin.y+5,txtVwContent.frame.size.width, 40)
    
    cusTxtFieldCls = CustomTextFieldBlurView(frame:frameEmail, imgName:"")
    cusTxtFieldCls.attributedPlaceholder = NSAttributedString(string:"Class Selcet",attributes:[NSForegroundColorAttributeName: UIColor(red: 66.0/255.0, green: 150.0/255.0, blue: 173.0/255.0,alpha:1.0)])
    //custxtEmail.returnKeyType = UIReturnType.Done
    cusTxtFieldCls.inputView = pickerVW
    cusTxtFieldCls.inputAccessoryView = toolBar
    cusTxtFieldCls.delegate = self;
    cusTxtFieldCls.clearButtonMode = UITextFieldViewMode.Always
    scrollVW.addSubview(cusTxtFieldCls)
    
   
    ImgVW = UIImageView(frame: CGRectMake(cusTxtFieldCls.frame.width-100,cusTxtFieldCls.frame.origin.y+cusTxtFieldCls.frame.height+50,100,100))
    //ImgVW.backgroundColor = UIColor.grayColor()
    ImgVW.userInteractionEnabled = true
    ImgVW.layer.borderWidth = 0.5
    ImgVW.layer.borderColor = UIColor.lightGrayColor().CGColor
   scrollVW.addSubview(ImgVW)
    
    lblSelectImg = UILabel(frame: CGRectMake(cusTxtFieldCls.frame.origin.x,ImgVW.frame.origin.y+(ImgVW.frame.size.height-30)/2, 100, 30))
    lblSelectImg.text = "Upload Image:"
    lblSelectImg.font = lblSelectImg.font.fontWithSize(14)
    scrollVW.addSubview(lblSelectImg)
    
    var btnImgPick: UIButton = UIButton(frame:ImgVW.frame)
    btnImgPick.setTitle("Press", forState: UIControlState.Normal)
    btnImgPick.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
    btnImgPick.addTarget(self, action: "btnImgPickTapped:", forControlEvents: UIControlEvents.TouchUpInside)
   // btnImgPick.backgroundColor = UIColor.redColor()
    scrollVW.addSubview(btnImgPick)
    scrollVW.bringSubviewToFront(btnImgPick)
    
    swtPublish = UISwitch(frame: CGRectMake(ImgVW.frame.origin.x+10,ImgVW.frame.origin.y+ImgVW.frame.height+50,30,30))
    swtPublish.addTarget(self, action: "switchIsenable:", forControlEvents: UIControlEvents.TouchUpInside)
    scrollVW.addSubview(swtPublish)
    
    lblPublish = UILabel(frame: CGRectMake(lblSelectImg.frame.origin.x,swtPublish.frame.origin.y,150, 30))
    lblPublish.text = "Enable to Other users :"
    lblPublish.font = lblSelectImg.font.fontWithSize(14)
    scrollVW.addSubview(lblPublish)
    
    showNoteContentForUpdate()

    
  }
  
  func barBtnDonTapped(sender:UIBarButtonItem){
    cusTxtFieldCls.resignFirstResponder()
  }
  
  func btnSelectCoursTapped(sender:AnyObject){
    var vc = self.storyboard?.instantiateViewControllerWithIdentifier("CourseListID") as CourselistViewController
    self.navigationController?.pushViewController(vc, animated: true)
  }
  
  func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  
  func switchIsenable(sender:UISwitch){
    
    if sender.on{
      isEnable = true
    }else{
      isEnable = false
    }
    
  }
  
  func btnImgPickTapped(sender:UIButton){
    var btn = sender as UIButton
    btn.setTitle("", forState: UIControlState.Normal)
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
    ImgVW.image = image
    imagePick = image
  }
  
  
  func btnSaveTapped(sender:AnyObject){
    
    actiIndecatorVw = ActivityIndicatorView(frame: self.view.frame)
    self.view.addSubview(actiIndecatorVw)
    
    if(is_Call == "Upadte"){
     notesUpdateApiCall()
    }else if(is_Call == "Save"){
      notesSaveApiCall()
    }
    
  }
  
  
  func notesSaveApiCall(){
    
    var base64String:NSString!
    if((imagePick) != nil){
      var imageData = UIImagePNGRepresentation(imagePick)
        base64String = imageData.base64EncodedStringWithOptions(.allZeros) as NSString
      println(base64String)
    }else{
      base64String = ""
    }
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    
    aParams.setValue(txtVwContent.text, forKey: "note[content]")
    aParams.setValue(base64String, forKey: "image_code")
    aParams.setValue(isEnable, forKey: "note[is_enable]")
    aParams.setValue(cls_id, forKey: "class_id")
    //aParams.setValue(cusTxtFieldCls.text, forKey: "note[cls_name]")
    self.api.createUserNotes(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.removeFromSuperview()
      var alert: UIAlertView = UIAlertView(title: "Alert", message: "Note successfully created.", delegate:self, cancelButtonTitle:"OK")
      alert.show()
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
         self.actiIndecatorVw.removeFromSuperview()
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Note not created.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
        
    })

    
  }
  
  
  //******************* Notes Edit Api Call **************
  
  
  func notesUpdateApiCall(){
    
    var base64String:NSString!
    if((imagePick) != nil){
      var imageData = UIImagePNGRepresentation(imagePick)
      base64String = imageData.base64EncodedStringWithOptions(.allZeros) as NSString
      //println(base64String)
    }else{
      var imageData = UIImagePNGRepresentation(imagePick)
      base64String = imageData.base64EncodedStringWithOptions(.allZeros) as NSString
    }
    
    var aParams: NSMutableDictionary! = NSMutableDictionary()
    aParams.setValue(auth_token[0], forKey: "auth_token")
    aParams.setValue(dictNote.valueForKey("id"), forKey: "note_id")
    aParams.setValue(txtVwContent.text, forKey: "note[content]")
    aParams.setValue(base64String, forKey: "image_code")
    aParams.setValue(isEnable, forKey: "note[is_enable]")
    aParams.setValue(cls_id, forKey: "note[a_class_id]")
    //aParams.setValue(cusTxtFieldCls.text, forKey: "note[cls_name]")
    
    self.api.callNotesUpdateApi(aParams, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject? ) in
      println(responseObject)
      self.actiIndecatorVw.removeFromSuperview()
      var alert: UIAlertView = UIAlertView(title: "Alert", message: "Note successfully updated.", delegate:self, cancelButtonTitle:"OK")
      alert.show()
      
      },
      failure: { (operation: AFHTTPRequestOperation?, error: NSError? ) in
        println(error)
        self.actiIndecatorVw.removeFromSuperview()
        var alert: UIAlertView = UIAlertView(title: "Alert", message: "Note not updated successfully.", delegate:self, cancelButtonTitle:"OK")
        alert.show()
        
    })
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
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return arrclass.count
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
    
    var dict: NSDictionary! = arrclass.objectAtIndex(row) as NSDictionary
    var strName: NSString! = dict.valueForKey("name") as NSString

    return strName
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     var dict: NSDictionary! = arrclass.objectAtIndex(row) as NSDictionary
    cusTxtFieldCls.text = dict.valueForKey("name") as NSString
    cls_id = dict.valueForKey("id") as NSInteger
    print(cls_id)
  }
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func fetchDataFromDBforDefaultCls(){
    let arrFetchedData : NSArray = UserDefaultClsList.MR_findAll()
    
    for var index = 0; index < arrFetchedData.count; ++index {
      let userClsObj : UserDefaultClsList = arrFetchedData.objectAtIndex(index) as UserDefaultClsList
      var dict: NSMutableDictionary! = NSMutableDictionary()
      
      dict.setObject(userClsObj.cls_id, forKey: "id")
      
      if((userClsObj.cls_name) != nil){
        dict.setObject(userClsObj.cls_name, forKey:"name")
      }else{
        dict.setObject("No Class Name", forKey:"name")
      }
      
      if((userClsObj.cls_img_url) != nil){
        var str_url: NSString = userClsObj.cls_img_url
        dict.setObject(str_url, forKey:"image")
        
      }else{
        var str_url: NSString = "http://www.popular.com.my/images/no_image.gif"
        dict.setObject(str_url, forKey:"image")
      }
      
      if((userClsObj.cls_vaild_days) != nil){
        dict.setObject(userClsObj.cls_vaild_days,forKey:"days")
        
      }else{
        dict.setObject("No Day",forKey:"days")
      }
      
      if((userClsObj.cls_score) != nil){
        dict.setObject(userClsObj.cls_score, forKey: "score")
        
      }else{
        dict.setObject("0.0", forKey: "score")
      }
      
      if((userClsObj.cls_price) != nil){
        dict.setObject(userClsObj.cls_price, forKey: "price")
        
      }else{
        dict.setObject("0.0", forKey: "price")
      }
      
      if((userClsObj.cls_progress) != nil){
        dict.setObject(userClsObj.cls_progress, forKey:"progress")
        
      }else{
        dict.setObject("0", forKey:"progress")
      }
      arrclass.addObject(dict)
    }
    
    print(arrclass.count)
    
  }
  
  func showNoteContentForUpdate(){
    if((dictNote) != nil){
      txtVwContent.text = dictNote.valueForKey("content") as NSString
      lblTxtVwPlace.hidden = true
      
      var state: NSNumber! = dictNote.valueForKey("isenable") as NSNumber
      
      if(state == 0){
        swtPublish.setOn(false, animated:false)
      }else if(state == 1){
        swtPublish.setOn(true, animated:false)
      }
      
      cusTxtFieldCls.text = dictNote.valueForKey("cls_name") as NSString
      
      let url = NSURL(string: dictNote.objectForKey("image") as NSString)
      var data = NSData(contentsOfURL: url!)
      if((data) != nil){
        imagePick = UIImage(data: data!)
      }else{
        imagePick = UIImage(named: "defaultImg")
      }
      ImgVW.sd_setImageWithURL(url)
    
      cls_id = dictNote.valueForKey("cls_id") as NSInteger
    }
  }

 
  
  func editNotesApiCall () {
    
    let param:NSDictionary = ["":""]
    self.api.callNotesUpdateApi(param, success: { (operation: AFHTTPRequestOperation?, responseObject: AnyObject?) -> Void in
      var alertVw:UIAlertView = UIAlertView(title:"Message", message:"Notes updates successfully", delegate: nil, cancelButtonTitle:"OK")
      alertVw.show()
      }){ (operation: AFHTTPRequestOperation?,errro:NSError!) -> Void in
        
    }
  }

  
  
}
