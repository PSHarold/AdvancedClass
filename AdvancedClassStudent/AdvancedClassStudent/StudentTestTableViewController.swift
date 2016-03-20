//
//  StudentTestTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/3.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentTestTableViewController: UITableViewController {

    weak var testHelper = StudentTestHelper.defaultHelper
    weak var currentCourse = StudentCourse.currentCourse
    var selectedTest: StudentTest!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
 
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCourse!.unfinishedTests.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)
        cell.textLabel?.text = "1"
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let test = self.currentCourse!.unfinishedTests[indexPath.row]
        self.selectedTest = test
        self.testHelper!.getQuestionsInTest(test){
            error in
            if let error = error{
                self.showError(error)
                return
            }
            self.performSegueWithIdentifier("TakeTest", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as! StudentAnswerQuestionsViewController
        vc.test = self.selectedTest
    }
    
}
