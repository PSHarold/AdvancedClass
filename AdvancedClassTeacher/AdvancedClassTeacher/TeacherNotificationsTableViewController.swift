//
//  TeacherNotificationsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/10/4.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherNotificationsTableViewController: UITableViewController {
    
    weak var courseHelper = TeacherCourseHelper.defaultHelper
    weak var currentCourse = TeacherCourse.currentCourse
    var selectedNotification: Notification!
    var page = 1
    var acquiring = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelOrigin = CGPointMake(self.tableView.bounds.width/2, self.tableView.bounds.height/2)
        let label = UILabel()
        label.text = "下拉刷新"
        label.textAlignment = .Center
        label.frame.origin = labelOrigin
        self.tableView.backgroundView = label
        self.refreshControl!.addTarget(self, action: #selector(self.beginRefreshing), forControlEvents: .ValueChanged)
        self.refreshControl!.beginRefreshing()
        self.beginRefreshing()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCourse!.notifications.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let notification = self.currentCourse!.notifications[indexPath.row]
        cell.textLabel!.text = notification.title
        cell.detailTextLabel!.text = notification.createdOn
        if notification.onTop!{
            cell.textLabel!.textColor = UIColor.redColor()
            cell.detailTextLabel!.textColor = UIColor.redColor()
        }
        else{
            cell.textLabel!.textColor = UIColor.blackColor()
            cell.detailTextLabel!.textColor = UIColor.blackColor()
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedNotification = self.currentCourse!.notifications[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ShowNotification", sender: self)
    }
    
    func beginRefreshing(){
        if self.refreshControl!.refreshing{
            self.loadNotificationsToPage(1)
            
        }
    }
    
    
    func loadNotificationsToPage(page: Int){
        self.acquiring = true
        self.courseHelper!.getNotifications(self.currentCourse!, page: page){
            [unowned self]
            error in
            let label = self.tableView.backgroundView as! UILabel
            if let error = error{
                self.showError(error)
                if self.currentCourse!.notifications.count == 0{
                    
                    label.hidden = false
                    label.text = "网络错误，下拉重试"
                }
            }
            else{
                if self.currentCourse!.notifications.count == 0{
                    
                    label.hidden = false
                    label.text = "无通知，下拉刷新"
                }
                else{
                    self.tableView.reloadData()
                    label.hidden = true
                    self.page = page
                }
            }
            self.refreshControl?.endRefreshing()
            
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60.0
    }
    
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.acquiring = false
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.acquiring{
            return
        }
        let offsetY = scrollView.contentOffset.y
        let judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frame.height
        if offsetY >= judgeOffsetY{
            self.loadNotificationsToPage(self.page+1)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowNotification"{
            let vc = segue.destinationViewController as! TeacherNotificationContentTableViewController
            vc.notification = self.selectedNotification
        }
    }
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let notification = self.currentCourse!.notifications[indexPath.row]
            self.courseHelper!.deleteNotificationInCourse(self.currentCourse!, notification: notification){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.currentCourse!.notifications.removeAtIndex(indexPath.row)
                    self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                }
            }
        }
    }
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
}
