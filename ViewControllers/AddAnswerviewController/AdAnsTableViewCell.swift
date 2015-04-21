//
//  AdAnsTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 07/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class AdAnsTableViewCell: UITableViewCell {
  
  var vWcell :UIView!
  var lblAns :UILabel!
  var lblBy :UILabel!
  var lblname :UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func defaultUIDesign(){
    
//    vWcell = UIView(frame: CGRectMake(self.frame.origin.x+10, self.frame.origin.x+10, self.frame.size.width,150))
//    //vWcell.backgroundColor = UIColor.redColor()
//    self.contentView.addSubview(vWcell)
//    
    lblAns = UILabel(frame: CGRectMake(0,20,self.frame.size.width,self.frame.size.height))
    //lblAns.backgroundColor = UIColor.grayColor()
    lblAns.numberOfLines = 0
    lblAns.text = "This is a preliminary document for an API or technology in development. Apple is supplying this information to help you plan for the adoption of the technologies"
    lblAns.textColor = UIColor.grayColor()
    lblAns.font = lblAns.font.fontWithSize(12)
    self.contentView.addSubview(lblAns)
    
    lblBy = UILabel(frame: CGRectMake(self.frame.width-130,80,20, 20))
    lblBy.text = "By-"
    //lblBy.backgroundColor = UIColor.redColor()
    lblBy.textColor = UIColor.grayColor()
    lblBy.font = lblBy.font.fontWithSize(10)
    self.contentView.addSubview(lblBy)
    
    lblname = UILabel(frame: CGRectMake(lblBy.frame.origin.x+lblBy.frame.size.width,lblBy.frame.origin.y,150, 20))
    lblname.text = "preliminary document"
    //lblname.backgroundColor = UIColor.greenColor()
    lblname.textColor = UIColor.blackColor()
    lblname.font = lblBy.font.fontWithSize(10)
    self.contentView.addSubview(lblname)

    
    
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
