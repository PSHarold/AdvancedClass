//
//  StudentTestTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/3.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentTestTableViewController: UITableViewController,StudentTestHelperDelegate {

    var testHelper = StudentTestHelper.defaultHelper()
    let hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.testHelper.delegate = self
       
        self.tableView.reloadData()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testHelper.testArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
        let test = self.testHelper.testArray[indexPath.row]
        cell.textLabel?.text = test.startTime
        if test.expired{
            cell.detailTextLabel?.text = "已结束"
        }
        else{
            cell.detailTextLabel?.text = "正在进行"
            cell.detailTextLabel?.textColor = UIColor.redColor()
        }
        if test.finished{
            cell.detailTextLabel?.text = "已完成"
            cell.detailTextLabel?.textColor = UIColor.blueColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let test = self.testHelper.testArray[indexPath.row]
        self.hud.mode = .Indeterminate
        self.hud.labelText = "正在加载"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        self.testHelper.testToView = test
        if test.finished{
            self.testHelper.testToView = test
            self.testHelper.getTestResultsWithTest(test)
            return
        }
        self.testHelper.getQuestionsWithTest(test)
        
    }
    
    func networkError() {
        self.hud.mode = MBProgressHUDMode.Text
        self.hud.labelText = "网络错误！"
        self.hud.hide(true, afterDelay: 1.2)
    }
    func allQuestionsAcquired() {
        self.hud.removeFromSuperview()
        self.performSegueWithIdentifier("ShowTestDetails", sender: self)
    }   
    
    func testResultsAcquiredWithTestId(id: String) {
        self.hud.removeFromSuperview()
        self.performSegueWithIdentifier("ShowTestDetails", sender: self)
    }
    
}
