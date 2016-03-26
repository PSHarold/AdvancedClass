//
//  TeacherTestResultStudentsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/25.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherTestResultStudentsTableViewController: UITableViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    weak var courseHelper = TeacherTestHelper.defaultHelper
    weak var test = TeacherTestHelper.defaultHelper.currentTest
    var showTaken: Bool{
        get{
            return self.segmentedControl.selectedSegmentIndex == 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.showTaken{
            return self.test!.finishedStudents.count
        }
        else{
            return self.test!.unfinishedStudents.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        var student: Student
        if self.showTaken{
            student = TeacherCourse.currentCourse.students[self.test!.finishedStudents[indexPath.row]]!
            
        }
        else{
            student = TeacherCourse.currentCourse.students[self.test!.unfinishedStudents[indexPath.row]]!
        }
        cell.textLabel?.text = student.name
        cell.detailTextLabel?.text = student.className + " " + student.studentId
        return cell
    }
    
   
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

}
