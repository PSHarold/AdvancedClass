//
//  AbsenceTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AbsenceTableViewController: UITableViewController {
    let course = StudentCourse.currentCourse
    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "无缺勤记录"
        label.textAlignment = .Center
        label.frame.origin.x = self.tableView.center.x
        label.frame.origin.y = self.tableView.center.y
        self.tableView.backgroundView = label
            }
 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.course.absenceList.count == 0{
            self.tableView.backgroundView?.hidden = false
        }
        else{
            self.tableView.backgroundView?.hidden = true
        }
        return self.course.absenceList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let absence = self.course.absenceList[indexPath.row]
        cell.textLabel?.text = "第\(absence["week_no"]!)周 周\(absence["day_no"]!) 第\(absence["period_no"]!)节"
        return cell
    }
   
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
