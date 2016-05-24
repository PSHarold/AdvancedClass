//
//  TeacherNotificationContentTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/26.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentNotificationContentTableViewController: UITableViewController {
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var titleTextField: UITextField!
    var notification: Notification?
    
    var tempNotification: Notification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentTextView.text = self.notification!.content
        self.titleTextField.text = self.notification!.title
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
