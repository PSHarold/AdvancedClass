////
////  StudentTestResultsTableViewController.swift
////  AdvancedClassStudent
////
////  Created by Harold on 15/9/20.
////  Copyright © 2015年 Harold. All rights reserved.
////
//
//import UIKit
//import Alamofire
//class StudentTestResultsTableViewController: UITableViewController,UIAlertViewDelegate{
//    var hintLabel: UILabel!
//    var question:Question!
//    var choiceCells = [String:UITableViewCell]()
//    var choiceLabels = [String:UILabel]()
//    var questionCell:UITableViewCell!
//    var questionLabel: UITextView!
//    let testHelper = StudentTestHelper.defaultHelper()
//    var infoCell:UITableViewCell!
//    var difficultyLabel:UILabel!
//    var currentNoLabel:UILabel!
//    var answerDetailText:UITextView!
//    var answerDetailCell:UITableViewCell!
//    let subscriptArray = ["A","B","C","D"]
//    var index = 0
//    var total = 0
//    var myChoice:String!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //self.hintLabel = self.hintCell.contentView.viewWithTag(101) as! UILabel
//        self.questionCell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCell")!
//        self.questionLabel = self.questionCell.contentView.viewWithTag(101) as! UITextView
//        self.infoCell = self.tableView.dequeueReusableCellWithIdentifier("InfoCell")!
//        self.currentNoLabel = self.infoCell.contentView.viewWithTag(102) as! UILabel
//        self.difficultyLabel = self.infoCell.contentView.viewWithTag(101) as! UILabel
//        for sub in self.subscriptArray{
//            self.choiceCells[sub] = self.tableView.dequeueReusableCellWithIdentifier("\(sub)Cell")!
//            self.choiceLabels[sub] = (self.choiceCells[sub]!.contentView.viewWithTag(101) as! UILabel)
//        }
//        self.answerDetailCell = self.tableView.dequeueReusableCellWithIdentifier("AnswerDetailCell")
//        self.answerDetailText = self.answerDetailCell.contentView.viewWithTag(101) as! UITextView
//        self.loadQuestion(self.question)
//    }
//   
//
//    func initWithQuestion(question:Question,myChoice:String,total:Int,index:Int){
//        self.question = question
//        self.myChoice = myChoice
//        self.index = index
//        self.total = total
//    }
//    
//    func clearMakrks(){
//        for (_,cell) in self.choiceCells{
//            cell.accessoryType = .None
//        }
//    }
//    
//    func loadQuestion(question:Question){
//        for sub in self.subscriptArray{
//            self.choiceLabels[sub]!.text = question.choices[sub]!
//        }
//        self.questionLabel.text = question.question
//        self.answerDetailText.text = question.answerDetail
//        self.currentNoLabel.text = "进度：\(self.index)/\(self.total)"
//        self.difficultyLabel.text = "难度：\(question.difficultyString)"
//        var myChoice = 0
//        switch self.myChoice{
//        case "A":
//            myChoice = 0
//        case "B":
//            myChoice = 1
//        case "C":
//            myChoice = 2
//        case "D":
//            myChoice = 3
//        default:
//            myChoice = -1
//        }
//        
//        if myChoice != -1 && myChoice != question.answer{
//            let cell = self.choiceCells[self.subscriptArray[myChoice]]!
//            (cell.contentView.viewWithTag(102) as! UIImageView).image = UIImage(named: "incorrect.png")
//            cell.contentView.layer.borderColor = UIColor(red: 246/255, green: 13/255, blue: 63/255, alpha: 1).CGColor
//            cell.contentView.layer.borderWidth = CGFloat(1)
//        }
//        let cell = self.choiceCells[self.subscriptArray[question.answer]]!
//        (cell.contentView.viewWithTag(102) as! UIImageView).image = UIImage(named: "correct.png")
//        cell.contentView.layer.borderColor = UIColor(red: 39/255, green: 192/255, blue: 173/255, alpha: 1).CGColor
//        cell.contentView.layer.borderWidth = CGFloat(2)
//        self.tableView.reloadData()
//        
//    }
//    
//    
//
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 4
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch section{
//        case 0:
//            return 1
//        case 1:
//            return 1
//        case 2:
//            return 4
//        case 3:
//            return 1
//        default:
//            return 0
//        }
//    }
//    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 3{
//            return "答案解析"
//        }
//        return nil
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        
//        switch indexPath.section{
//        case 0:
//            return self.infoCell
//        case 1:
//            let questionCell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCell")!
//            (questionCell.contentView.subviews[0] as! UITextView).text = self.question.question
//            return self.questionCell
//        case 2:
//            return self.choiceCells[self.subscriptArray[indexPath.row]]!
//        case 3:
//            return self.answerDetailCell
//        default:
//            return UITableViewCell()
//        }
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        switch indexPath.section{
//        case 0:
//            return self.infoCell.bounds.height
//        case 1:
//            return self.questionCell.bounds.height
//        case 2:
//            return self.choiceCells["A"]!.bounds.height
//        default:
//            return self.answerDetailCell!.bounds.height
//        }
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//
//}