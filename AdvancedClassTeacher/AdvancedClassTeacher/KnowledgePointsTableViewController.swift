//
//  KnowledgePointsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/1.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class KnowledgePointsTableViewController: UITableViewController {

    var testHelper = TeacherTestHelper.defaultHelper()
    var selectedKnowledgePointNo:NSIndexPath?
    var delegate:KnowledgePointsDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "第\(self.testHelper.knowledgePoints.chapters[section].chapterNo)章"
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.testHelper.knowledgePoints.chapters.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testHelper.knowledgePoints.chapters[section].points.count
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.navigationController?.popViewControllerAnimated(true)
        delegate.setKnowledgePoints(indexPath)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 

        cell.textLabel?.text = self.testHelper.knowledgePoints.chapters[indexPath.section].points[indexPath.row]
        if let indexPath2 = self.selectedKnowledgePointNo{
            if indexPath.section == indexPath2.section && indexPath.row == indexPath2.row{
                cell.accessoryType = .Checkmark
            }
        }
        return cell
    }

    
}
