//
//  StudentMainViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/29.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentPreTestViewController: UIViewController, StudentTestHelperDelegate{
    var testHelper = StudentTestHelper.defaultHelper()
    var alert = UIAlertView()
    let hud = MBProgressHUD()
    
    override func viewDidLoad() {
        self.testHelper.delegate = self
        self.alert.addButtonWithTitle("确定")
    }
    
    override func viewWillAppear(animated: Bool) {
        self.testHelper.delegate = self
    }
    @IBAction func CheckQuestions(sender: AnyObject) {
        self.hud.mode = .Indeterminate
        self.hud.labelText = "正在加载"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        self.testHelper.getAllTests()

    }
    func allTestsAcquired() {
        self.hud.removeFromSuperview()
        self.performSegueWithIdentifier("ShowTests", sender: self)
    }
    func allQuestionsAcquired() {
       // print(self.helper.tests)
        //performSegueWithIdentifier("hasQuestions", sender: self)
    }
    
    func networkError() {
        self.hud.mode = .Text
        self.hud.labelText = "网络错误！"
        self.hud.show(true)
        self.hud.hide(true, afterDelay: 1.0)
    }
    func noQuestionsOrTest() {
        alert.message = "无测验！"
        alert.show()
    }
}
