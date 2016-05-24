//
//  TableViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/15.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
import Alamofire
class StudentMultipleChoiceTableViewController: StudentBaseQuestionTableViewController,UIAlertViewDelegate{
    var choiceCells = [StudentMultipleChoiceTableViewCell]()
    weak var testHelper = StudentTestHelper.defaultHelper
    weak var currentTest = StudentTestHelper.defaultHelper.currentTest
    var lastChoice: Int?
    var multipleAnswers = false
    var _selectedChoices: [Int]?
    var selectedChoices: [Int]?{
        get{
            if self._selectedChoices != nil{
                return self._selectedChoices
            }
            return self.currentTest?.getMyAnswersWithQuestion(self.question) as? [Int]
        }
        set{
            self._selectedChoices = nil
        }
    }
    
    var resultMode: Bool{
        get{
            return self.currentTest!.finished
        }
    }
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.multipleAnswers = self.question.questionType == .MULTIPLE_CHOICE_MULTIPLE_ANSWERS
        self.tableView.registerClass(StudentMultipleChoiceTableViewCell.self, forCellReuseIdentifier: "ChoiceCell")
        self.tableView.registerClass(StudentQuestionContentTableViewCell.self, forCellReuseIdentifier: "ContentCell")
        let xib = UINib(nibName: "StudentMultipleChoiceTableViewCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "ChoiceCell")
        let xib2 = UINib(nibName: "StudentQuestionContentTableViewCell", bundle: nil)
        self.tableView.registerNib(xib2, forCellReuseIdentifier: "ContentCell")
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.resultMode ? 4 : 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
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
            let tempCell = self.tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as! StudentMultipleChoiceTableViewCell
            if self.selectedChoices != nil && self.selectedChoices!.contains({$0 == indexPath.row+1}){
                tempCell.accessoryType = .Checkmark
            }
            else{
                tempCell.accessoryType = .None
            }
            tempCell.choiceNumber = indexPath.row
            tempCell.content = self.question.choices[indexPath.row]
            cell = tempCell
            // return cell
        case 4:
            let tempCell = self.tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! StudentQuestionContentTableViewCell
            tempCell.content = self.question.detailedAnswer
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if currentTest!.hasTriedPosting{
            return
        }
        if indexPath.section == 2{
            self.selectedChoices = nil
            if self.question.questionType == .MULTIPLE_CHOICE{
                if let choice = self.lastChoice{
                    self.currentTest!.changeMyAnswerWithQuestion(self.question, answer: choice)
                }
                self.lastChoice = self.currentTest!.changeMyAnswerWithQuestion(self.question, answer: indexPath.row+1) as? Int
            }
            else if self.question.questionType == .MULTIPLE_CHOICE_MULTIPLE_ANSWERS{
                self.currentTest!.changeMyAnswerWithQuestion(self.question, answer: indexPath.row+1) as? Int
                
            }
            self.tableView.reloadSections(NSIndexSet(index: 2), withRowAnimation: .None)
            print(self.currentTest!.getMyAnswersWithQuestion(self.question)!)
        }
    }

}
