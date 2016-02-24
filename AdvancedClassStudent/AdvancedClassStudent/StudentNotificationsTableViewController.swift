//
//  StudentNotificationsTableViewController.swift
//  
//
//  Created by Harold on 15/10/1.
//
//

import UIKit

class StudentNotificationsTableViewController: UITableViewController {

    @IBOutlet weak var myRefresh: UIRefreshControl!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    let course = StudentCourse.currentCourse
    var noRows = false
    var doneAcquiring = false
    var failed = false
    override func viewDidLoad() {
        super.viewDidLoad()
        let empty = UIView(frame: self.tableView.frame)
        empty.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.tableView.tableFooterView = UIView()
        self.tableView.backgroundView = empty
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        if self.segmentedControl.selectedSegmentIndex == 0{
            rows = self.course.unreadNotifications.count
            
        }
        else{
            rows = self.course.notifications.count
        }
        if rows == 0{
            self.noRows = true
            return 1
        }
        self.noRows = false
        return rows
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }

    
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if self.noRows{
            let cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
            if self.segmentedControl.selectedSegmentIndex == 0{
                cell.textLabel?.text =  "没有新通知"
            }
            else{
                if self.failed{
                    cell.textLabel?.text = "下拉尝试重新获取"
                }
                else{
                    cell.textLabel?.text = self.doneAcquiring ? "没有新通知" : "正在获取..."
                }
            }
            cell.textLabel?.textAlignment = .Center
            cell.backgroundColor = UIColor.clearColor()
            self.tableView.separatorStyle = .None
            self.tableView.scrollEnabled = false
            cell.selectionStyle = .None
            cell.accessoryType = .None
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        }
        self.tableView.separatorStyle = .SingleLine
        self.tableView.scrollEnabled = true
        let cell = UITableViewCell(style: .Value1, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor.whiteColor()
        cell.selectionStyle = .Default
        cell.accessoryType = .DisclosureIndicator
        
        var n: Notification
        if self.segmentedControl.selectedSegmentIndex == 0{
             n = self.course.unreadNotifications[indexPath.row]
        }
        else{
             n = self.course.notifications[indexPath.row]
        }
        cell.textLabel?.text = n.title
        cell.detailTextLabel?.text = n.createdOn
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }

    
    @IBAction func indexChanged(sender: AnyObject) {
        self.tableView.reloadData()
        if self.segmentedControl.selectedSegmentIndex == 0{
            return
        }
        self.course.getNotifications(){
            error in
            if let error = error{
                self.failed = true
                self.showError(error)
            }
            else{
                self.failed = false
                self.doneAcquiring = true
            }
            self.tableView.reloadData()
        }
        
    }
    @IBAction func refresh(sender: UIRefreshControl) {
        
    }
   
}
