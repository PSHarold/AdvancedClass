//
//  TeacherTestResultViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/22.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherTestResultViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    weak var test = TeacherTestHelper.defaultHelper.currentTest
    weak var testResult = TeacherTestHelper.defaultHelper.currentTest.results
    weak var testHelper = TeacherTestHelper.defaultHelper
    @IBOutlet var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testResult!.knowledgePointResults.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let pointId = self.testResult!.knowledgePointResultsSorted[indexPath.row].knowledgePointId
        let point = TeacherCourse.currentCourse.syllabus.knowledgePoints[pointId]!

        cell.textLabel?.text = point.content
        cell.detailTextLabel?.text = "\(self.testResult!.knowledgePointResultsSorted[indexPath.row].correctRatio)%"
        return cell
    }
    

    

}
