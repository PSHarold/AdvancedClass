//
//  TestTimeLimitSettingsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/8/17.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TestTimeLimitSettingsTableViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate{
    
    var hasLimit = false
    @IBOutlet weak var timeLimitCell: UITableViewCell!
    var _pickerView: UIPickerView!
    var pickerView: UIPickerView!{
        get{
            return self._pickerView
        }
        set{
            if self._pickerView != nil{
                return
            }
            self._pickerView = newValue
            self._pickerView.dataSource = self
            self._pickerView.delegate = self
        }
    }
    
    var _timeLimitSwitch: UISwitch!
    var timeLimitSwitch: UISwitch!{
        get{
            return self._timeLimitSwitch
        }
        set{
            if self._timeLimitSwitch != nil{
                return
            }
            self._timeLimitSwitch = newValue
            self._timeLimitSwitch.addTarget(self, action: "switchToggled:", forControlEvents: .ValueChanged)
        }
    }
    var hasTimeLimit:Bool = true
    weak var testHelper = TeacherTestHelper.defaultHelper
    weak var test = TeacherTestHelper.defaultHelper.newTest
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hasLimit = self.test!.timeLimit > 0
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }
        else{
            if self.hasLimit{
                return 1
            }
            else{
                return 0
            }
        }
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath)
            self.timeLimitSwitch = cell.viewWithTag(666) as! UISwitch
            self.timeLimitSwitch.on = self.hasLimit
            return cell
        }
        else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("PickerCell", forIndexPath: indexPath)
            self.pickerView = cell.viewWithTag(666) as! UIPickerView
            let timeComponents = self.test!.timeLimit.toTimeComponents()
            self.pickerView.selectRow(timeComponents.0, inComponent: 0, animated: false)
            self.pickerView.selectRow(timeComponents.1, inComponent: 1, animated: false)
            self.pickerView.selectRow(timeComponents.2, inComponent: 2, animated: false)
            return cell
        }
    }
    
    //返回到上级菜单
    override func viewWillDisappear(animated: Bool) {
        
        if self.timeLimitSwitch.on{
            if self.pickerView.selectedRowInComponent(0) == 0 && self.pickerView.selectedRowInComponent(1) == 0 && self.pickerView.selectedRowInComponent(2) == 0{
                self.test!.timeLimit = 0
            }
            else{
                self.test!.timeLimit = self.pickerView.selectedRowInComponent(0)*3600 + self.pickerView.selectedRowInComponent(1)*60 + self.pickerView.selectedRowInComponent(2)
            }
            
        }
        else{
            self.test!.timeLimit = 0
        }
    }
    
    
    //开关值变化
    func switchToggled(sender: UISwitch){
        self.hasLimit = sender.on
        self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .Automatic)
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 250.0
        }
        return 44.0
    }
    
    //选择器内容控制
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        if !self.hasTimeLimit{
            return NSAttributedString(string: "无时限")
        }
        var temp = ""
        if component == 0{
            temp = "小时"
        }
        if component == 1{
            temp = "分钟"
        }
        if component == 2{
            temp = "秒"
        }
        return NSAttributedString(string: "\(row)"+temp)
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if !self.hasTimeLimit{
            return 1
        }
        if component == 0{
            return 24
        }
        if component == 1{
            return 60
        }
        if component == 2{
            return 60
        }
        return 0
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        if !self.hasTimeLimit{
            return 1
        }
        return 3
    }
   
   
}
