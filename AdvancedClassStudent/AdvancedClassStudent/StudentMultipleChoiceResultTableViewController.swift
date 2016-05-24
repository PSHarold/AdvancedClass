//
//  StudentMultipleChoiceResultTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/3/31.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentMultipleChoiceResultTableViewController: StudentBaseQuestionTableViewController {
    var choiceCells = [StudentMultipleChoiceTableViewCell]()
    weak var testHelper = StudentTestHelper.defaultHelper
    weak var currentTest = StudentTestHelper.defaultHelper.currentTest
    var lastChoice: Int?
    var multipleAnswers = false
    var myChoices: [String]{
        get{
            return self.currentTest!.results[question.questionId]!.myAnswers
        }
    }
    var answers: [String]{
        get{
            return self.currentTest!.results[question.questionId]!.answers
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.multipleAnswers = self.question.questionType == .MULTIPLE_CHOICE_MULTIPLE_ANSWERS
        self.tableView.registerClass(StudentMultipleChoiceResultTableViewCell.self, forCellReuseIdentifier: "ChoiceCell")
        self.tableView.registerClass(StudentQuestionContentTableViewCell.self, forCellReuseIdentifier: "ContentCell")
        let xib = UINib(nibName: "StudentMultipleChoiceResultTableViewCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "ChoiceCell")
        let xib2 = UINib(nibName: "StudentQuestionContentTableViewCell", bundle: nil)
        self.tableView.registerNib(xib2, forCellReuseIdentifier: "ContentCell")
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var cell: UITableViewCell
        switch indexPath.section{
        case 0:
            let tempCell = UITableViewCell(style: .Value1, reuseIdentifier: "InfoCell")
            cell = tempCell
            cell.textLabel?.text = "难度: " + self.question.difficultyString
            cell.detailTextLabel?.textColor = UIColor.blackColor()
            cell.detailTextLabel?.text = "进度: \(self.page+1)/\(self.currentTest!.questionNum)"
        // return cell
        case 1:
            let tempCell = self.tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! StudentQuestionContentTableViewCell
            tempCell.content = self.question.content
            cell = tempCell
        // return cell
        case 2:
            let tempCell = self.tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as! StudentMultipleChoiceResultTableViewCell
            tempCell.choiceNumber = indexPath.row
            if self.myChoices.contains({$0 == String(indexPath.row+1)}){
                tempCell.isMyChoice = true
                if self.answers.contains({$0 == String(indexPath.row+1)}){
                    tempCell.correct = true
                }
                else{
                    tempCell.correct = false
                }
            }
            else{
                tempCell.isMyChoice = false
                if self.answers.contains({$0 == String(indexPath.row+1)}){
                    tempCell.correct = true
                }
            }
            
            tempCell.content = self.question.choices[indexPath.row]
            cell = tempCell
        // return cell
        case 4:
            let tempCell = self.tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! StudentQuestionContentTableViewCell
            tempCell.content = self.question.detailedAnswer == "" ? "无" : self.question.detailedAnswer
            cell = tempCell
        default:
            return UITableViewCell()
        }
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return self.question.choices.count
        }
        else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 44.0
        }
        if indexPath.section == 1{
            return 200
        }
        return 55
    }
    
}
