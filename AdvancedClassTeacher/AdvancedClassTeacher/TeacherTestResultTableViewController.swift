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
    weak var knowledgePointResult: KnowledgePointResult!
    var questionId: String!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.knowledgePointResultsAscending = self.testResult!.knowledgePointResultsAscending
        self.questionResultsAscending = self.testResult!.questionResultsAscending
        if self.byKnowledgePoints{
            self.sortBarButton.title = self.knowledgePointResultsAscending ? "降序" : "升序"
        }
        else{
            self.sortBarButton.title = self.questionResultsAscending ? "降序" : "升序"
        }
    }
    
    @IBOutlet var sortBarButton: UIBarButtonItem!
    
    var knowledgePointResultsAscending: Bool = true{
        didSet{
            self.testResult!.sortKnowledgePointResults(self.knowledgePointResultsAscending)
            self.tableView.reloadData()
            self.setSortBarButtonTitle()
        }
    }
    var questionResultsAscending: Bool = true{
        didSet{
            self.testResult!.sortQuestionPointResults(self.questionResultsAscending)
            self.tableView.reloadData()
            self.setSortBarButtonTitle()
        }
    }
    
    
    func setSortBarButtonTitle(){
        if self.byKnowledgePoints{
            self.sortBarButton.title = self.knowledgePointResultsAscending ? "降序" : "升序"
        }
        else{
            self.sortBarButton.title = self.questionResultsAscending ? "降序" : "升序"
        }
    }
    
    var byKnowledgePoints: Bool{
        get{
            return self.segmentedControl.selectedSegmentIndex == 0
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.byKnowledgePoints{
            return self.testResult!.knowledgePointResults.count
        }
        else{
            return self.testResult!.questionResults.count
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        if self.byKnowledgePoints{
            let pointId = self.testResult!.knowledgePointResultsSorted[indexPath.row].knowledgePointId
            let point = TeacherCourse.currentCourse.syllabus.knowledgePoints[pointId]!
            
            cell.textLabel?.text = point.content
            cell.detailTextLabel?.text = self.testResult!.knowledgePointResultsSorted[indexPath.row].correctRatio.toPercentageString()
            return cell
        }
        else{
            let questionId = self.testResult!.questionResultsSorted[indexPath.row].questionId
            let question = self.test!.questionsForResults[questionId]!
            let content = question.content
            let rangeOfDomain = content.startIndex..<content.startIndex.advancedBy(8)
            cell.textLabel?.text = content[rangeOfDomain] + "......"
            cell.detailTextLabel?.text = self.test!.results.getQuestionResult(question)!.correctRatio.toPercentageString()
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.byKnowledgePoints{
            self.knowledgePointResult = self.test!.results.knowledgePointResultsSorted[indexPath.row]
            
            self.performSegueWithIdentifier("ShowKnowledgePointResult", sender: self)
        }
        else{
            self.questionId = self.test!.results.questionResultsSorted[indexPath.row].questionId
            self.performSegueWithIdentifier("ShowQuestionResult", sender: self)
        }
        
    }
    
    
    
    @IBAction func segmentIndexChanged(sender: UISegmentedControl) {
        self.tableView.reloadData()
        self.setSortBarButtonTitle()
    }
    @IBAction func sortBarButtonTapped(sender: UIBarButtonItem) {
        if self.byKnowledgePoints{
            self.knowledgePointResultsAscending = !self.knowledgePointResultsAscending
        }
        else{
            self.questionResultsAscending = !self.questionResultsAscending
        }
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowKnowledgePointResult"{
            let vc = segue.destinationViewController as! TeacherQuestionsInKnowledgePointResultTableViewController
            vc.knowledgePointResult =  self.knowledgePointResult
        }
        else if segue.identifier == "ShowQuestionResult"{
            let vc = segue.destinationViewController as! TeacherQuestionResultViewController
            let question = self.test!.questionsForResults[self.questionId]!
            let questionResult = self.test!.results.questionResults[self.questionId]!
            vc.questionResult = questionResult
            vc.question = question
        }
    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }


}
