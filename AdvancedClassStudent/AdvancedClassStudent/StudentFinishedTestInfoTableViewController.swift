//
//  StudentFinishedTestInfoTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/3/22.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
class StudentFinishedTestInfoTableViewController: UITableViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var endsOnLabel: UILabel!
    @IBOutlet weak var beginsOnLabel: UILabel!
    weak var test = StudentTestHelper.defaultHelper.currentTest
    weak var testHelper = StudentTestHelper.defaultHelper
    
    override func viewDidLoad() {
        let e = self.test!.expiresOn
        self.endsOnLabel.text = e == "" ? "无" : e
        self.beginsOnLabel.text = self.test!.beginsOn
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1{
            self.testHelper!.getMyTestResult(self.test!){
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.performSegueWithIdentifier("ShowTestResult", sender: self)
                }
            }
        }
    }
    
    

}