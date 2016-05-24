//
//  AttendanceListChoosePeriodTableViewController.swift
//  Face-Teacher
//
//  Created by Harold on 16/4/19.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class AttendanceListChoosePeriodTableViewController: UITableViewController, UIPickerViewDelegate {

    var times = TeacherCourse.currentCourse.timesAndRooms
    
    @IBOutlet weak var pickerView: UIPickerView!
    var availableWeeks = [Int]()
    var availableDays = [Int]()
    var availablePeriods = [Int]()
    var selectedWeekNo: Int!
    var selectedDayNo: Int!
    var selectedPeriodNo: Int!
    var courseHelper = TeacherCourseHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        self.availableWeeks = self.times.getAvailableWeeks(.Past)
        self.availableDays = self.times.getAvailableDaysInWeek(self.availableWeeks[0], mode: .Past)
        self.selectedWeekNo = self.availableWeeks[0]
        self.availablePeriods = self.times.getAvailablePeriodInWeek(self.selectedWeekNo, andDay: self.availableDays[0])
        self.selectedDayNo = self.availableDays[0]
        self.selectedPeriodNo = self.availablePeriods[0]
        self.pickerView.delegate = self
    }
    
   
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1{
            self.courseHelper.getAttendanceList(TeacherCourse.currentCourse, weekNo: self.selectedWeekNo, dayNo: self.selectedDayNo, periodNo: self.selectedPeriodNo){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    if let vc = self.storyboard?.instantiateViewControllerWithIdentifier("AttendanceListTableViewController"){
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
            
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 3
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.availableWeeks.count
        case 1:
            return self.availableDays.count
        case 2:
            return self.availablePeriods.count
        default:
            return 0
        }
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return "第\(self.availableWeeks[row])周"
        case 1:
            return "星期\(self.availableDays[row])"
        case 2:
            return "第\(self.availablePeriods[row])节"
        default:
            return ""
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.selectedWeekNo = self.availableWeeks[row]
            self.availableDays = self.times.getAvailableDaysInWeek(self.selectedWeekNo, mode: .Past)
            self.pickerView.reloadComponent(1)
        case 1:
            self.selectedDayNo = self.availableDays[row]
            self.availablePeriods = self.times.getAvailablePeriodInWeek(self.selectedWeekNo, andDay: self.availableDays[row])
            self.pickerView.reloadComponent(2)
            self.selectedPeriodNo = self.availablePeriods[0]
        case 2:
            self.selectedPeriodNo = self.availablePeriods[row]
        default:
            break
        }
    }


}
