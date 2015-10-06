//
//  TableViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/15.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
import Alamofire
class StudentQuestionTableViewController: UITableViewController,UIAlertViewDelegate{
    var hintLabel: UILabel!
    var choiceCells = [String:UITableViewCell]()
    var choiceLabels = [String:UILabel]()
    var questionCell:UITableViewCell!
    var questionLabel: UITextView!
    var cellArray = Array<UITableViewCell>()
    var question:Question!
    var hasHint = false
    var lastIndex = -1
    var infoCell:UITableViewCell!
    var timeLabel: UILabel!
    var difficultyLabel:UILabel!
    var currentNoLabel:UILabel!
    var submitCell:UITableViewCell!
    let subscriptArray = ["A","B","C","D"]
    var index = 0
    var total = 0
    var hintCell:UITableViewCell!
    var done = false
    var parentVC:StudentAnswerQuestionsViewController!
    var allowAnswering = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hintCell = self.tableView.dequeueReusableCellWithIdentifier("HintCell")!
        self.hintLabel = self.hintCell.contentView.viewWithTag(101) as! UILabel
        self.questionCell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCell")!
        self.questionLabel = self.questionCell.contentView.viewWithTag(101) as! UITextView
        self.infoCell = self.tableView.dequeueReusableCellWithIdentifier("InfoCell")!
        self.currentNoLabel = self.infoCell.contentView.viewWithTag(102) as! UILabel
        self.difficultyLabel = self.infoCell.contentView.viewWithTag(101) as! UILabel
        for sub in self.subscriptArray{
            self.choiceCells[sub] = self.tableView.dequeueReusableCellWithIdentifier("\(sub)Cell")!
            self.choiceLabels[sub] = (self.choiceCells[sub]!.contentView.viewWithTag(101) as! UILabel)
        }
        //self.submitCell = self.tableView.dequeueReusableCellWithIdentifier("SubmitCell")!
        self.loadQuestion(self.question)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func initWithQuestion(question:Question,hasHint:Bool,total:Int,index:Int){
        self.question = question
        self.hasHint = hasHint
        self.index = index
        self.total = total
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func loadQuestion(question:Question){
        for sub in self.subscriptArray{
            self.choiceLabels[sub]!.text = self.question.choices[sub]!
        }
        self.questionLabel.text = question.question
        self.currentNoLabel.text = "进度：\(self.index)/\(self.total)"
        self.difficultyLabel.text = "难度：\(question.difficultyString)"
        self.lastIndex = -1
        self.tableView.reloadData()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return self.hasHint ? 2 : 1
        case 1:
            return 1
        case 2:
            return 4
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            if self.hasHint{
                if indexPath.row == 1{
                    return self.hintCell
                }
            }
            return self.infoCell
        case 1:
            return self.questionCell
        case 2:
            return self.choiceCells[self.subscriptArray[indexPath.row]]!

        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return self.infoCell.bounds.height
        case 1:
            return self.questionCell.bounds.height
        case 2:
            return self.choiceCells["A"]!.bounds.height
        default:
            return self.choiceCells["A"]!.bounds.height
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if !self.allowAnswering{
            return
        }
        switch indexPath.section{
        case 0:
            if indexPath.row == 1{
                self.hintLabel.text = self.question.knowledgePoint
                self.hintLabel.textColor = UIColor.blackColor()
            }
        case 2:
            let current = indexPath.row
            if(current == lastIndex){
                return
            }
            if lastIndex >= 0{
                self.choiceCells[self.subscriptArray[lastIndex]]!.accessoryType = .None
            }
            self.lastIndex = current
            self.choiceCells[self.subscriptArray[current]]!.accessoryType = .Checkmark
            var tempAnswer = ""
            switch current{
            case 0:
                tempAnswer = "A"
            case 1:
                tempAnswer = "B"
            case 2:
                tempAnswer = "C"
            case 3:
                tempAnswer = "D"
            default:
                assert(true)
            }
            self.question.result["my_choice"] = tempAnswer
            self.question.result["is_correct"] = (current == self.question.answer)
            if !self.done{
                ++(self.parentViewController as! StudentAnswerQuestionsViewController).doneNumber
                self.done = true
            }
           
        default:
            break
        }
        
        
    }

}
