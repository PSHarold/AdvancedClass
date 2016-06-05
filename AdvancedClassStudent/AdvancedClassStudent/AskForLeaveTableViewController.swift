//
//  AskForLeaveTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/8.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AskForLeaveTableViewController: UITableViewController {
    let course = StudentCourse.currentCourse
    var selectedAsk: AskForLeave!
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "无请假记录"
        label.textAlignment = .Center
        label.frame.origin.x = self.tableView.center.x
        label.frame.origin.y = self.tableView.center.y
        self.tableView.backgroundView = label
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedAsk = self.course.asks[indexPath.row]
        self.performSegueWithIdentifier("ShowAsk", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowAsk"{
            let vc = segue.destinationViewController as! PostedAskTableViewController
            vc.ask = self.selectedAsk
        }
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.course.asks.count == 0{
            self.tableView.backgroundView?.hidden = false
        }
        else{
            self.tableView.backgroundView?.hidden = true
        }
        return course.asks.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let ask = self.course.asks[indexPath.row]
        cell.textLabel?.text = "第\(ask.weekNo)周 周\(ask.dayNo) 第\(ask.periodNo)节"
        switch ask.status! {
        case .PENDING:
            cell.detailTextLabel?.textColor = UIColor.orangeColor()
            cell.detailTextLabel?.text = "待审核"
        case .APPROVED:
            cell.detailTextLabel?.textColor = UIColor.greenColor()
            cell.detailTextLabel?.text = "已批准"
        case .DISAPPROVED:
            cell.detailTextLabel?.textColor = UIColor.redColor()
            cell.detailTextLabel?.text = "不批准"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let ask = self.course.asks[indexPath.row]
        if ask.status == .PENDING {
            return .Delete
        }
        return .None
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
       
        return "撤销申请"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let ask = self.course.asks[indexPath.row]
        StudentCourseHelper.defaultHelper.deleteAskForLeave(ask, course: StudentCourse.currentCourse){
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
            }
            else{
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
            }
        }
    }
   
}
