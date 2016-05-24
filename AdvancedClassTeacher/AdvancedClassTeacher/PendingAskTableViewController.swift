//
//  PendingAskTableViewController.swift
//  Face-Teacher
//
//  Created by Harold on 16/4/17.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class PendingAskTableViewController: UITableViewController {
    var courseHelper: TeacherCourseHelper!
    var ask: AskForLeave!

    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var askTimeLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var studentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.courseHelper = TeacherCourseHelper.defaultHelper
        self.createdAtLabel.text = self.ask.createdAt
        self.reasonTextView.text = self.ask.reason
        self.askTimeLabel.text = "第\(self.ask.weekNo)周 周\(self.ask.dayNo) 第\(self.ask.periodNo)节"
        let studentId = self.ask.studentId
        let student = TeacherCourse.currentCourse?.studentDict[studentId]
        self.studentLabel.text = studentId +  " " + (student?.name ?? "")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2{
            self.courseHelper.approveAskForLeave(TeacherAuthenticationHelper.defaultHelper.me.courseDict[ask.courseId]!, askForLeave: self.ask){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    let me = TeacherAuthenticationHelper.defaultHelper.me
                    if let index = me.pendingAsks.indexOf({$0 === self.ask}){
                        me.pendingAsks.removeAtIndex(index)
                    }
                    
                    let alert = UIAlertController(title: nil, message: "操作成功！", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: {_ in self.navigationController?.popViewControllerAnimated(true)}))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
        }
        else if indexPath.section == 3{
            self.courseHelper.disapproveAskForLeave(TeacherAuthenticationHelper.defaultHelper.me.courseDict[ask.courseId]!, askForLeave: self.ask){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    let me = TeacherAuthenticationHelper.defaultHelper.me
                    if let index = me.pendingAsks.indexOf({$0 === self.ask}){
                        me.pendingAsks.removeAtIndex(index)
                    }
                    let alert = UIAlertController(title: nil, message: "操作成功！", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: {_ in self.navigationController?.popViewControllerAnimated(true)}))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }

        }
    }
}
