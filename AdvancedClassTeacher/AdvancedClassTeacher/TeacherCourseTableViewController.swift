//
//  TeacherCourseTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherCourseTableViewController: UITableViewController {
    var first = true
    
    weak var courseHelper = TeacherCourseHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(CourseTableViewCell.self, forCellReuseIdentifier: "PointCell")
        let courseNib = UINib(nibName: "CourseTableViewCell", bundle: nil)
        self.tableView.registerNib(courseNib, forCellReuseIdentifier: "cell")
        var index = 0
        let courses = TeacherAuthenticationHelper.me.courses
        for course in courses{
            self.courseHelper?.getCourseCover(course){
                error in
                if error == nil{
                    self.tableView.reloadData()//self.tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .None)
                }
            }
            index += 1
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        guard let count = TeacherAuthenticationHelper.defaultHelper.me?.pendingAsks.count else{
            return
        }
        if  count != 0{
            self.performSegueWithIdentifier("ShowNewStatusAsks", sender: self)
            self.first = false
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TeacherAuthenticationHelper.defaultHelper.me.courses.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CourseTableViewCell
        let course = TeacherAuthenticationHelper.defaultHelper.me.courses[indexPath.row]
        //cell.textLabel?.text = course.name
        //cell.imageView?.image = course.coverImage
        cell.coverImage = course.coverImage
        cell.mainTextLabel.text = course.name
        cell.subtitleLabel.text = course.classNames.joinWithSeparator(" ")
        if let periods = course.timesAndRooms.getTodaysPeriods(){
            cell.detailLabel.textColor = UIColor.blackColor()
            var strings = [String]()
            for period in periods{
                strings.append("第\(period.period)节 \(period.room_name)")
            }
            cell.detailLabel.text = strings.joinWithSeparator("\n")
        }
        else{
            cell.detailLabel.textColor = UIColor.grayColor()
            cell.detailLabel.text = "今天没课"
        }
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        TeacherCourse.currentCourse = TeacherAuthenticationHelper.defaultHelper.me.courses[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        self.courseHelper?.getStudentsInCourse(TeacherCourse.currentCourse){
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
                return
            }
            self.performSegueWithIdentifier("enterMain", sender: self)
        }
        
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowNotifications"{
            
        }
    }
    @IBAction func unwindToCourseTable(segue: UIStoryboardSegue) {
        TeacherCourse.currentCourse = nil
        TeacherSeatHelper.drop()
        
    }
    
}
