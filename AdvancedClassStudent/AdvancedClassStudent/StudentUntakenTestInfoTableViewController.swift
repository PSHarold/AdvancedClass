//
//  StudentTestInfoTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/10/5.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class StudentUntakenTestInfoTableViewController: UITableViewController {
    weak var test = StudentTestHelper.defaultHelper.currentTest
    
    @IBOutlet var beginsOnLabel: UILabel!
    @IBOutlet var endsOnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.beginsOnLabel.text = self.test!.beginsOn
        self.endsOnLabel.text = self.test!.expiresOn
       
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
}
