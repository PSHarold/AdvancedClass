//
//  TeacherAutomaticRandomQuestionViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/5.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherManualFixedTestViewController: KnowledgePointViewController {

    @IBOutlet weak var tableView: UITableView!
    override var pointsTableView: UITableView!{
        get{
            return self.tableView
        }
    }
    @IBOutlet weak var confirmPostView: UIView!
    
    @IBAction func backButtonTapped(sender: AnyObject) {
         let alert = UIAlertController(title: nil, message: "返回后未发布的测验将丢失，确定？", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){ _ in TeacherTestHelper.defaultHelper.dropNewTest(); self.navigationController?.popToRootViewControllerAnimated(true)})
        self.presentViewController(alert, animated: true, completion: nil)

    }
    @IBAction func removeAllButton(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "确认清空已选题目？", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Destructive){ _ in self.test!.removeAllQuestions(); self.confirmPostView.hidden = true})
        self.presentViewController(alert, animated: true, completion: nil)
    
    }
    @IBOutlet weak var selectedNumLabel: UILabel!
    weak var test = TeacherTestHelper.defaultHelper.newTest
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.confirmPostView.hidden = true
        self.test!.randomTypeEnum = .MANUAL_FIXED
        //test.delegate = self
    }
    
    var selectedPoint: KnowledgePoint!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.test!.totalNum == 0{
            self.confirmPostView.hidden =  true
        }
        else{
            self.confirmPostView.hidden = false
            self.selectedNumLabel.text = "\(self.test!.totalNum)道题目"
        }
    }
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        let cell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as? KnowledgePointTableViewCell
        if cell == nil{
            return
        }
        let point = self.pointsWithRowNum[indexPath.section][indexPath.row]
        if point == nil{
            return
        }
        
        self.showHudWithText("加载中", mode: .Indeterminate)
        point!.getQuestions{
            [unowned self]
            (error, json) in
            
            if let error = error{
                    self.showError(error)
                    return
            }
            if point!.questions.count == 0{
                self.showHudWithText("无题目")
                return
            }
            self.selectedPoint = point!
            self.hideHud()
            self.performSegueWithIdentifier("ShowQuestionsInPoint", sender: self)
            
        }
      
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowQuestionsInPoint"{
            let vc = segue.destinationViewController as! TeacherManualFixedQuestionsInPointTableViewController
            vc.knowledgePoint = self.selectedPoint
        }
    }
    
//    func questionAdded(currentQuestionNum: Int) {
//        self.confirmPostView.hidden = false
//    }
//    func questionRemoved(currentQuestionNum: Int) {
//        if currentQuestionNum == 0{
//            self.confirmPostView.hidden = true
//        }
//    }
}
