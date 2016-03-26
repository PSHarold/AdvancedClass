//
//  TeacherQuestionsResultTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/25.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit
import Charts
class TeacherQuestionsInKnowledgePointResultTableViewController: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var barChartView: BarChartView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    var xLabels = [String]()
    weak var testHelper = TeacherTestHelper.defaultHelper
    weak var test = TeacherTestHelper.defaultHelper.currentTest
    weak var knowledgePointResult: KnowledgePointResult!
    var correctRates = [Double]()
    var currentQuestion: TeacherQuestion?
    var currentQuestionResult: QuestionResult?
    var questionMode: Bool{
        return self.segmentedControl.selectedSegmentIndex == 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let labelOrigin = CGPointMake(self.tableView.bounds.width/2, self.tableView.bounds.height/2)
        let label = UILabel()
        label.text = "点击下方柱状图条目查看问题"
        label.textAlignment = .Center
        label.frame.origin = labelOrigin
        self.tableView.backgroundView = label
        
        self.tableView.registerClass(MultipleChoiceTableViewCell.self, forCellReuseIdentifier: "ChoiceCell")
        self.tableView.registerClass(QuestionContentTableViewCell.self, forCellReuseIdentifier: "ContentCell")
        let xib1 = UINib(nibName: "MultipleChoiceTableViewCell", bundle: nil)
        let xib2 = UINib(nibName: "QuestionContentTableViewCell", bundle: nil)
        self.tableView.registerNib(xib1, forCellReuseIdentifier: "ChoiceCell")
        self.tableView.registerNib(xib2, forCellReuseIdentifier: "ContentCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.barChartView.delegate = self
        for i in 0..<self.knowledgePointResult.questionResultsSorted.count{
            self.xLabels.append("第\(i+1)题")
            self.correctRates.append(self.knowledgePointResult.questionResultsSorted[i].correctRatio*100)
        }
        
        self.setChart(self.xLabels, values: self.correctRates)
        self.barChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        self.barChartView.noDataText = "You need to provide data for the chart."
        var dataEntries: [BarChartDataEntry] = []
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        self.barChartView.descriptionText = ""
        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "正确率")
        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
        self.barChartView.data = chartData
        self.barChartView.xAxis.labelPosition = .Bottom
        self.barChartView.scaleYEnabled = false
        
        
        barChartView.drawGridBackgroundEnabled = false
    }
    
    
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        self.currentQuestionResult = self.knowledgePointResult.questionResultsSorted[entry.xIndex]
        self.currentQuestion = self.test?.questionsForResults[self.currentQuestionResult!.questionId]
        self.reloadTableView()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.currentQuestion == nil || self.currentQuestionResult == nil{
            return 0
        }
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.questionMode{
            if section == 0{
                return 1
            }
            else{
                return self.currentQuestion!.choices.count
            }
        }
        else{
            return 1
        }
    }

    

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if self.questionMode{
            if indexPath.section == 0{
                let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                cell.textLabel?.text = "抽到此题的人数"
                cell.detailTextLabel?.text = "\(self.currentQuestionResult?.totalTaken ?? 0)"
                return cell
            }
            else{
                let cell = self.tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as! MultipleChoiceTableViewCell
                cell.choiceNumber = indexPath.row
                cell.content = self.currentQuestion!.choices[indexPath.row]
                let count = self.currentQuestionResult!.answersCount["\(indexPath.row+1)"] ?? 0
                cell.detailText = "\(count)人"
                return cell
            }
        }
        else{
            if indexPath.section == 0{
                let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
                cell.textLabel?.text = "难度"
                cell.detailTextLabel?.text = self.currentQuestion!.difficultyString
                return cell
            }
            else{
                let cell = self.tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! QuestionContentTableViewCell
                cell.content = self.currentQuestion!.content
                return cell
            }
            
        }
        
    
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if self.questionMode{
            return 44
        }
        else{
            if indexPath.section == 0{
                return 44
            }
            return 160
        }
    }
    @IBAction func SegmentValueChanged(sender: UISegmentedControl) {
        self.reloadTableView()
    }
    
    func reloadTableView(){
        self.tableView.backgroundView?.hidden = self.currentQuestionResult != nil && self.currentQuestion != nil
        self.tableView.reloadData()
        
    }
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
