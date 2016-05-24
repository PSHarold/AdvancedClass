//
//  StudentMainViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/29.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentPreTestViewController: UIViewController{
    
    
    @IBAction func takeTest(sender: AnyObject) {
        let course = StudentCourse.currentCourse
        let testHelper = StudentTestHelper.defaultHelper
        testHelper.getUnfinishedTestsInCourse(course){
            error in
            if let error = error{
                self.showError(error)
            }
            self.performSegueWithIdentifier("ShowTests", sender: nil)
        }
    }
    
    
    
}
