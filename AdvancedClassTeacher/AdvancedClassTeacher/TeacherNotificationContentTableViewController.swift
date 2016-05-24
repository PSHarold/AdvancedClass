//
//  TeacherNotificationContentTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/26.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherNotificationContentTableViewController: UITableViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var onTopSwitch: UISwitch!
    @IBOutlet weak var titleTextField: UITextField!
    weak var courseHelper = TeacherCourseHelper.defaultHelper
    var notification: Notification?
    var editMode: Bool{
        get{
            return self.notification != nil
        }
    }
    
    var tempNotification: Notification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.editMode{
            self.contentTextView.text = self.notification!.content
            self.titleTextField.text = self.notification!.title
            self.onTopSwitch.on = self.notification!.onTop
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 3{
            self.tempNotification = Notification()
            self.tempNotification.title = self.titleTextField.text
            self.tempNotification.content = self.contentTextView.text
            self.tempNotification.onTop = self.onTopSwitch.on
            if self.editMode{
                self.tempNotification.notificationId = self.notification!.notificationId
                self.courseHelper!.modifyNotificationInCourse(TeacherCourse.currentCourse, notification: self.tempNotification){
                    [unowned self]
                    error in
                    if let error = error{
                        self.showError(error)
                    }
                    else{
                        self.notification!.content = self.tempNotification.content
                        self.notification!.onTop = self.tempNotification.onTop
                        self.notification!.title = self.tempNotification.title
                        self.showHudText("发布成功！")
                    }
                }
            }
            else{
                
                self.courseHelper!.postNotificationInCourse(TeacherCourse.currentCourse, notification: self.tempNotification){
                    [unowned self]
                    error in
                    if let error = error{
                        self.showError(error)
                    }
                    else{
                        self.showHudText("发布成功！")
                    }
                }
            }
        }
    }
    
}
