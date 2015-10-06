//
//  TeacherCreateNotificationTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/10/4.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherCreateNotificationTableViewController: UITableViewController, TeacherCourseHelperDelegate{
    @IBOutlet weak var topCell: UITableViewCell!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    var isCreateMode = true
    let hud = MBProgressHUD()
    var _notification:Notification!
    var formatter:NSDateFormatter!
    var timer:NSTimer!
    let courseHelper = TeacherCourseHelper.defaultHelper()
    let topSwitch = UISwitch()
    var notification:Notification!{
        get{
            return self._notification
        }
        set{
            self._notification = newValue
            self.isCreateMode = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.topCell.accessoryView = self.topSwitch
        if self.isCreateMode{
            self.formatter = NSDateFormatter()
            self.formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            self.timer = NSTimer(timeInterval: 1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
            NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
            return
        }
        
        self.timeLabel.text = self.notification.time
        self.contentText.text = self.notification.content
        self.titleText.text = self.notification.title
        self.topSwitch.on = self.notification.top
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.timer?.invalidate()
    }
    
    func tick(){
        self.timeLabel.text = self.formatter.stringFromDate(NSDate())
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.courseHelper.delegate = self
    }
    
    func networkError(){
        self.hud.mode = .Determinate
        self.hud.labelText = "网络错误！"
        self.hud.hide(true, afterDelay: 1.0)
    }
    
    
    @IBAction func uploadNotification(sender: AnyObject) {
        self.hud.mode = .Indeterminate
        self.hud.labelText = "正在上传"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        if self.isCreateMode{
            self._notification = Notification()
        }
        self._notification.title = self.titleText.text!
        self._notification.time = self.timeLabel.text!
        self._notification.content = self.contentText.text
        self._notification.top = self.topSwitch.on
        self._notification.courseId = self.courseHelper.currentCourse.courseId
        self._notification.subId = self.courseHelper.currentCourse.subId
        if self.isCreateMode{
            self.courseHelper.uploadNotification(self.notification)
        }
        else{
            self.courseHelper.modifyNotifcation(self.notification)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func notificationUploaded() {
        self.notification.top = self.topSwitch.on
        self.hud.mode = .Determinate
        self.hud.labelText = "上传成功！"
        self.hud.hide(true, afterDelay: 0.8)
    }
 
}
