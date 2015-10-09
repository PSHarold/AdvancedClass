//
//  StudentPreChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentPreChooseSeatViewController: UIViewController,PreStudentSeatHelperDelegate {
    var seatHelper = StudentSeatHelper.defaultHelper()
    var courseHelper = StudentCourseHelper.defaultHelper()
    let hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seatHelper.preDelegate = self
      
    }
    
    func seatMapAquired() {
        self.hud.removeFromSuperview()
        self.performSegueWithIdentifier("ShowSeats", sender: self)
    }
    
    @IBAction func chooseSeat(sender: AnyObject) {
        self.hud.mode = .Indeterminate
        self.hud.labelText = "正在加载座位列表"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        self.seatHelper.getAllSeatsWithRoomId(self.courseHelper.getCurrentRoomId())
    }
   
    func networkError() {
        self.hud.mode = .Text
        self.hud.labelText = "网络错误！"
        self.hud.show(true)
        self.hud.hide(true, afterDelay: 1.0)
    }

}
