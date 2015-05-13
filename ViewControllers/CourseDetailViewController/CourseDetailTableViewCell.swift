//
//  CourseDetailTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 17/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class CourseDetailTableViewCell: UITableViewCell {
  
  var id: NSString!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultCellContentForCourseDetail (dict : NSDictionary , btnIndex:Int){
    
    println(dict)
   
    switch(btnIndex) {
    
    case 1:
      id = dict.objectForKey("id") as NSString
      switch (id){
      case "0":
          var lblclassname: UILabel = UILabel(frame: CGRectMake(10, 0,self.frame.width,30))
          //lblclassname.text = dict.objectForKey("coursename") as NSString
          //lblclassname.backgroundColor = UIColor.redColor()
          lblclassname.font = lblclassname.font.fontWithSize(16)
          lblclassname.textColor = UIColor.blackColor()
          self.contentView.addSubview(lblclassname)
         
          var lblSym: UILabel = UILabel(frame: CGRectMake(20,20,50,50))
          lblSym.text = "$"
          lblSym.font = lblSym.font.fontWithSize(22)
          lblSym.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
          self.contentView.addSubview(lblSym)
        
          var lblrate: UILabel = UILabel(frame: CGRectMake(40,lblSym.frame.origin.y+5,100, 40))
          lblrate.text = "0.0"//NSString(format: "%i",(dict.objectForKey("price")?.integerValue)!)
          lblrate.font = lblrate.font.fontWithSize(22)
          lblrate.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
          self.contentView.addSubview(lblrate)
      case "1","2","3":
        var imgVw: UIImageView! = UIImageView(frame: CGRectMake(0,20, 30, 30))
        imgVw.image = UIImage(named: dict.objectForKey("image")as NSString)
        self.contentView.addSubview(imgVw)
       
        var lblTitle: UILabel = UILabel(frame: CGRectMake(imgVw.frame.width+10, 0, 200,30))
        lblTitle.text = dict.objectForKey("tilte") as NSString
        lblTitle.font = lblTitle.font.fontWithSize(16)
        lblTitle.textColor = UIColor.blackColor()
        self.contentView.addSubview(lblTitle)
        
        var lblData: UILabel = UILabel(frame: CGRectMake(lblTitle.frame.origin.x,lblTitle.frame.origin.y+lblTitle.frame.height, 200, 30))
        lblData.text = dict.objectForKey("data") as NSString
        lblData.font = lblData.font.fontWithSize(15)
        lblData.textColor = UIColor.grayColor()
        self.contentView.addSubview(lblData)
        
      default:
        println("****")
        }      
    default:
      println("****")
    }
  }
  
  
  
  
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
