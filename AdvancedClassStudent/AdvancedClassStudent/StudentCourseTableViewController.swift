//
//  StudentCourseTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentCourseTableViewController: UITableViewController {
    
    var courseHelper = StudentCourseHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentAuthenticationHelper.defaultHelper.me.courses.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)

        cell.textLabel?.text = StudentAuthenticationHelper.defaultHelper.me.courses[indexPath.row].name

        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        StudentCourse.currentCourse = StudentAuthenticationHelper.defaultHelper.me.courses[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.courseHelper?.getCourseDetails(StudentCourse.currentCourse){
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
                return
            }
            self.performSegueWithIdentifier("enterMain", sender: self)
        }

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowNotifications"{
            
        }
    }
    
    @IBAction func unwindToCourseTable(segue: UIStoryboardSegue) {
        StudentCourse.currentCourse = nil
        StudentSeatHelper.drop()
        //StudentCourseHelper.drop()
    }
}
