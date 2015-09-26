
//
//  TeacherLoginViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherLoginViewController: UIViewController,TeacherAuthenticationHelperDelegate,TeacherCourseHelperDelegate {
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var courseHelper = TeacherCourseHelper.defaultHelper()
    let hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.authHelper.delegate = self
        self.courseHelper.delegate = self
    }


    @IBAction func LoginIn(sender: AnyObject) {
        self.authHelper.login("B0000000",pass: "")
        hud.mode = MBProgressHUDMode.Indeterminate
        self.hud.labelText = "登录中"
        self.view.addSubview(self.hud)
        self.hud.show(true)
    }
    
    func networkError() {
        //self.hud.removeFromSuperview()
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = "网络错误！"
        self.view.addSubview(self.hud)
        //hud.show(true)
        //延迟隐藏
        hud.hide(true, afterDelay: 1.2)
        
    }
    
    func allCoursesRequired() {
        self.hud.removeFromSuperview()
        performSegueWithIdentifier("LoggedIn", sender: self)
    }
    
    
    func loggedIn(){
        //self.hud.removeFromSuperview()
        //hud.mode = MBProgressHUDMode.Text
        hud.labelText = "加载课程"
        self.view.addSubview(self.hud)
        hud.show(true)
        //延迟隐藏
        hud.hide(true, afterDelay: 0.8)
        self.courseHelper.getAllCourses()
    }

}
