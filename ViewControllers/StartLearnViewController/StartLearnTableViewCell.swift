//
//  StartLearnTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 16/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class StartLearnTableViewCell: BaseTableViewCell {
  
  var imgVw: UIImageView!
  var lblTilte: UILabel!
  var names: NSArray!
  var images: NSArray!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
  
  func defaultCellContent(dict : NSDictionary, index:NSInteger){
    
    println(dict)

    
    imgVw = UIImageView(frame: CGRectMake(0,20, 30, 30))
    imgVw.image = UIImage(named: dict.objectForKey("image") as NSString)
    self.contentView.addSubview(imgVw)
    
    lblTilte = UILabel(frame: CGRectMake(imgVw.frame.origin.x+imgVw.frame.width+10,imgVw.frame.origin.y-5,200, 40))
    lblTilte.text = dict.objectForKey("name") as NSString
    //lblTilte.textAlignment = NSTextAlignment.Center
    //lblTilte.backgroundColor = UIColor.redColor()
    lblTilte.textColor = UIColor.darkGrayColor()
    lblTilte.font = lblTilte.font.fontWithSize(12)
    self.contentView.addSubview(lblTilte)
    
    if(index == 2){
      var lbldiscount: UILabel! = UILabel()
      if(isiPhone5orLower){
           lbldiscount.frame = CGRectMake(320-90, 20, 20, 20)
        }else if(isiPhone6){
           lbldiscount.frame = CGRectMake(375-90, 20, 20, 20)
      }else if(isiPhone6plus){
          lbldiscount.frame = CGRectMake(414-90, 20, 20, 20)
      }
      
      lbldiscount.text = NSString(format: "%i",(dict.objectForKey("count")?.integerValue)!)
      lbldiscount.textAlignment = NSTextAlignment.Center
      //lbldiscount.backgroundColor = UIColor.redColor()
      lbldiscount.textColor = UIColor.darkGrayColor()
      lbldiscount.font = lbldiscount.font.fontWithSize(12)
      self.contentView.addSubview(lbldiscount)

      
    }
    
  }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
