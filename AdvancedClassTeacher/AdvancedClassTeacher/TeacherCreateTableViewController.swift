//
//  TableViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/15.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
import Alamofire

protocol KnowledgePointsDelegate{
    func setKnowledgePoints(indexPath:NSIndexPath)
}



class TeacherCreateTableViewController: UITableViewController,TeacherTestHelperDelegate,KnowledgePointsDelegate{
    var hintLabel: UILabel!
    var question:Question!
    var choiceCells = [String:UITableViewCell]()
    var choiceLabels = [String:UITextField]()
    var questionCell:UITableViewCell!
    var questionLabel: UITextView!
    var chapterCell:UITableViewCell!
    var answerDetailText:UITextView!
    var answerDetailCell:UITableViewCell!
    let subscriptArray = ["A","B","C","D"]
    
    var _chapterNo = -1
    var _selectedKnowledgePointNo = -1
    var _lastIndex = -1
    let testHelper = TeacherTestHelper.defaultHelper()
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var courseHelper = TeacherCourseHelper.defaultHelper()
    var isCreateMode = true
    var difficultyCell:UITableViewCell!
    var chapterLabel:UILabel!
    var knowledgePointLabel:UILabel!
    var lastIndex:Int{
        get{
            return self._lastIndex
        }
        set{
            self._lastIndex = newValue
            self.question?.answer = newValue
        }
    }
    
    var chapterNo:Int{
        get{
            return self._chapterNo
        }
        set{
            if newValue == -1{
                self.chapterLabel?.text = " "
                self.knowledgePointLabel?.text = " "
            }
            self._chapterNo = newValue
            self.question?.chapter = newValue
        }
    }
    
    var selectedKnowledgePointNo:Int{
        get{
            return self._selectedKnowledgePointNo
        }
        set{
            self._selectedKnowledgePointNo = newValue
            self.question?.knowledgePoint = self.testHelper.knowledgePoints.chaptersDict["\(self.chapterNo)"]!.points[newValue]
        }
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionCell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCell")!
        self.questionLabel = self.questionCell.contentView.viewWithTag(101) as! UITextView
        self.difficultyCell = self.tableView.dequeueReusableCellWithIdentifier("DifficultyCell")!
        self.difficultyCell.detailTextLabel!.text = " "
        for sub in self.subscriptArray{
            self.choiceCells[sub] = self.tableView.dequeueReusableCellWithIdentifier("\(sub)Cell")!
            self.choiceLabels[sub] = (self.choiceCells[sub]!.contentView.viewWithTag(101) as! UITextField)
        }
        self.answerDetailCell = self.tableView.dequeueReusableCellWithIdentifier("AnswerDetailCell")
        self.answerDetailText = self.answerDetailCell.contentView.viewWithTag(101) as! UITextView
        self.chapterCell = self.tableView.dequeueReusableCellWithIdentifier("ChapterCell")!
        self.chapterLabel = self.chapterCell.contentView.viewWithTag(101) as! UILabel
        self.knowledgePointLabel = self.chapterCell.contentView.viewWithTag(102) as! UILabel
        self.isCreateMode = (self.question == nil)
        if self.isCreateMode{
            self.question = Question()
        }
        else{
            self.loadQuestion(self.question)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        self.testHelper.delegate = self
    }
    
    func hasEmpty() -> Bool{
        for sub in self.subscriptArray{
            if self.choiceLabels[sub]!.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" {
                return true
            }
        }
        return self.questionLabel.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == "" || self.answerDetailText.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == ""
            
    }

    func loadQuestion(question:Question){
        self.questionLabel.text = question.question
        for sub in self.subscriptArray{
            self.choiceLabels[sub]!.text = self.question.choices[sub]!
        }
        self.chapterNo = question.chapter
        self.chapterLabel.text = "第\(self.chapterNo)章"
        self.knowledgePointLabel.text =  "\(question.knowledgePoint)"
        self.answerDetailText.text = question.answerDetail
        for var i = 0;i < self.testHelper.knowledgePoints.chaptersDict["\(self.chapterNo)"]!.points.count;++i{
            if self.testHelper.knowledgePoints.chaptersDict["\(self.chapterNo)"]!.points[i] == question.knowledgePoint{
                self.selectedKnowledgePointNo = i
            }
        }
        self.setDifficulty(question.difficultyInt)
        self.lastIndex = question.answer
        self.choiceCells[self.subscriptArray[question.answer]]!.accessoryType = .Checkmark
    }

    
    
        
    func allResigneFirstResponder(){
        self.questionLabel.resignFirstResponder()
        self.answerDetailText.resignFirstResponder()
        for (_,field) in self.choiceLabels{
            field.resignFirstResponder()
        }
    }
    
    
    
