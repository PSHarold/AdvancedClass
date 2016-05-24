//
//  AttendanceTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AttendanceTableViewController: UITableViewController {
    let courseHelper = TeacherCourseHelper.defaultHelper
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0{
            self.showHudIndeterminate("正在加载")
            self.courseHelper.getAsksForLeave(TeacherCourse.currentCourse){
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
        
        else if indexPath.section == 1{
            if indexPath.row == 0{
                self.courseHelper.getAbsenceStatistics(TeacherCourse.currentCourse){
                    [unowned self]
                    error in
                    if let error = error{
                        self.showError(error)
                    }
                    else{
                        self.hideHud()
                        self.performSegueWithIdentifier("ShowAbsenceStatistics", sender: self)
                    }
                    
                }
            }
        }
    }
}
