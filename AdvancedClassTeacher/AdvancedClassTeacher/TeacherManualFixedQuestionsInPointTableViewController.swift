//
//  TeacherManualQuestionsInPointTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/7.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherManualFixedQuestionsInPointTableViewController: TeacherQuestionsInPointTableViewController {
    
    let test = TeacherTestHelper.defaultHelper.newTest
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
        
    @IBAction func cancelButtonTapped(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: "返回后未发布的测验将丢失，确定？", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "取消", style: UIAlertActionStyle.Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){ _ in TeacherTestHelper.defaultHelper.dropNewTest(); self.navigationController?.popToRootViewControllerAnimated(true)})
        self.presentViewController(alert, animated: true, completion: nil)

    }
    @IBAction func backButtonTapped(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
        let question = self.knowledgePoint.questions[indexPath.row]
        if self.test.hasQuestion(question){
            cell.accessoryType = .Checkmark
        }
        else{
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        if self.test.hasQuestion(self.selectedQuestion){
            test.removeQuestion(self.selectedQuestion)
        }
        else{
            test.addQuestion(self.selectedQuestion)
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: .None)
    }
    
    
}
