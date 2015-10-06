//
//  TeacherBrowseTableViewController.swift
//  MyClassStudent
//
//  Created by Harold on 15/8/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherQuestionTableViewController: UITableViewController, TeacherTestHelperDelegate {

    
    var detailIndex = -1
    var rc = UIRefreshControl()
    var testHelper = TeacherTestHelper.defaultHelper()
    var test:TeacherTest!
    let hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        self.rc.addTarget(self, action: "refreshQuestions", forControlEvents: .ValueChanged)
        self.refreshControl = rc
        self.test = self.testHelper.newTest
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.testHelper.delegate = self
    }
    
    func refreshNetworkError() {
        
        self.rc.attributedTitle = NSAttributedString(string: "刷新失败")
        var delay = 1.0 * Double(NSEC_PER_SEC)
        var time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.rc.endRefreshing()
        }
        delay = 1.5 * Double(NSEC_PER_SEC)
        time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

        dispatch_after(time, dispatch_get_main_queue()) {
            self.rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        }

    }
    func noQuestionsOrTest() {
        self.rc.attributedTitle = NSAttributedString(string: "刷新成功")
        var delay = 1.0 * Double(NSEC_PER_SEC)
        var time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.rc.endRefreshing()
        }
        delay = 1.5 * Double(NSEC_PER_SEC)
        time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        }
        
        self.tableView.reloadData()
        
    }
    
    func networkError() {
        self.hud.mode = MBProgressHUDMode.Text
        self.hud.labelText = "网络错误！"
        self.hud.show(true)
        self.hud.hide(true, afterDelay: 1.2)
    }

    
    func allQuestionsAcquired() {
        self.rc.attributedTitle = NSAttributedString(string: "刷新成功")
        var delay = 1.0 * Double(NSEC_PER_SEC)
        var time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.rc.endRefreshing()
        }
        delay = 1.5 * Double(NSEC_PER_SEC)
        time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))

        dispatch_after(time, dispatch_get_main_queue()) {
            self.rc.attributedTitle = NSAttributedString(string: "下拉刷新")
        }

        self.tableView.reloadData()
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell")!
        cell.textLabel?.text = self.testHelper.allQuestionArray[indexPath.row].question
        return cell
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return self.testHelper.allQuestionArray.count

    }
    
    
    //选中某个问题
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath)
        let question = self.testHelper.allQuestionArray[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //如果已选中，取消选中
        if cell!.accessoryType == .Checkmark{
            cell!.accessoryType = UITableViewCellAccessoryType.DetailDisclosureButton
            self.test.removeQuestion(question)
        }
        //如果为选中，加入列表
        else{
            cell!.accessoryType = .Checkmark
            self.test.addQuestion(question)

        }
        (self.parentViewController as! TeacherBrowseViewController).sendButton.hidden = self.test.questions.count == 0
        
    }
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        detailIndex = indexPath.row
        performSegueWithIdentifier("ShowDetails", sender: self)
        
    }

    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return "删除"
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.hud.mode = .Indeterminate
        self.hud.labelText = "删除中"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        let question = self.testHelper.allQuestionArray[indexPath.row]
        self.testHelper.deleteQuestion(question,indexPath: indexPath)
    }
    func questionRemovedAtIndexPath(indexPath: NSIndexPath) {
        
        self.test.removeQuestion(self.testHelper.allQuestionArray[indexPath.row])
        self.testHelper.allQuestionArray.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        self.hud.mode = MBProgressHUDMode.Text
        self.hud.labelText = "删除成功！"
        self.hud.hide(true, afterDelay: 0.8)
        
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nextscene = segue.destinationViewController as! TeacherCreateTableViewController
        nextscene.question = self.testHelper.allQuestionArray[detailIndex]
//        if segue.identifier == "NewQuestion"{
//            self.test.removeAllQuestions()
//        }
        
    }
    
    
    func refreshQuestions(){
        if self.rc.refreshing == true{
            self.rc.attributedTitle = NSAttributedString(string: "刷新中")
            self.testHelper.updateAllQuestions()
            return
        }
    }

}
