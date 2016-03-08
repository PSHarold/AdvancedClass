////
////  TeacherPreSeatViewController.swift
////  AdvancedClassTeacher
////
////  Created by Harold on 15/9/17.
////  Copyright (c) 2015年 Harold. All rights reserved.
////
//
//import UIKit
//
//class TeacherPreSeatViewController: UIViewController, PreTeacherSeatHelperDelegate {
//    
//    var seatHelper = TeacherSeatHelper.defaultHelper()
//    var courseHelper = TeacherCourseHelper.defaultHelper()
//    let hud = MBProgressHUD()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.seatHelper.preDelegate = self
//        
//    }
//    func networkError() {
//        //self.hud.removeFromSuperview()
//        hud.mode = MBProgressHUDMode.Text
//        hud.labelText = "网络错误！"
//        //self.view.addSubview(self.hud)
//        //hud.show(true)
//        hud.hide(true, afterDelay: 1.2)
//    }
//
//    
//    func seatMapAquired() {
//        self.hud.removeFromSuperview()
//        performSegueWithIdentifier("ShowSeats", sender: self)
//    }
//    
//    @IBAction func viewSeats(sender: AnyObject) {
//        
//        self.hud.mode = .Indeterminate
//        self.hud.labelText = "正在获取座位列表"
//        self.view.addSubview(self.hud)
//        self.hud.show(true)
//        self.seatHelper.getAllSeatsWithRoomId(self.courseHelper.getCurrentRoomId())
//    }
//
//}
