//
//  AttendanceTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AttendanceTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 1{
            self.showHudWithText("正在加载")
            StudentCourseHelper.defaultHelper.getAbsenceList(StudentCourse.currentCourse){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.hideHud()
                    self.performSegueWithIdentifier("ShowAbsence", sender: self)
                }
                
            }
        }
        else if indexPath.section == 0{
            if indexPath.row != 0{
                self.showHudWithText("正在加载")
                StudentCourseHelper.defaultHelper.getAsksForLeave(StudentCourse.currentCourse){
                    [unowned self]
                    error in
                    if let error = error{
                        self.showError(error)
                    }
                    else{
                        self.hideHud()
                        self.performSegueWithIdentifier("ShowAsks", sender: self)
                    }
                    
                }
            }
        }
        
    }
}
