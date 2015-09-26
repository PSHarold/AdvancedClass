//
//  TestSettingsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/8/17.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TestSettingsTableViewController: UITableViewController,TeacherTestHelperDelegate {

    @IBOutlet weak var randomCell: UITableViewCell!
    @IBOutlet weak var timeLimitCell: UITableViewCell!
    @IBOutlet weak var hintCell: UITableViewCell!
    var hintSwitch = UISwitch()
    var timeLimit:Dictionary<String,Int>?
    var randomNumber:Int?
    var testHelper = TeacherTestHelper.defaultHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        hintCell.accessoryView = hintSwitch
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.testHelper.delegate = self
        self.loadTimeLimit()
        self.loadRandomNumber()
    }
    func testUploaded() {
        let alert = UIAlertView()
        alert.addButtonWithTitle("确定")
        alert.message = "发送成功！"
        alert.show()
        self.navigationController?.popViewControllerAnimated(true)
    }
    func networkError() {
        let alert = UIAlertView()
        alert.addButtonWithTitle("确定")
        alert.message = "网络错误！"
        alert.show()
    }
    func sendTest(){
        self.testHelper.newTest.hasHint = self.hintSwitch.on
        testHelper.uploadTest()
      
    }
    
    func loadRandomNumber(){
        if self.testHelper.newTest.randomNumber == 0{
            self.randomCell.detailTextLabel?.text = "关"
            return
        }
        self.randomCell.detailTextLabel?.text = "\(self.testHelper.newTest.randomNumber)道"
    }
    func loadTimeLimit() {
        
        if let timeLimit = self.testHelper.newTest.timeLimitDict{
            if timeLimit["hour"]==0 && timeLimit["minute"]==0 && timeLimit["second"]==0{
                timeLimitCell.detailTextLabel?.text = "无时限"
                return
            }
            let hour = timeLimit["hour"]!
            let minute = timeLimit["minute"]!
            let second = timeLimit["second"]!
            let s1 = hour == 0 ? "" : "\(hour)小时"
            var s2 = "\(minute)分钟"
            let s3 = "\(second)秒"
            if hour == 0 && minute == 0{
                s2 = ""
            }
            self.timeLimitCell.detailTextLabel?.text = s1 + s2 + s3
        }
            else{
                self.timeLimitCell.detailTextLabel?.text = "无时限"
            }
    }
    
    func setRandomNumber(number:Int?){
        if let randomNumber = number{
            self.randomNumber = randomNumber
            self.randomCell.detailTextLabel?.text = "\(number)道"
        }
        else{
            self.randomCell.detailTextLabel?.text = "关"
            self.randomNumber = nil
        }
    }
    
    
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch indexPath.section{
        
        case 3:
            self.navigationController?.popViewControllerAnimated(true)
        case 4:
            self.sendTest()
        default:
            return
        }
    }
}
