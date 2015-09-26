//
//  TeacherTestTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/5.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherTestTableViewController: UITableViewController,TeacherTestHelperDelegate {

    var testHelper = TeacherTestHelper.defaultHelper()
    var hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.testHelper.delegate = self
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testHelper.allTestArray.count
    }
    
    
    @IBAction func createNewTest(sender: AnyObject) {
        hud.mode = MBProgressHUDMode.Indeterminate
        self.hud.labelText = "正在获取题目"
        self.testHelper.getAllQuestions()
    }
    
    func networkError() {
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = "网络错误！"
        hud.hide(true, afterDelay: 1.2)
        
    }
    
    func allQuestionsAcquired() {
        self.hud.removeFromSuperview()
        performSegueWithIdentifier("SelectQuestions", sender: self)
    }
    
    func allQuestionsAcquiredWithTestId(id: String) {
        self.performSegueWithIdentifier("ShowQuestionsInTest", sender: self)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
        let test = self.testHelper.allTestArray[indexPath.row]
        cell.textLabel?.text = test.startTime
        if test.expired{
            cell.detailTextLabel?.text = "已结束"
        }
        else{
            cell.detailTextLabel?.text = "正在进行"
            cell.detailTextLabel?.textColor = UIColor.redColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String {
        return "删除"
    }
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        self.testHelper.deleteTest(self.testHelper.allTestArray[indexPath.row],indexPath:indexPath)
    }
    
    func testRemovedAtIndexPath(indexPath: NSIndexPath) {
        self.testHelper.allTestArray.removeAtIndex(indexPath.row)
        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.mode = MBProgressHUDMode.Text
        hud.labelText = "删除成功！"
        hud.hide(true, afterDelay: 0.8)

    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.testHelper.getQuestionsWithTest(self.testHelper.allTestArray[indexPath.row])
    }
    
}
