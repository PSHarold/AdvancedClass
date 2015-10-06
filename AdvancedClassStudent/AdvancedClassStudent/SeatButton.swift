
//
//  StudentSeatButton.swift
//  SeatView
//
//  Created by Harold on 15/9/8.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import UIKit
class SeatButton: UIButton {
    var miniSeat = UIImageView()
    var _selected:Bool = false
    var _taken:Bool = false
    var _exists:Bool = true
    var row:Int!
    var column:Int!
    
    var exists:Bool{
        get{
            return self._exists
        }
        set{
            self._exists = newValue
            self.miniSeat.hidden = !newValue
            self.hidden = !newValue
            self.enabled = newValue
        }
    }
    
    var checked:Bool{
        get{
            return self._selected
        }
        set{
            
            self._selected = newValue
            if newValue{
                self.setImage(UIImage(named: "checked.png"), forState: .Normal)
                self.miniSeat.image = self.imageView!.image
            }
            else if !self.taken{
                self.setImage(nil, forState: .Normal)
                self.miniSeat.image = nil
            }
        }
    }
    
    var taken:Bool{
        get{
            return self._taken
        }
        set{
            
            self._taken = newValue
            if newValue{
                self.setImage(UIImage(named: "taken.png"), forState: .Normal)
                self.miniSeat.image = self.imageView!.image
            }
            else if !self.checked{
                self.setImage(nil, forState: .Normal)
                self.miniSeat.image = nil
            }
            
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        // self.setImage(nil, forState: UIControlState.Selected)
        self.backgroundColor = UIColor.whiteColor()
        self.miniSeat.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 1.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.setImage(nil, forState: UIControlState.Selected)
        self.backgroundColor = UIColor.whiteColor()
        self.miniSeat.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
    }
}