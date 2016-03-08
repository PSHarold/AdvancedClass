////
////  TeacherCurrentStudentListTableViewController.swift
////  AdvancedClassTeacher
////
////  Created by Harold on 15/10/7.
////  Copyright © 2015年 Harold. All rights reserved.
////
//
//import UIKit
//
//class TeacherCurrentStudentListTableViewController: UITableViewController {
//    let studentHelper = TeacherStudentHelper.defaultHelper()
//    let seatHelper = TeacherSeatHelper.defaultHelper()
//    
//    @IBOutlet weak var segmentControl: UISegmentedControl!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.segmentControl.addTarget(self, action: "segmentedControlValueChanged", forControlEvents: .ValueChanged)
//        
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 1
//    }
//    
//    func segmentedControlValueChanged(){
//        self.tableView.reloadData()
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = self.tableView.dequeueReusableCellWithIdentifier("MyCell")!
//        var student:Student
//        switch self.segmentControl.selectedSegmentIndex{
//        case 0:
//            student = self.studentHelper.studentArray[indexPath.row]
//        case 1:
//            student = self.studentHelper.presentStudentArray[indexPath.row]
//        case 2:
//            student = self.studentHelper.absentStudentArray[indexPath.row]
//        default:
//            return cell
//        }
//        let seat = self.seatHelper.getSeatWithStudentId(student.studentId)
//        cell.detailTextLabel!.text = seat == nil ? "" : "\(seat!.row)排\(seat!.row)列"
//        cell.textLabel!.text = "\(student.name)\t\t\(student.studentId)"
//        return cell
//    }
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
//    }
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        switch self.segmentControl.selectedSegmentIndex{
//        case 0:
//            return self.studentHelper.studentArray.count
//        case 1:
//            return self.studentHelper.presentStudentArray.count
//        case 2:
//            return self.studentHelper.absentStudentArray.count
//        default:
//            return 0
//        }
//
//    }
//    
//}
