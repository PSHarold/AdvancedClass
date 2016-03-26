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
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    weak var currentCourse = TeacherCourse.currentCourse
    weak var testHelper = TeacherTestHelper.defaultHelper
    var page = 0
    var acquiring = false
    var first = true
    var _refreshControl: UIRefreshControl?
    var refreshControl: UIRefreshControl{
        get{
            if self._refreshControl == nil{
                self._refreshControl = UIRefreshControl()
                self._refreshControl?.addTarget(self, action: #selector(TeacherTestsViewController.beginRefreshing), forControlEvents: .ValueChanged)
            }
            return self._refreshControl!
        }
    }
    
    var showFinished: Bool{
        get{
            return self.segmentedControl.selectedSegmentIndex == 1
        }
    }
    
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        if first{
            self.beginRefreshing()
            first = false
        }
        else{
            self.tableView.reloadData()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelOrigin = CGPointMake(self.tableView.bounds.width/2, self.tableView.bounds.height/2)
        let label = UILabel()
        label.text = "下拉刷新"
        label.textAlignment = .Center
        label.frame.origin = labelOrigin
        self.tableView.backgroundView = label
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        
        self.tableView.registerClass(TestTableViewCell.self, forCellReuseIdentifier: "TestCell")
        let nib = UINib(nibName: "TestTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TestCell")
        self.tableView.addSubview(self.refreshControl)
        self.beginRefreshing()
        
    }
    
    func beginRefreshing(){
        self.refreshControl.beginRefreshing()
        if self.showFinished{
            self.refreshFinishedTests()
        }
        else{
            self.refreshUnfinishedTests()
        }
    }
    
    func refreshUnfinishedTests(){
        self.testHelper!.getUnfinishedTestsInCourse(self.currentCourse!) {
            [unowned self]
            (error) in
            let label = self.tableView.backgroundView as! UILabel
            if let error = error{
                self.showError(error)
                if self.currentCourse!.unfinishedTests.count == 0{
                    let label = self.tableView.backgroundView as! UILabel
                    label.hidden = false
                    label.text = "网络错误，下拉重试"
                }
            }
            else{
                if self.currentCourse!.unfinishedTests.count == 0 {
                    label.hidden = false
                    label.text = "无测验，下拉刷新"
                }
                else{
                    label.hidden = true
                }
                if !self.showFinished{
                    self.tableView.reloadData()

                }
            }
            self.refreshControl.endRefreshing()
            
        }

    }
    
    
    func refreshFinishedTests(){
        self.acquiring = true
        self.testHelper!.getFinishedTestsInCourse(self.currentCourse!, page: 1){
            [unowned self]
            error in
            let label = self.tableView.backgroundView as! UILabel
            if let error = error{
                self.showError(error)
                if self.currentCourse!.finishedTests.count == 0{
                    label.hidden = false
                    label.text = "网络错误，下拉重试"
                }
            }
            else{
                if self.currentCourse!.finishedTests.count == 0{
                    label.hidden = false
                    label.text = "无测验，下拉刷新"
                }
                else{
                    label.hidden = true
                    self.page = 1
                }
                if self.showFinished{
                    self.tableView.reloadData()
                }
            }
            self.refreshControl.endRefreshing()
        }

    }
    
    func loadFinishedTestsToPage(page: Int){
        self.acquiring = true
        self.testHelper!.getFinishedTestsInCourse(self.currentCourse!, page: page){
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
                if self.currentCourse!.finishedTests.count == 0{
                    let label = self.tableView.backgroundView as! UILabel
                    label.hidden = false
                    label.text = "网络错误，下拉重试"
                }
            }
            else{
                if self.currentCourse!.finishedTests.count == 0{
                    let label = self.tableView.backgroundView as! UILabel
                    label.hidden = false
                    label.text = "无测验，下拉刷新"
                }
                else{
                    self.tableView.reloadData()
                    self.page = page
                }
            }
            
        }

    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("TestCell", forIndexPath: indexPath) as! TestTableViewCell
        var test: TeacherTest
        if self.showFinished{
            test = self.currentCourse!.finishedTests[indexPath.row]
            
        }
        else{
            test = self.currentCourse!.unfinishedTests[indexPath.row]
        }
        cell.finished = test.finished
        cell.createdOnLabel.text = test.createdOn
        cell.progressView.totalNumber = self.currentCourse!.studentIds.count
        cell.progressView.currentNumber = test.finishedCount
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var number: Int
        if self.showFinished{
            number = self.currentCourse!.finishedTests.count
        }
        else{
            number = self.currentCourse!.unfinishedTests.count
        }
        let label = self.tableView.backgroundView as! UILabel

        if number == 0{
            label.hidden = false
            label.text = "无测验，下拉刷新"
        }
        else{
            label.hidden = true
        }
        return number
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if self.showFinished{
            self.testHelper!.currentTest = self.currentCourse!.finishedTests[indexPath.row]
            self.performSegueWithIdentifier("ShowFinishedTest", sender: self)
        }
        else{
            self.testHelper!.currentTest = self.currentCourse!.unfinishedTests[indexPath.row]
            self.performSegueWithIdentifier("ShowUnfinishedTest", sender: self)
            
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.showFinished{
            self.acquiring = false
        }
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if self.showFinished{
            if self.acquiring{
                return
            }
            let offsetY = scrollView.contentOffset.y
            let judgeOffsetY = scrollView.contentSize.height + scrollView.contentInset.bottom - scrollView.frame.height
            if offsetY >= judgeOffsetY{
                self.loadFinishedTestsToPage(self.page+1)
            }

        }
    }

}
