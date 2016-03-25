//
//  TeacherTestResultStudentsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/25.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherTestResultStudentsTableViewController: UITableViewController {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    weak var courseHelper = TeacherTestHelper.defaultHelper
    weak var test = TeacherTestHelper.defaultHelper.currentTest
    var showTaken: Bool{
        get{
            return self.segmentedControl.selectedSegmentIndex == 0
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if self.showTaken{
            return self.test!.results.takenStudents.count
        }
        else{
            return self.test!.results.untakenStudents.count
        }
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if self.showTaken{
            cell.textLabel?.text = self.test!.results.takenStudents[indexPath.row]
        }
        else{
            cell.textLabel?.text = self.test!.results.untakenStudents[indexPath.row]
        }
        return cell
    }
    
   
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
}
