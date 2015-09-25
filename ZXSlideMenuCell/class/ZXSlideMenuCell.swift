//
//  ZXSlideMenuCell.swift
//  ZXSlideMenuCell
//
//  Created by 葛枝鑫 on 15/9/25.
//  Copyright © 2015年 葛枝鑫. All rights reserved.
//

import UIKit

let ZXSlideMenuCellOpened = "ZXSlideMenuCellOpened"
let ZXSlideMenuCellClosed = "ZXSlideMenuCellClosed"

public class ZXSlideMenuCell: UITableViewCell {

    weak var delegate: ZXSlideMenuCellDelegate?
    var isCellOpened = false
    var backMenuWidth: CGFloat = 150   //子类重新赋值
    private var pan: UIPanGestureRecognizer?
   
    var zxContentView: UIView? {
        didSet{
            if let contentV = zxContentView {
                self.pan = UIPanGestureRecognizer(target: self, action: "pan:")
                self.pan!.delegate = self
                contentV.addGestureRecognizer(self.pan!)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "meunOpened:", name: ZXSlideMenuCellOpened, object: nil)
                NSNotificationCenter.defaultCenter().addObserver(self, selector: "menuClosed:", name: ZXSlideMenuCellClosed, object: nil)
            }
        }
    }

    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    ///子类需要实现此方法，实现contentView实际位置X偏移操作
    func setMyContentViewX(x: CGFloat) {
    }
    
    func pan(gesture:UIPanGestureRecognizer)
    {
        let point = gesture.translationInView(self)
        
        if (point.x > (0 - self.backMenuWidth) && point.x < (self.frame.size.width - self.backMenuWidth) && isCellOpened == false) {
            self.setMyContentViewX(point.x)
        }
        
        if (point.x > 0  && isCellOpened == true) {
            self.setMyContentViewX(point.x - self.backMenuWidth)
        }
        
        if gesture.state == .Ended
        {
            if point.x < -45 {
                self.openMenu()
            } else {
                self.colseMenu()
            }
        }
    }
    
    override public func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isKindOfClass(UIPanGestureRecognizer) {
            let gesture = gestureRecognizer as! UIPanGestureRecognizer
            let point = gesture.translationInView(self)
            let lPont = gesture.locationInView(self)
            
            if (lPont.x < 55 && point.x > 0) {
                return false
            }
            if abs(point.x) - 1 > abs(point.y) {
                return true
            } else {
                return false
            }
        }
        return super.gestureRecognizerShouldBegin(gestureRecognizer)
    }
    
    func colseMenu() {
        self.isCellOpened = false
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.setMyContentViewX(0)
            }, completion: { (finished) -> Void in
                if finished == true {
                    UIView.animateWithDuration(0.15, animations: { () -> Void in
                        self.setMyContentViewX(-15)
                        }, completion: { (finished) -> Void in
                            if finished == true {
                                UIView.animateWithDuration(0.15, animations: { () -> Void in
                                })
                                UIView.animateWithDuration(0.15, animations: { () -> Void in
                                    self.setMyContentViewX(0)
                                    }, completion: { (finished) -> Void in
                                        NSNotificationCenter.defaultCenter().postNotificationName(ZXSlideMenuCellClosed, object: self)
                                        if (nil != self.delegate && self.delegate?.respondsToSelector("slideMenuCellMenuClosed:") != false) {
                                            self.delegate!.slideMenuCellMenuClosed!(self)
                                        }
                                })
                            }
                    })
                }
        })
    }
    
    func openMenu() {
        self.isCellOpened = true
        UIView.animateWithDuration(0.15, animations: { () -> Void in
        })
        UIView.animateWithDuration(0.15, animations: { () -> Void in
            self.setMyContentViewX(-self.backMenuWidth)
            }) { (finished) -> Void in
                if finished == true {
                    NSNotificationCenter.defaultCenter().postNotificationName(ZXSlideMenuCellOpened, object: self)
                    if (nil != self.delegate && self.delegate?.respondsToSelector("slideMenuCellMenuOpened:") != false) {
                        self.delegate!.slideMenuCellMenuOpened!(self)
                    }
                }
        }
    }
    
    //MARK: - 通知响应方法
    func meunOpened(notification: NSNotification) {
        if let cell = notification.object {
            if cell.isKindOfClass(ZXSlideMenuCell) {
                if (cell !== self && self.isCellOpened == true){
                    self.colseMenu()
                }
            }
        }
    }
    
    func menuClosed(postCell: UITableViewCell) {
        
    }
    
    override public func finalize() {
        super.finalize()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ZXSlideMenuCellClosed, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: ZXSlideMenuCellOpened, object: nil)
    }
}

@objc protocol ZXSlideMenuCellDelegate: NSObjectProtocol {
    optional func slideMenuCellMenuClosed(cell: ZXSlideMenuCell)
    optional func slideMenuCellMenuOpened(cell: ZXSlideMenuCell)
}
