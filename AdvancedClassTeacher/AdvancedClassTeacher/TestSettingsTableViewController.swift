//
//  TestSettingsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/8/17.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TestSettingsTableViewController: UITableViewController {

    
    @IBOutlet weak var timeLimitLabel: UILabel!
    @IBOutlet weak var expiresOnLabel: UILabel!
    @IBOutlet weak var beginsOnLabel: UILabel!
    
   
    var timeLimit: Dictionary<String,Int>?
    weak var test = TeacherTestHelper.defaultHelper.newTest
    weak var testHelper = TeacherTestHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadTimeLimit()
        self.loadDateTime()
    }
 
    
    
    func loadDateTime(){
        let beginsOn = self.testHelper!.newTest.beginsOn
        let expiresOn = self.testHelper!.newTest.expiresOn
        let s1 =  beginsOn == "" ? "现在" : beginsOn
        let s2 =  expiresOn == "" ? "无" : expiresOn
        self.beginsOnLabel.text = s1
        self.expiresOnLabel.text = s2
    }
    
    func loadTimeLimit() {
        let timeLimit = self.test!.timeLimit
        if timeLimit <= 0{
            timeLimitLabel.text = "无时限"
            return
        }
        
        self.timeLimitLabel.text = timeLimit.toTimeString()
        
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        
        if indexPath.section == 2{
            self.testHelper!.postNewTest{
                [unowned self]
                (error) in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.showHudWithText("发布成功！")
                }
            }
        }
    }
    
    
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let vc = segue.destinationViewController as? TestDateTimeSettingsTableViewController
        if let vc = vc{
            if segue.identifier == "SetBeginsOn"{
                vc.toSetDateType = 0
            }
            else{
                vc.toSetDateType = 1
            }
        }
        
    }
    
    
    
    
    
}
