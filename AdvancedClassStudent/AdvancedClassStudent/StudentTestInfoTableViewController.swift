////
////  StudentTestInfoTableViewController.swift
////  AdvancedClassStudent
////
////  Created by Harold on 15/10/5.
////  Copyright © 2015年 Harold. All rights reserved.
////
//
//import UIKit
//
//class StudentTestInfoTableViewController: UITableViewController, StudentTestHelperDelegate {
//
//    @IBOutlet weak var startTimeLabel: UILabel!
//    @IBOutlet weak var deadlineLabel: UILabel!
//    @IBOutlet weak var statusLabel: UILabel!
//    @IBOutlet weak var numberOfQuestionsLabel: UILabel!
//    @IBOutlet weak var correctRateLabel: UILabel!
//    @IBOutlet weak var messageLabel: UILabel!
//    @IBOutlet weak var continueButton: UIButton!
//    let testHelper = StudentTestHelper.defaultHelper()
//    let test = StudentTestHelper.defaultHelper().testToView
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.loadInfo()
//        self.testHelper.delegate = self
//        //print(test.finished)
//        self.tableView.reloadData()
//    }
//    
//    func loadInfo(){
//        self.startTimeLabel.text = self.test.startTime
//        self.deadlineLabel.text = self.test.deadline == "" ? "无" : self.test.deadline
//        self.numberOfQuestionsLabel.text = "\(self.test.questionIds.count)"
//        self.messageLabel.text = self.test.message == "" ? "无" : self.test.message
//        if self.test.finished{
//            var correctNumber = 0
//            for question in self.test.questionArray{
//                if question.result["is_correct"]! as! Bool{
//                    ++correctNumber
//                }
//            }
//            self.correctRateLabel.text = "\(correctNumber)/\(self.numberOfQuestionsLabel.text!)"
//        }
//        self.continueButton.setTitle(self.test.finished ? "查看结果" : "开始测验", forState: .Normal)
//        self.statusLabel.text = self.test.finished ? "已完成" :  self.test.expired ? "已截止" : "未完成"
//    }
//    
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section{
//        case 0:
//            return 3
//        case 1:
//            return self.test.finished ? 2 : 1
//        case 2:
//            return 1
//        case 3:
//            if self.test.expired && !self.test.finished{
//                return 0
//            }
//            else {
//                return 1
//            }
//        default:
//            return 0
//        }
//    }
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 4
//    }
//    
//    func networkError() {
//        
//    }
//    func allQuestionsAcquired() {
//        if self.test.finished{
//            for (id,question) in self.test.results{
//                test.questions[id]!.result["my_choice"] = test.results[id]!
//            }
//        }
//        self.performSegueWithIdentifier(self.test.finished ? "ShowTestResults" : "TakeTest", sender: self)
//    }
//    
//    @IBAction func showTest(sender: AnyObject) {
//        self.testHelper.getQuestionsWithTest(self.test)
//        
//    }
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//    
//    
//     
//}
