//
//  ManualCheckInTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/5/29.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class ManualCheckInStudentTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

   
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeacherCourse.currentCourse.studentDict.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let studentId = TeacherCourse.currentCourse.studentIds[indexPath.row]
        let student = TeacherCourse.currentCourse.studentDict[studentId]!
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = student.studentId
        cell.detailTextLabel?.text = student.name + " " + student.className
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
