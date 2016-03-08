////
////  TestExpirationSettingsTableViewController.swift
////  AdvancedClassTeacher
////
////  Created by Harold on 15/10/5.
////  Copyright © 2015年 Harold. All rights reserved.
////
//
//import UIKit
//
//class TestExpirationSettingsTableViewController: UITableViewController {
//
//    @IBOutlet weak var datePicker: UIDatePicker!
//    @IBOutlet weak var timePicker: UIDatePicker!
//    var expireDate:NSDate?
//    var test = TeacherTestHelper.defaultHelper().newTest
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.datePicker.minimumDate = NSDate()
//    }
//    @IBAction func applyButton(sender: AnyObject) {
//        let date = datePicker.date
//        let time = timePicker.date
//        let dateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: date)
//        let timeComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Hour,NSCalendarUnit.Minute], fromDate: time)
//        dateComponents.hour = timeComponents.hour
//        dateComponents.minute = timeComponents.minute
//        self.test.deadlineDate = NSCalendar.currentCalendar().dateFromComponents(dateComponents)
//        self.navigationController?.popViewControllerAnimated(true)
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    // MARK: - Table view data source
//
//}
