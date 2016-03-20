//
//  TeacherTestsViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherTestsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    weak var currentCourse = TeacherCourse.currentCourse
    weak var testHelper = TeacherTestHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(TestOnGoingTableViewCell.self, forCellReuseIdentifier: "OnGoingTestCell")
        let nib = UINib(nibName: "TestOnGoingTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "OnGoingTestCell")
        self.testHelper!.getUnfinishedTestsInCourse(self.currentCourse!) {
            [unowned self]
            (error) in
            if let error = error{
                self.showError(error)
            }
            else{
                self.tableView.dataSource = self
                self.tableView.delegate = self
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
            
        }
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let test = self.currentCourse!.unfinishedTests[indexPath.row]
        let cell = self.tableView.dequeueReusableCellWithIdentifier("OnGoingTestCell", forIndexPath: indexPath) as! TestOnGoingTableViewCell
        cell.createdOnLabel.text = test.createdOn
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCourse!.unfinishedTests.count
    }
}
