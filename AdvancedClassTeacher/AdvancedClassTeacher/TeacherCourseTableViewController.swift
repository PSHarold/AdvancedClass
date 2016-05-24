//
//  TeacherCourseTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherCourseTableViewController: UITableViewController {
    var first = true
    weak var authHelper = TeacherAuthenticationHelper.defaultHelper
    weak var courseHelper = TeacherCourseHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController!.interactivePopGestureRecognizer?.enabled = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if TeacherAuthenticationHelper.defaultHelper.me.pendingAsks.count != 0{
            self.performSegueWithIdentifier("ShowNewStatusAsks", sender: self)
            self.first = false
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.authHelper!.me.courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = self.authHelper!.me.courses[indexPath.row].name
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        TeacherCourse.currentCourse = self.authHelper!.me.courses[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.courseHelper?.getStudentsInCourse(TeacherCourse.currentCourse){
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
        TeacherCourse.currentCourse = nil
        TeacherSeatHelper.drop()
    
    }
    
}
