//
//  SettingTableViewCell.swift
//  Tonguer
//
//  Created by GrepRuby on 21/04/15.
//  Copyright (c) 2015 GrepRuby3. All rights reserved.
//

import UIKit

class SettingTableViewCell:BaseTableViewCell {
  
  var lbltitle: UILabel!
  var vWCell: UIView!
  var swtRemind: UISwitch!
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  func defaultUICellContent(name: NSString , index: NSInteger,frame:CGRect){
    
    var arry = self.contentView.subviews
    var vwSub: UIView!
    for vwSub in arry {
      vwSub.removeFromSuperview()
    }
    
    vWCell = UIView(frame: CGRectMake(20,10,frame.width-50,60))
    vWCell.layer.borderWidth = 0.5
    vWCell.layer.borderColor = UIColor.lightGrayColor().CGColor
    self.contentView.addSubview(vWCell)
    
    lbltitle = UILabel(frame: CGRectMake(5,5,200,50))
    lbltitle.text = name
    lbltitle.font = lbltitle.font.fontWithSize(15)
    //lbltitle.backgroundColor = UIColor.redColor()
    vWCell.addSubview(lbltitle)

    swtRemind = UISwitch(frame: CGRectMake(vWCell.frame.width - 40,25, 30,30))
    
    if(index == 1){
      self.contentView.addSubview(swtRemind)
    }
    
    if(index == 0){
//      var defaults=NSUserDefaults()
//      var fileSize=defaults.integerForKey("downloadedData")
      
      let arry = DownloadedData.MR_findAll() as NSArray
      var lblFileSize: UILabel = UILabel(frame: CGRectMake(vWCell.frame.width-150,15,150,30))
      lblFileSize.textAlignment = NSTextAlignment.Center
      lblFileSize.font = lbltitle.font.fontWithSize(15)
      lblFileSize.text = "0 KB"
      vWCell.addSubview(lblFileSize)

      if (arry.count > 0) {
        var obj = arry.objectAtIndex(0) as DownloadedData
        var data = obj.download_data.doubleValue
        var dataKB = data/1024
        var dataMB = dataKB/1024
        var str: NSString = NSString(format: "%.2f",dataMB)
        lblFileSize.text = str+" MB"
        //lblFileSize.backgroundColor = UIColor.redColor()
      }
    }
  }
  
  
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
}
