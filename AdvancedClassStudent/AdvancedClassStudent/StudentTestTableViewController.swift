//
//  StudentTestTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/3.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentTestTableViewController: UITableViewController,StudentTestHelperDelegate {

    var testTelper = StudentTestHelper.defaultHelper()
    let hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
 
    override func viewWillAppear(animated: Bool) {
        self.testTelper.delegate = self
        self.tableView.reloadData()
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testTelper.testArray.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
        let test = self.testTelper.testArray[indexPath.row]
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
            cell.detailTextLabel?.textColor = UIColor.cyanColor()
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let test = self.testTelper.testArray[indexPath.row]
        if test.expired{
            return
        }
        self.hud.mode = .Indeterminate
        self.hud.labelText = "正在加载"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        if test.finished{
            self.testTelper.getTestResultsWithTest(test)
            return
        }
        self.testTelper.getQuestionsWithTest(test)
        self.testTelper.testToTake = test
        //self.performSegueWithIdentifier("TakeTest", sender: self)
    }
    
    func networkError() {
        self.hud.mode = MBProgressHUDMode.Text
        self.hud.labelText = "网络错误！"
        self.hud.hide(true, afterDelay: 1.2)
    }
    func allQuestionsAcquired() {
        self.hud.removeFromSuperview()
        self.performSegueWithIdentifier("TakeTest", sender: self)
    }   
    
    func testResultsAcquiredWithTestId(id: String) {
        self.hud.removeFromSuperview()
        self.testTelper.testToViewResult = self.testTelper.testDict[id]
        self.performSegueWithIdentifier("ShowResults", sender: self)
    }
    
}
