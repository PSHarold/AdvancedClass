//
//  TeacherFinishedTestInfoTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/22.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
class TeacherFinishedTestInfoTableViewController: UITableViewController {
    
    weak var test = TeacherTestHelper.defaultHelper.currentTest
    weak var testHelper = TeacherTestHelper.defaultHelper
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2{
            self.testHelper!.getTestResults(self.test!){
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.performSegueWithIdentifier("ShowTestResults", sender: self)
                }
            }
        }
        else if indexPath.section == 3{
            self.testHelper?.getUntakenStudents(self.test!){
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.performSegueWithIdentifier("ShowStudents", sender: self)
                }
            }
        }
    }
    
    

}