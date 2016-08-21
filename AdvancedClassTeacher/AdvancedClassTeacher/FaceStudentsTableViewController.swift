//
//  FaceStudentsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/8/21.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class FaceStudentsTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    var searchBar = UISearchController()
    var selectedStudentId: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(StudentInfoCell.self, forCellReuseIdentifier: "cell")
        let xib = UINib(nibName: "StudentInfoCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "cell")
        
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return TeacherCourse.currentCourse.studentIds.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let course = TeacherCourse.currentCourse
        let student = course.studentDict[course.studentIds[indexPath.row]]!
        self.selectedStudentId = student.studentId
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let picker = UIImagePickerController()
        picker.delegate = self
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! StudentInfoCell
        let course = TeacherCourse.currentCourse
        let student = course.studentDict[course.studentIds[indexPath.row]]!
        cell.studentId = student.studentId
        cell.studentName = student.name
        cell.className = student.className
        return cell
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var img = info[UIImagePickerControllerOriginalImage] as! UIImage
        img = img.fixOrientation()
        self.showHudIndeterminate("正在上传")
        let courseHelper = TeacherCourseHelper.defaultHelper
        courseHelper.checkInWithFace(seat_token: TeacherSeatHelper.defaultHelper.seatToken, studentId: self.selectedStudentId, photo: img){
            [unowned self]
            error, json in
            self.selectedStudentId = nil
            self.hideHud()
            if let error = error{
                let alert = UIAlertController(title: nil, message: error.description, preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
            else{
                let alert = UIAlertController(title: nil, message: "签到成功！", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        
    }


}
