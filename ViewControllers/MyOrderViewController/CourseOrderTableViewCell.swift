//
//  CourseOrderTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 27/05/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class CourseOrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  
  func defaultCellContents(aParam:UserClassOrder,frame:CGRect){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    var vwCell: UIView = UIView(frame: CGRectMake(frame.origin.x+10,10,frame.width-20,80))
    vwCell.layer.borderWidth = 1
    vwCell.layer.borderColor = UIColor.lightGrayColor().CGColor
    contentView.addSubview(vwCell)
    
     var lblPrice: UILabel! = UILabel(frame: CGRectMake(vwCell.frame.width-60,0,50,40))
    lblPrice.text = "$"+"00.0"
    lblPrice.font = lblPrice.font.fontWithSize(18)
    lblPrice.textColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    vwCell.addSubview(lblPrice)
    
    var lblClassName: UILabel! = UILabel(frame: CGRectMake(2, 0,lblPrice.frame.origin.x-5,40))
    lblClassName.text = "Class name"
    lblClassName.font = lblClassName.font.fontWithSize(15)
    lblClassName.textColor = UIColor.lightGrayColor()
    vwCell.addSubview(lblClassName)
    
    var btnNotPay: UIButton = UIButton(frame: CGRectMake(vwCell.frame.width-110,vwCell.frame.height-40,100,30))
    btnNotPay.setTitle("Note Pay", forState:UIControlState.Normal)
    btnNotPay.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    btnNotPay.backgroundColor = UIColor(red: 237.0/255.0, green: 62.0/255.0, blue: 61.0/255.0,alpha:1.0)
    vwCell.addSubview(btnNotPay)
    
    var lblDate: UILabel = UILabel(frame: CGRectMake(5,vwCell.frame.height-40,btnNotPay.frame.origin.x-20,40))
    lblDate.text = "Date"
    lblDate.font = lblClassName.font.fontWithSize(15)
    lblDate.textColor = UIColor.lightGrayColor()
    vwCell.addSubview(lblDate)
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
