//
//  TestExpirationSettingsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/10/5.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class TestDateTimeSettingsTableViewController: UITableViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    var toSetDateType = -1
    var valueChanged = false
    var test = TeacherTestHelper.defaultHelper.newTest
    override func viewDidLoad() {
        super.viewDidLoad()
        self.datePicker.minimumDate = NSDate()
        self.loadTimeDate()
        
    }
    func setDateTime(toNow: Bool = false) {
        let date = datePicker.date
        let time = timePicker.date
        let dateComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: date)
        let timeComponents = NSCalendar.currentCalendar().components([NSCalendarUnit.Hour,NSCalendarUnit.Minute], fromDate: time)
        dateComponents.hour = timeComponents.hour
        dateComponents.minute = timeComponents.minute
        let s = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!.toString()
        if self.toSetDateType == 0{
            self.test.beginsOn = s
        }
        else{
            self.test.expiresOn = s
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func ValueChanged(sender: AnyObject) {
        self.valueChanged = true
    }
    func loadTimeDate(){
        if self.toSetDateType == 0{
            if self.test.beginsOnNSDate != nil{
                self.datePicker.date = self.test.beginsOnNSDate
                self.timePicker.date = self.datePicker.date
            }
        }
        else{
            if self.test.expiresOnNSDate != nil{
                self.datePicker.date = self.test.expiresOnNSDate
                self.timePicker.date = self.datePicker.date
            }
        }
        self.valueChanged = false
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if self.valueChanged{
            self.setDateTime()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

}
