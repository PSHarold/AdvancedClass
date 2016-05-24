//
//  TeacherFinishedTestInfoTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/22.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
class TeacherFinishedTestInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var testTypeLabel: UILabel!
    @IBOutlet weak var finishedCountLabel: UILabel!
    @IBOutlet weak var endsOnLabel: UILabel!
    @IBOutlet weak var beginsOnLabel: UILabel!
    weak var test = TeacherTestHelper.defaultHelper.currentTest
    weak var testHelper = TeacherTestHelper.defaultHelper
    
    override func viewDidLoad() {
        self.testTypeLabel.text = self.test!.testTypeEnum.description
        self.finishedCountLabel.text = "\(self.test!.finishedCount)"
        let e = self.test!.expiresOn
        self.endsOnLabel.text = e == "" ? "无" : e
        self.beginsOnLabel.text = self.test!.beginsOn
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 2{
            self.testHelper!.getTestResults(self.test!){
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.performSegueWithIdentifier("ShowTestResults", sender: self)
                }
            }
        }
        else if indexPath.section == 3{
            self.testHelper!.getUntakenStudents(self.test!){
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.performSegueWithIdentifier("ShowStudents", sender: self)
                }
            }
        }
    }
    
    

}