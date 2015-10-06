//
//  TeacherMainViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/29.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherPreTestViewController: UIViewController, TeacherTestHelperDelegate{
    var testHelper = TeacherTestHelper.defaultHelper()
    var alert = UIAlertView()
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alert.addButtonWithTitle("确定")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        self.testHelper.delegate = self
    }
    
    //点击获取题目按钮
    @IBAction func getAllTests(sender: AnyObject) {
        self.hud.labelText = "获取中"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        self.testHelper.getAllTests()
    }
    
    
    
    func networkError() {
        self.hud.mode = MBProgressHUDMode.Text
        self.hud.labelText = "网络错误！"
        self.hud.hide(true, afterDelay: 1.2)
    }
    func noQuestionsOrTest() {
        performSegueWithIdentifier("ShowTests", sender: self)

    }
    
    func allTestsAcquired() {
        self.hud.removeFromSuperview()
        performSegueWithIdentifier("ShowTests", sender: self)
    }

}
