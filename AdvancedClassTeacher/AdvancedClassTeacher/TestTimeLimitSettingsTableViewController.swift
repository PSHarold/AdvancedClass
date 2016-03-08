////
////  TestTimeLimitSettingsTableViewController.swift
////  AdvancedClassTeacher
////
////  Created by Harold on 15/8/17.
////  Copyright (c) 2015年 Harold. All rights reserved.
////
//
//import UIKit
//
//class TestTimeLimitSettingsTableViewController: UITableViewController,UIPickerViewDataSource,UIPickerViewDelegate{
//    
//    
//    @IBOutlet weak var timeLimitCell: UITableViewCell!
//    @IBOutlet weak var pickerview: UIPickerView!
//    
//    
//    var timeLimitSwitch = UISwitch()
//    var hasTimeLimit:Bool = true
//    var testHelper = TeacherTestHelper.defaultHelper()
//    var timeLimit:Dictionary<String,Int>?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        timeLimitSwitch.on = true
//        pickerview.delegate = self
//        pickerview.dataSource = self
//        timeLimitCell.accessoryView = timeLimitSwitch
//        timeLimitSwitch.addTarget(self, action: "switchToggled", forControlEvents: UIControlEvents.ValueChanged)
//        
//        //获取上级菜单的时限设置，调整选择器及开关
//        if let time = self.testHelper.newTest.timeLimitDict{
//            pickerview.selectRow(time["hour"]!, inComponent: 0, animated: false)
//            pickerview.selectRow(time["minute"]!, inComponent: 1, animated: false)
//            pickerview.selectRow(time["second"]!, inComponent: 2, animated: false)            
//        }
//        else{
//            timeLimitSwitch.on = false
//            switchToggled()
//        }
//    }
//    
//    //返回到上级菜单
//    override func viewWillDisappear(animated: Bool) {
//        //通知上级菜单设置时限
//        if self.timeLimitSwitch.on{
//            if self.pickerview.selectedRowInComponent(0) == 0 && self.pickerview.selectedRowInComponent(1) == 0 && self.pickerview.selectedRowInComponent(2) == 0{
//                self.testHelper.newTest.timeLimitDict = nil
//            }
//            else{
//                self.testHelper.newTest.timeLimitDict = ["hour":self.pickerview.selectedRowInComponent(0),"minute":self.pickerview.selectedRowInComponent(1),"second":self.pickerview.selectedRowInComponent(2)]
//            }
//            
//        }
//        else{
//            self.testHelper.newTest.timeLimitDict = nil
//        }
//    }
//    
//    
//    //开关值变化
//    func switchToggled(){
//        if self.timeLimitSwitch.on{
//            self.hasTimeLimit = true
//        }
//        else{
//            self.hasTimeLimit = false
//        }
//        pickerview.reloadAllComponents()
//    }
//    
//    
//    
//    //选择器内容控制
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        if !self.hasTimeLimit{
//            return NSAttributedString(string: "无时限")
//        }
//        var temp = ""
//        if component == 0{
//            temp = "小时"
//        }
//        if component == 1{
//            temp = "分钟"
//        }
//        if component == 2{
//            temp = "秒"
//        }
//        return NSAttributedString(string: "\(row)"+temp)
//    }
//    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        if !self.hasTimeLimit{
//            return 1
//        }
//        if component == 0{
//            return 24
//        }
//        if component == 1{
//            return 60
//        }
//        if component == 2{
//            return 60
//        }
//        return 0
//    }
//    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
//        if !self.hasTimeLimit{
//            return 1
//        }
//        return 3
//    }
//   
//   
//}
