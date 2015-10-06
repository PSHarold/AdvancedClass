//
//  TeacherTestInfoTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/10/6.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherTestInfoTableViewController: UITableViewController, TeacherTestHelperDelegate {
    let testHelper = TeacherTestHelper.defaultHelper()
    var deadlineModified = false
    var expireModified = false
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var numberOfStudents: UILabel!
    @IBOutlet weak var expireCell: UITableViewCell!
    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
    @IBOutlet weak var messageText: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    let test = TeacherTestHelper.defaultHelper().testToView
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.testHelper.delegate = self
        self.loadInfo()
        //print(test.finished)
        self.tableView.reloadData()
    }
    
    func loadInfo(){
        self.startTimeLabel.text = self.test.startTime
        self.loadDeadline()
        self.numberOfQuestionsLabel.text = "\(self.test.questionIds.count)"
        self.messageText.text = self.test.message == "" ? "无" : self.test.message
        if self.test.expired{
            self.expireCell.accessoryType = .None
            self.statusLabel.text = "已结束"
            self.continueButton.setTitle("查看结果", forState: .Normal)
        }
        else{
            self.statusLabel.text = "正在进行"
            self.continueButton.setTitle("查看题目", forState: .Normal)
        }
    }
    func loadDeadline(){
        if let date = self.test.deadlineDate{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.deadlineLabel.text = dateFormatter.stringFromDate(date)
        }
        else{
            self.deadlineLabel.text = "无"
        }
    }
    
    func testUploaded() {
        if self.expireModified{
            self.test.deadlineDate = NSDate()
            self.test.expired = true
        }
        self.tableView.reloadData()
        print("DONE!")
    }
    
    func networkError() {
        print("ERROR!")
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.test.expired ? 4 : 5
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if !self.test.expired && indexPath.row == 1{
            self.performSegueWithIdentifier("ShowDateTimePickers", sender: self)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return self.test.expired ? 4 : 3
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 2
        case 5:
            return 2
        default:
            return 0
        }
    }
    @IBAction func submit(sender: AnyObject) {
        self.testHelper.modifyDeadlineWithTest(self.test, date: self.deadlineLabel.text!)
        self.deadlineModified = true
    }
    @IBAction func endTest(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "确定结束测验？", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "取消", style: .Cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "确定", style: .Destructive, handler: {Void in self.testHelper.endTestWithTest(self.test)
            self.expireModified = true}))
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    func allQuestionsAcquiredWithTestId(id: String) {
       
        self.testHelper.getKnowledgePoints(TeacherCourseHelper.defaultHelper().currentCourse.courseId)
    }
    func allKnowledgePointsAcquired() {
        self.performSegueWithIdentifier("ShowQuestionsInTest", sender: self)
    }
    
    @IBAction func showQuestions(sender: AnyObject){
        if self.test.expired{
            self.testHelper.getTestResultsWithTest(test)
        }
        else{
            self.testHelper.getQuestionsWithTest(self.test)
        }
        
    }
    @IBAction func showTestResults(sender: AnyObject) {
        self.performSegueWithIdentifier("ShowResults", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDateTimePickers"{
            let next = segue.destinationViewController as! TestExpirationSettingsTableViewController
            next.test = self.test
        }
        else if segue.identifier == "ShowQuestionsInTest"{
            let next = segue.destinationViewController as! TeacherQuestionsInTestTableViewController
            next.test = self.test
        }
    }
   
}
