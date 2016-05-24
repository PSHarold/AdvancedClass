//
//  AttendanceListTableViewController.swift
//  Face-Teacher
//
//  Created by Harold on 16/4/18.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AttendanceListTableViewController: UITableViewController {
    let courseHelper = TeacherCourseHelper.defaultHelper
    var auto = false
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.auto{
            self.setupRefreshControl()
        }
    }
    
    func setupRefreshControl(){
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action: #selector(AttendanceListTableViewController.beginRefreshing), forControlEvents: .ValueChanged)
    }
    
    func beginRefreshing(){
        self.courseHelper.getAttendanceListAuto(TeacherCourse.currentCourse){
            [unowned self]
            error, _ in
            if let error = error{
                self.showError(error)
            }
            else{
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            return self.courseHelper.attendanceList.absentStudents.count
        case 1:
            return self.courseHelper.attendanceList.presentStudents.count
        case 2:
            return self.courseHelper.attendanceList.askedStudents.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var studentId: String
        var seat = ""
        switch self.segmentedControl.selectedSegmentIndex {
        case 0:
            studentId =  self.courseHelper.attendanceList.absentStudents[indexPath.row]
        case 1:
            studentId =  self.courseHelper.attendanceList.presentStudents[indexPath.row]
            seat = self.courseHelper.attendanceList.seatMap[studentId]!
        case 2:
            studentId =  self.courseHelper.attendanceList.askedStudents[indexPath.row]
        default:
            studentId = ""
        }
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let name = TeacherCourse.currentCourse.studentDict[studentId]?.name ?? ""
        let className = TeacherCourse.currentCourse.studentDict[studentId]?.className ?? ""
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = studentId + " " + className
        cell.detailTextLabel?.text = seat
        return cell
    }
    @IBAction func segmentChanged(sender: AnyObject) {
        self.tableView.reloadData()
    }
}
