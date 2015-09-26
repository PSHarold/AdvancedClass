//
//  TeacherCourseTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherCourseTableViewController: UITableViewController, PreTeacherStudentHelperDelegate {

    var courseHelper = TeacherCourseHelper.defaultHelper()
    var studentHelper = TeacherStudentHelper.defaultHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.studentHelper.preDelegate = self
    }
 

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.courseHelper.courseArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
        cell.textLabel?.text = self.courseHelper.courseArray[indexPath.row].name
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.courseHelper.currentCourse = self.courseHelper.courseArray[indexPath.row]
        self.studentHelper.getAllStudents()
    }
    
    func allStudentsAcquired(){
        self.performSegueWithIdentifier("ShowCourse", sender: self)
    }
    
}