    func clearMakrks(){
        lastIndex = -1
        for (_,cell) in self.choiceCells{
            cell.accessoryType = .None
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.testHelper.delegate = self
    }
    
    func setDifficulty(difficulty:Int){
        self.question.difficultyInt = difficulty
        switch difficulty{
        case 0:
            self.difficultyCell.detailTextLabel!.text = "简单"
        case 1:
            self.difficultyCell.detailTextLabel!.text = "中等"
        case 2:
            self.difficultyCell.detailTextLabel!.text = "困难"
        default:
            break
        }
        
    }
    func getAlertControllerWithMessage(message:String) -> UIAlertController{
        let alertController = UIAlertController(title: nil, message: "", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
        alertController.message = message
        return alertController
    }
    func uploadQuestion() {
        if lastIndex == -1{
            let alertController = self.getAlertControllerWithMessage("请选择答案！")
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if self.chapterNo == -1 || self.selectedKnowledgePointNo == -1{
            let alertController = self.getAlertControllerWithMessage("请选择知识点！")
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if self.hasEmpty(){
            let alertController = self.getAlertControllerWithMessage("请填写完整！")
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        if self.question.difficultyInt == -1{
            let alertController = self.getAlertControllerWithMessage("请选择难度！")
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        self.question.courseId = self.courseHelper.currentCourse.courseId
        self.question.answer = self.lastIndex
        for sub in self.subscriptArray{
            question.choices[sub] = self.choiceLabels[sub]!.text
        }
        self.question.question = self.questionLabel.text
        self.question.answerDetail = self.answerDetailText.text
        
        if self.isCreateMode{
           self.testHelper.uploadQuestion(self.question)
        }
        else{
            self.testHelper.modifyQuestion(self.question)
        }
        
    }
   
    func questionUploaded() {
        self.presentViewController(self.getAlertControllerWithMessage("上传成功"), animated: true, completion: nil)
        if self.isCreateMode{
            self.clear()
        }

    }
    func networkError(){
        self.presentViewController(self.getAlertControllerWithMessage("网络错误"), animated: true, completion: nil)    }
    
    func clear(){
        self.allResigneFirstResponder()
        self.clearMakrks()
        self.answerDetailText.text = ""
        for (_,field) in self.choiceLabels{
            field.text = ""
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.allResigneFirstResponder()
        if indexPath.section == 1 {
            let current = indexPath.row
            if(current == lastIndex){
                return
            }
            if lastIndex >= 0{
                self.choiceCells[self.subscriptArray[lastIndex]]!.accessoryType = .None
            }
            lastIndex = current
            self.choiceCells[self.subscriptArray[lastIndex]]!.accessoryType = .Checkmark
            return
            
        }
        
        if indexPath.section == 2{
            if indexPath.row == 0{
                self.performSegueWithIdentifier("ShowKnowledgePoints", sender: self)
            }
            else{
                let alertController = UIAlertController(title: nil, message: "请选择难度", preferredStyle: .ActionSheet)
                alertController.addAction(UIAlertAction(title: "简单", style: UIAlertActionStyle.Default, handler: {Void in self.setDifficulty(0)}))
                alertController.addAction(UIAlertAction(title: "中等", style: UIAlertActionStyle.Default, handler: {Void in self.setDifficulty(1)}))
                alertController.addAction(UIAlertAction(title: "困难", style: UIAlertActionStyle.Default, handler: {Void in self.setDifficulty(2)}))
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            return
        }
        
        if indexPath.section == 4{
            if indexPath.row == 0{
                self.uploadQuestion()
            }
            else{
                self.clear()
            }
        }
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 5
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return 1
        case 1:
            return 4
        case 2:
            return 2
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.section{
        case 0:
            return self.questionCell
        case 1:
            return self.choiceCells[self.subscriptArray[indexPath.row]]!
        case 2:
            if indexPath.row == 0{
                return self.chapterCell
            }
            return self.difficultyCell
        case 3:
            return self.answerDetailCell
        case 4:
            return self.tableView.dequeueReusableCellWithIdentifier("SubmitCell")!
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section{
        case 0:
            return self.questionCell.bounds.height
        case 1:
            return self.choiceCells["A"]!.bounds.height
        case 2:
            return self.chapterCell.bounds.height
        case 3:
            return self.answerDetailCell.bounds.height
        case 4:
            return self.choiceCells["A"]!.bounds.height
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 3{
            return "答案解析"
        }
        return nil
    }
    
    func knowledgePointsAcquired() {
        self.performSegueWithIdentifier("ShowKnowledgePoints", sender: self)
    }
    
    
    
    func setKnowledgePoints(indexPath: NSIndexPath) {
        self.chapterNo = self.testHelper.knowledgePoints.chapters[indexPath.section].chapterNo
        self.selectedKnowledgePointNo = indexPath.row
        self.chapterLabel.text = "第\(self.chapterNo)章"
        self.knowledgePointLabel.text = "\(self.testHelper.knowledgePoints.chapters[indexPath.section].points[self.selectedKnowledgePointNo])"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowKnowledgePoints"{
            let nextscene = segue.destinationViewController as! KnowledgePointsTableViewController
            if self.selectedKnowledgePointNo != -1 && self.chapterNo != -1{
                nextscene.selectedKnowledgePointNo = NSIndexPath(forRow: self.selectedKnowledgePointNo, inSection: self.testHelper.knowledgePoints.chaptersDict["\(self.chapterNo)"]!.No)
            }
            
            nextscene.delegate = self
        }
    }

}