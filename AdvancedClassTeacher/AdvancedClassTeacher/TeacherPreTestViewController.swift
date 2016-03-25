//
//  TeacherMainViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/29.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherPreTestViewController: UIViewController {
     
    weak var currentCourse = TeacherCourse.currentCourse
    weak var courseHelper = TeacherCourseHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }

    
    //点击获取题目按钮
    @IBAction func getAllTests(sender: AnyObject) {
        self.courseHelper!.getSyllabus(self.currentCourse!){
            [unowned self]
            _ in
            self.performSegueWithIdentifier("ShowPoints", sender: self)
            
        }
    }
    
    
    
}
