//
//  TeacherStudentAttendanceTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/26.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherStudentAttendanceTableViewController: UITableViewController {
    weak var seatHelper = TeacherSeatHelper.defaultHelper
    weak var currentCourse = TeacherCourse.currentCourse
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    var absentStudents: [String]!
    var presentStudents: [String]!
    
     
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAbsentAndPresentStudents()
        self.tableView.registerClass(StudentInfoCell.self, forCellReuseIdentifier: "cell")
        let xib = UINib(nibName: "StudentInfoCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "cell")
    }
    
    var showPresent: Bool{
        return self.segmentedControl.selectedSegmentIndex == 0
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
        if self.showPresent{
            return self.seatHelper!.seatByStudentId.count
        }
        else{
            return self.currentCourse!.students.count - self.seatHelper!.seatByStudentId.count
        }
    }
    
    func getAbsentAndPresentStudents(){
        let all = Set<String>(currentCourse!.students.keys)
        let present = Set<String>(self.seatHelper!.seatByStudentId.keys)
        self.absentStudents = [String](all.subtract(present))
        self.presentStudents = [String](self.seatHelper!.seatByStudentId.keys)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StudentInfoCell
        var studentId: String
        if self.showPresent{
            studentId = self.presentStudents[indexPath.row]
            let seat = self.seatHelper!.seatByStudentId[studentId]
            cell.detailText = "\(seat!.row)排\(seat!.column)列"
        }
        else{
            studentId = self.absentStudents[indexPath.row]
            cell.detailText = ""
        }
        let student = self.currentCourse?.students[studentId]
        cell.studentId = student?.studentId ?? "未知"
        cell.studentName = student?.name ?? "未知"
        cell.className = student?.className ?? "未知"
        return cell
    }
    
    @IBAction func segmentedIndexChanged(sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
    @IBAction func refreshList(sender: AnyObject) {
        self.showHudWithText("正在刷新", mode: .Indeterminate)
        self.seatHelper!.getSeatMap{
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
            }
            else{
                self.getAbsentAndPresentStudents()
                self.tableView.reloadData()
                self.hideHud()
            }
        }
    }
}
