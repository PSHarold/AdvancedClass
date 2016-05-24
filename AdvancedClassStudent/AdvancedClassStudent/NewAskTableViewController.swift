//
//  NewAskTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/9.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class NewAskTableViewController: UITableViewController, PopUpPickerViewDelegate, UIPickerViewDelegate {
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var timeLabel: UILabel!
    var times = StudentCourse.currentCourse.timesAndRooms
    var pickerView = PopUpPickerView()
    var availableWeeks = [Int]()
    var availableDays = [Int]()
    var availablePeriods = [Int]()
    var selectedWeekNo: Int!
    var selectedDayNo: Int!
    var selectedPeriodNo: Int!
    var pickerViewShowing = false
    var ask = AskForLeave()
    var courseHelper = StudentCourseHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        self.availableWeeks = self.times.getAvailableWeeks(.Future)
        self.availableDays = self.times.getAvailableDaysInWeek(self.availableWeeks[0], mode: .Future)
        self.selectedWeekNo = self.availableWeeks[0]
        self.availablePeriods = self.times.getAvailablePeriodInWeek(self.selectedWeekNo, andDay: self.availableDays[0])
        self.pickerView = PopUpPickerView()
        self.pickerView.delegate = self
        if let window = UIApplication.sharedApplication().keyWindow {
            window.addSubview(pickerView)
        }
        else {
            self.view.addSubview(pickerView)
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.pickerView.endPicker()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0{
            self.reasonTextView.resignFirstResponder()
            self.pickerViewShowing = true
            self.pickerView.showPicker()
        }
        else if indexPath.section == 2{
            if self.ask.weekNo == nil || self.ask.dayNo == nil || self.ask.periodNo == nil{
                let alert = UIAlertController(title: nil, message: "请选择请假时段！", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return

            }
            if self.reasonTextView.text == nil || self.reasonTextView.text == ""{
                let alert = UIAlertController(title: nil, message: "请填写请假原因！", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            self.ask.reason = self.reasonTextView.text
            self.courseHelper.askForLeave(ask, course: StudentCourse.currentCourse){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    let alert = UIAlertController(title: nil, message: "提交成功！", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: {_ in self.navigationController?.popViewControllerAnimated(true)}))
                    self.presentViewController(alert, animated: true, completion: nil)
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
    
    
    func pickerView(pickerView: UIPickerView, didSelect numbers: [Int]) {
        self.ask.reason = self.reasonTextView.text
        self.ask.weekNo = self.availableWeeks[numbers[0]]
        self.ask.dayNo = self.availableDays[numbers[1]]
        self.ask.periodNo = self.availablePeriods[numbers[2]]
        self.timeLabel.text = "第\(self.ask.weekNo)周 周\(self.ask.dayNo) 第\(self.ask.periodNo)节"

    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.selectedWeekNo = self.availableWeeks[row]
            self.availableDays = self.times.getAvailableDaysInWeek(self.selectedWeekNo, mode: .Future)
            self.pickerView.pickerView.reloadComponent(1)
        case 1:
            self.selectedDayNo = self.availableDays[row]
            self.availablePeriods = self.times.getAvailablePeriodInWeek(self.selectedWeekNo, andDay: self.availableDays[row])
            self.pickerView.pickerView.reloadComponent(2)
        case 2:
            self.selectedPeriodNo = self.availablePeriods[row]
        default:
            break
        }
    }
    
    
}
