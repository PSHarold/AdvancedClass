
//
//  AbsenceStatisticsTableViewController.swift
//  Face-Teacher
//
//  Created by Harold on 16/4/19.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AbsenceStatisticsTableViewController: UITableViewController {
    
    let course = TeacherCourse.currentCourse
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(NewStatusAskTableViewCell.self, forCellReuseIdentifier: "cell")
        let xib = UINib(nibName: "NewStatusAskTableViewCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "cell")
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let s = self.course.absenceListSorted[indexPath.row]
        let student = self.course.studentDict[s.0]
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as!NewStatusAskTableViewCell

        cell.courseName = s.0
        cell.timeString = "\(s.1)次"
        cell.studentString = (student?.className ?? "") + " " + (student?.name ?? "")
        return cell
    }

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.course.absenceListSorted.count
    }



}
