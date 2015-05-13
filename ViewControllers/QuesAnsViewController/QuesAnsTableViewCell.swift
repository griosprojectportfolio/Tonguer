//
//  QuesAnsTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 03/04/15.
//  Copyright (c) 2015 GrepRuby. All rights reserved.
//

import UIKit

class QuesAnsTableViewCell: BaseTableViewCell {
  
  var celltxtVw : UIView!
  var cellLine :  UIView!
  var cellImgVw : UIImageView!
  var celllbltext:UILabel!
  var cellbtnAns : UIButton!
  var cellbtnAddAns : UIButton!
  var celllblAnsBtn:UILabel!
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUIDesign(aParam: NSDictionary){
    
    if(isiPhone5orLower){
      
      celltxtVw = UIView(frame: CGRectMake(20, 10,320-40,60))
      cellImgVw = UIImageView(frame: CGRectMake(10,10, 20, 20))
      cellLine = UIView(frame: CGRectMake(cellImgVw.frame.size.width + cellImgVw.frame.origin.x + 10, cellImgVw.frame.origin.y, 1, cellImgVw.frame.height))
      celllbltext = UILabel(frame: CGRectMake(cellLine.frame.origin.x+10,0,celltxtVw.frame.width-70,celltxtVw.frame.height-20));
      cellbtnAns =  UIButton(frame: CGRectMake(celltxtVw.frame.origin.x,celltxtVw.frame.origin.y+celltxtVw.frame.size.height+10, (celltxtVw.frame.width - 5)/2,30))
      cellbtnAddAns = UIButton(frame: CGRectMake(cellbtnAns.frame.width+25, cellbtnAns.frame.origin.y,cellbtnAns.frame.width,cellbtnAns.frame.height))
      self.setContentProperties(aParam)
    }
    
    if(isiPhone6){
      
      celltxtVw = UIView(frame: CGRectMake(20, 10,375-40,60))
      cellImgVw = UIImageView(frame: CGRectMake(10,10, 20, 20))
      cellLine = UIView(frame: CGRectMake(cellImgVw.frame.size.width + cellImgVw.frame.origin.x + 10, cellImgVw.frame.origin.y, 1, cellImgVw.frame.height))
      celllbltext = UILabel(frame: CGRectMake(cellLine.frame.origin.x+10,0,celltxtVw.frame.width-70,celltxtVw.frame.height-20));
      cellbtnAns =  UIButton(frame: CGRectMake(celltxtVw.frame.origin.x,celltxtVw.frame.origin.y+celltxtVw.frame.size.height+10, (celltxtVw.frame.width - 5)/2,30))
      cellbtnAddAns = UIButton(frame: CGRectMake(cellbtnAns.frame.width+25, cellbtnAns.frame.origin.y,cellbtnAns.frame.width,cellbtnAns.frame.height))
      
      self.setContentProperties(aParam)
    }
    
    if(isiPhone6plus){
      
      celltxtVw = UIView(frame: CGRectMake(20, 10,414-40,60))
      cellImgVw = UIImageView(frame: CGRectMake(10,10, 20, 20))
      cellLine = UIView(frame: CGRectMake(cellImgVw.frame.size.width + cellImgVw.frame.origin.x + 10, cellImgVw.frame.origin.y, 1, cellImgVw.frame.height))
      celllbltext = UILabel(frame: CGRectMake(cellLine.frame.origin.x+10,0,celltxtVw.frame.width-70,celltxtVw.frame.height-20));
      cellbtnAns =  UIButton(frame: CGRectMake(celltxtVw.frame.origin.x,celltxtVw.frame.origin.y+celltxtVw.frame.size.height+10, (celltxtVw.frame.width - 5)/2,30))
      cellbtnAddAns = UIButton(frame: CGRectMake(cellbtnAns.frame.width+25, cellbtnAns.frame.origin.y,cellbtnAns.frame.width,cellbtnAns.frame.height))
      
      self.setContentProperties(aParam)
    }
    
    
  }
  
  
  func setContentProperties(aParam: NSDictionary){
    celltxtVw.layer.borderWidth = 0.38
    celltxtVw.layer.borderColor = UIColor.grayColor().CGColor
    self.contentView.addSubview(celltxtVw)
    
    cellImgVw.backgroundColor = UIColor.grayColor()
    cellImgVw.image = UIImage(named: "Q.png")
    celltxtVw.addSubview(cellImgVw)
    
    cellLine.backgroundColor = UIColor.lightGrayColor()
    celltxtVw.addSubview(cellLine)
    
    celllbltext.numberOfLines = 3
    //celllbltext.backgroundColor = UIColor.yellowColor()
    celllbltext.font = celllbltext.font.fontWithSize(13)
    celllbltext.text = aParam.valueForKey("question") as NSString
    celllbltext.textColor = UIColor.grayColor()
    celltxtVw.addSubview(celllbltext)
    
    cellbtnAns.backgroundColor = UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0,alpha:1.0)
    cellbtnAns.setTitle("Answers", forState: UIControlState.Normal)
    cellbtnAns.setTitleColor(UIColor.darkGrayColor(), forState: UIControlState.Normal)
    cellbtnAns.titleLabel?.font = cellbtnAns.titleLabel?.font.fontWithSize(12)
    self.contentView.addSubview(cellbtnAns)
    
    cellbtnAddAns.backgroundColor = UIColor(red: 71.0/255.0, green: 168.0/255.0, blue: 184.0/255.0,alpha:1.0)
    cellbtnAddAns.setTitle("Add Answer", forState: UIControlState.Normal)
    cellbtnAddAns.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    cellbtnAddAns.titleLabel?.font = cellbtnAddAns.titleLabel?.font.fontWithSize(12)
    self.contentView.addSubview(cellbtnAddAns)
    
  }
  
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
