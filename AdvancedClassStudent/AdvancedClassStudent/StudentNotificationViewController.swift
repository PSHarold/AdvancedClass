//
//  StudentNotificationViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/10/3.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class StudentNotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedNotification:Notification!
    @IBOutlet weak var tableView: UITableView!
    let notifications = StudentCourseHelper.defaultHelper().currentCourse.sortedNotifications
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("MyCell")!
        let notification = self.notifications[indexPath.row]
        cell.textLabel!.text = notification.title
        
        cell.detailTextLabel!.text = notification.time
        cell .textLabel!.textColor = notification.top ? UIColor.redColor() : UIColor.blackColor()
        cell .detailTextLabel!.textColor = notification.top ? UIColor.redColor() : UIColor.blackColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.selectedNotification = self.notifications[indexPath.row]
        self.performSegueWithIdentifier("ShowNotificationDetails", sender: self)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowNotificationDetails"{
            let next = segue.destinationViewController as! StudentNotificationDetailsTableViewController
            next.notification = self.selectedNotification
        }
    }
}
