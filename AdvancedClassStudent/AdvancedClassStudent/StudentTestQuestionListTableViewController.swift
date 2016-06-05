//
//  StudentTestQuestionListTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/3/21.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentTestQuestionListTableViewController: UITableViewController {
    
    weak var answerVC: StudentAnswerQuestionsViewController!
    weak var resultVC: StudentTestResultsViewController!
    weak var test = StudentTestHelper.defaultHelper.currentTest
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override var preferredContentSize: CGSize{
        get{
            return self.tableView.frame.size
        }
        set{
            var size = newValue
            if size.width > 0.5 * UIScreen.mainScreen().bounds.width{
                size.width = 0.5 * UIScreen.mainScreen().bounds.width
            }
            if size.height > 0.8 * UIScreen.mainScreen().bounds.height{
                size.height = 0.8 * UIScreen.mainScreen().bounds.height
            }
            self.tableView.frame.size = size
            super.preferredContentSize = size
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.test!.questionNum
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell") ?? UITableViewCell(style: .Value1, reuseIdentifier: "cell"
        )
        
        
        cell.textLabel?.text = "第\(indexPath.row+1)题"
        let question = self.test!.questions[indexPath.row]
        
        if self.test!.taken{
            let result = self.test!.results[question.questionId]
            cell.detailTextLabel?.text = result!.correctType.description
            switch result!.correctType {
            case .halfCorrect:
                cell.detailTextLabel?.textColor = UIColor.orangeColor()
            case .wrong:
                cell.detailTextLabel?.textColor = UIColor.redColor()
            case .totallyCorrect:
                cell.detailTextLabel?.textColor = UIColor.greenColor()
            case .noAnswer:
                cell.detailTextLabel?.textColor = UIColor.blackColor()
            }
        }
        else{
            if self.test!.hasAnsweredQuestion(question){
                cell.detailTextLabel?.text = "已作答"
                cell.detailTextLabel?.textColor = UIColor.greenColor()
            }
            else{
                cell.detailTextLabel?.text = "未作答"
                cell.detailTextLabel?.textColor = UIColor.lightGrayColor()
            }
            
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.test!.taken{
            self.resultVC.dismissViewControllerAnimated(true, completion: nil)
            self.resultVC.scrollToPage(indexPath.row, invokedByScroll: false)
        }
        else{
            self.answerVC.dismissViewControllerAnimated(true, completion: nil)
            self.answerVC.scrollToPage(indexPath.row, invokedByScroll: false)
        }
    }
}
