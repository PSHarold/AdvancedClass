//
//  TeacherNotificationsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/10/4.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherNotificationsTableViewController: UITableViewController {
    
    let notifications = TeacherCourseHelper.defaultHelper().currentCourse.sortedNotifications
    var selectedNotification:Notification!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.reloadData()
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }


    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath)

        let notification = self.notifications[indexPath.row]
        cell.textLabel!.text = notification.title
        cell.detailTextLabel!.text = notification.time
        if notification.top{
            cell.textLabel!.textColor = UIColor.redColor()
            cell.detailTextLabel!.textColor = UIColor.redColor()
        }
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedNotification = self.notifications[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.performSegueWithIdentifier("ShowNotificationDetail", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowNotificationDetail"{
            let next = segue.destinationViewController as! TeacherCreateNotificationTableViewController
            next.notification = self.selectedNotification
        }
    }
    

}
