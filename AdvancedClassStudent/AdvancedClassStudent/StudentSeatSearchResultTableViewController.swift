//
//  StudentSeatSearchResultTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/3/29.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentSeatSearchResultTableViewController: UITableViewController {

    var studentIds: [String]?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.definesPresentationContext = true
        self.tableView.registerClass(StudentInfoCell.self, forCellReuseIdentifier: "cell")
        let xib = UINib(nibName: "StudentInfoCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studentIds?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StudentInfoCell
        let studentId = self.studentIds![indexPath.row]
        let student = StudentCourse.currentCourse.students[studentId]
        cell.studentId = studentId
        if let seat = StudentSeatHelper.defaultHelper.seatByStudentId[studentId]{
            cell.detailText = "\(seat.row)排\(seat.column)列"
            cell.detailLabel.textColor = UIColor.blackColor()
            StudentSeatHelper.defaultHelper.seatToLocate = seat
        }
        else{
            StudentSeatHelper.defaultHelper.seatToLocate = nil
            cell.detailText = "未到"
            cell.detailLabel.textColor = UIColor.grayColor()
        }
        if let student = student{
            cell.studentName = student.name
            cell.className = student.className
            cell.studentId = student.studentId
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

}
