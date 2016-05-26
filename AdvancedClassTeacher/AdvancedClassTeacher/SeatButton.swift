
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
    var row:Int!
    var column:Int!
    private var _avatar: UIImage?
    var avatar: UIImage?{
        get{
            return self._avatar
        }
        set{
            self._avatar = newValue
            self.setImage(self._avatar, forState: .Normal)
        }
    }
    
    var status: SeatStatus{
        didSet{
            switch status{
            case .Empty:
                self.setImage(nil, forState: .Normal)
                self.miniSeat.image = nil
            case .Taken:
                self.setImage(UIImage(named: "taken.png"), forState: .Normal)
                self.miniSeat.image = self.imageView!.image
            case .Checked:
                self.setImage(UIImage(named: "checked.png"), forState: .Normal)
                self.miniSeat.image = self.imageView!.image
            case .Broken:
                self.setImage(UIImage(named: "checked.png"), forState: .Normal)
                self.miniSeat.image = self.imageView!.image
            case .NONEXISTENT:
                self.hidden = true
                self.miniSeat.hidden = true
            }
        }
    }
    
        
    
    override init(frame: CGRect) {
        self.status = .Empty
        super.init(frame:frame)
        self.backgroundColor = UIColor.whiteColor()
        self.miniSeat.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 1.0
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.status = .Empty
        super.init(coder: aDecoder)
        //self.setImage(nil, forState: UIControlState.Selected)
        self.backgroundColor = UIColor.whiteColor()
        self.miniSeat.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
       
    }
}