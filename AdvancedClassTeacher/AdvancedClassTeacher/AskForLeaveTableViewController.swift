//
//  AskForLeaveTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/8.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AskForLeaveTableViewController: UITableViewController {
    let course = TeacherCourse.currentCourse
    let courseHelper = TeacherCourseHelper.defaultHelper
    var selectedAsk: AskForLeave!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl = UIRefreshControl()
        self.refreshControl!.addTarget(self, action: #selector(AskForLeaveTableViewController.beginRefreshing), forControlEvents: .ValueChanged)
        //self.refreshControl!.beginRefreshing()
        //self.beginRefreshing()
        let label = UILabel()
        label.text = "无请假记录"
        label.textAlignment = .Center
        label.frame.origin.x = self.tableView.center.x
        label.frame.origin.y = self.tableView.center.y
        self.tableView.backgroundView = label
        self.tableView.registerClass(NewStatusAskTableViewCell.self, forCellReuseIdentifier: "cell")
        let xib = UINib(nibName: "NewStatusAskTableViewCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "cell")
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
        if self.selectedAsk.status == .PENDING{
            self.performSegueWithIdentifier("ShowPendingAsk", sender: self)
        }
        else{
            self.performSegueWithIdentifier("ShowAsk", sender: self)
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowAsk"{
            let vc = segue.destinationViewController as! PostedAskTableViewController
            vc.ask = self.selectedAsk
        }
        else if segue.identifier == "ShowPendingAsk"{
            let vc = segue.destinationViewController as! PendingAskTableViewController
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
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)  as! NewStatusAskTableViewCell
        let ask = self.course.asks[indexPath.row]
        cell.studentString = "第\(ask.weekNo)周 周\(ask.dayNo) 第\(ask.periodNo)节"
        switch ask.status! {
        case .PENDING:
            cell.timeLabel?.textColor = UIColor.orangeColor()
            cell.timeLabel?.text = "待审核"
        case .APPROVED:
            cell.timeLabel?.textColor = UIColor.greenColor()
            cell.timeLabel?.text = "已批准"
        case .DISAPPROVED:
            cell.timeLabel?.textColor = UIColor.redColor()
            cell.timeLabel?.text = "不批准"
        }
        cell.courseName = ask.studentId
        return cell
    }
    
    func beginRefreshing(){
        self.courseHelper.getAsksForLeave(self.course){
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
            }
            else{
                
                self.tableView.reloadData()
            }
            self.refreshControl!.endRefreshing()
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        let ask = self.course.asks[indexPath.row]
        if ask.status == .PENDING{
            return .Delete
        }
        return .None
    }
    
    override func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "不批准"
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let ask = self.course.asks[indexPath.row]
    }
   
}
