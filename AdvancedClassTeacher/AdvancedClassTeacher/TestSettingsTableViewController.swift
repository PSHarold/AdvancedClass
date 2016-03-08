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
    @IBOutlet weak var deadlineLabel: UILabel!
    var timeLimit:Dictionary<String,Int>?
    @IBOutlet weak var messageText: UITextField!
    let hud = MBProgressHUD()
    var randomNumber:Int?
    weak var testHelper = TeacherTestHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        hintCell.accessoryView = hintSwitch
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTimeLimit()
        self.loadRandomNumber()
        self.loadDeadline()
    }
    func testUploaded() {
        self.hud.removeFromSuperview()
        let alertController = UIAlertController(title: nil, message: "发送成功！", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {Void in self.navigationController!.popViewControllerAnimated(true)}))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
   
    func sendTest(){
        self.testHelper.newTest.hasHint = self.hintSwitch.on
        self.testHelper.newTest.message = self.messageText.text!
        testHelper.uploadTest()
      
    }
    
    func loadDeadline(){
        if let date = self.testHelper.newTest.deadlineDate{
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            self.deadlineLabel.text = dateFormatter.stringFromDate(date)
        }
        else{
            self.deadlineLabel.text = "无"
        }
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
        
            
        case 4:
            if indexPath.row == 0{
                self.hud.mode = .Indeterminate
                self.hud.labelText = "正在发送"
                self.view.addSubview(self.hud)
                self.hud.show(true)
                self.sendTest()
            }
            else{
                self.navigationController?.popViewControllerAnimated(true)
            }
            
        default:
            return
        }
    }
}
