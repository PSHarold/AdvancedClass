//
//  StudentCourseTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentCourseTableViewController: UITableViewController {
    
    var courseHelper = StudentCourseHelper.defaultHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.interactivePopGestureRecognizer?.enabled = false
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.courseHelper.currentCourse = self.courseHelper.courseArray[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ShowCourse", sender: self)
    }
}
