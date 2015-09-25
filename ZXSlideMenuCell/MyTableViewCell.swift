//
//  MyTableViewCell.swift
//  ZXSlideMenuCell
//
//  Created by 葛枝鑫 on 15/9/25.
//  Copyright © 2015年 葛枝鑫. All rights reserved.
//

import UIKit

class MyTableViewCell: ZXSlideMenuCell {
    
    var index: Int?

    @IBOutlet weak var myContentView: UIView!
    @IBOutlet weak var myTitleLabel: UILabel!
    
    @IBOutlet weak var myContentViewLeft: NSLayoutConstraint!
    @IBOutlet weak var myContentViewRight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.zxContentView = self.myContentView
        self.backMenuWidth = 110
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func deleteBtnClicked(sender: UIButton) {
        if let dele = self.delegate as? MyTableViewCellDelegate {
            if dele.respondsToSelector("myTableViewCell:deleteBtnClicked:") == true {
                dele.myTableViewCell!(self, deleteBtnClicked: sender)
            }
        }
    }
    ///必须重写的父类方法
    override func setMyContentViewX(x: CGFloat) {
        self.myContentViewLeft.constant =  x
        self.myContentViewRight.constant = 0 - x
        self.updateConstraints()
        self.layoutIfNeeded()
    }
}

@objc protocol MyTableViewCellDelegate: ZXSlideMenuCellDelegate {
    optional func myTableViewCell(cell: MyTableViewCell, deleteBtnClicked:UIButton)
}
