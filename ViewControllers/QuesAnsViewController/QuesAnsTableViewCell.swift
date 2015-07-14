//
//  QuesAnsTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class QuesAnsTableViewCell: BaseTableViewCell {
  
  @IBOutlet var celltxtVw : UIView!
  @IBOutlet var cellLine :  UIView!
  @IBOutlet var cellImgVw : UIImageView!
  @IBOutlet var celllbltext:UILabel!
  @IBOutlet var cellbtnAns : UIButton!
  @IBOutlet var cellbtnAddAns : UIButton!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUIDesign(aParam: NSDictionary,frame:CGRect){
    celltxtVw.frame = CGRectMake(frame.origin.x+20,frame.origin.y+10,frame.width-40,60)
    cellImgVw.frame = CGRectMake(10,10,20,20)
    cellLine.frame = CGRectMake(cellImgVw.frame.size.width + cellImgVw.frame.origin.x + 10, cellImgVw.frame.origin.y, 1, cellImgVw.frame.height)
    celllbltext.frame = CGRectMake(cellLine.frame.origin.x+10,0,celltxtVw.frame.width-70,celltxtVw.frame.height-20)
    cellbtnAns.frame =  CGRectMake(celltxtVw.frame.origin.x,celltxtVw.frame.origin.y+celltxtVw.frame.size.height+10, (celltxtVw.frame.width - 5)/2,30)
    cellbtnAddAns.frame = CGRectMake(cellbtnAns.frame.width+25, cellbtnAns.frame.origin.y,cellbtnAns.frame.width,cellbtnAns.frame.height)
    self.setContentProperties(aParam)
  }
  
  func setContentProperties(aParam: NSDictionary){
    
    celltxtVw.backgroundColor = UIColor.whiteColor()
    
    celltxtVw.layer.borderWidth = 0.38
    celltxtVw.layer.borderColor = UIColor.grayColor().CGColor
    //cellImgVw.backgroundColor = UIColor.grayColor()
    cellImgVw.image = UIImage(named: "Q.png")
    
    cellLine.backgroundColor = UIColor.lightGrayColor()
    
    celllbltext.numberOfLines = 3
    //celllbltext.backgroundColor = UIColor.yellowColor()
    celllbltext.font = celllbltext.font.fontWithSize(13)
    celllbltext.text = aParam.valueForKey("question") as NSString
    celllbltext.textColor = UIColor.grayColor()
    
    cellbtnAns.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0,alpha:1.0)
    cellbtnAns.setTitle("Answers", forState: UIControlState.Normal)
    cellbtnAns.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    cellbtnAns.titleLabel?.font = cellbtnAns.titleLabel?.font.fontWithSize(12)
    
    cellbtnAddAns.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    cellbtnAddAns.setTitle("Add Answer", forState: UIControlState.Normal)
    cellbtnAddAns.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    cellbtnAddAns.titleLabel?.font = cellbtnAddAns.titleLabel?.font.fontWithSize(12)
  }
  
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
