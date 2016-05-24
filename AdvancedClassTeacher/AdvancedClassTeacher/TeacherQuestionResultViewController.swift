//
//  TeacherQuestionResultViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/31.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit
import Charts
class TeacherQuestionResultViewController: UIViewController, ChartViewDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var pieChartView: PieChartView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var tableView: UITableView!
    
    weak var testHelper = TeacherTestHelper.defaultHelper
    weak var test = TeacherTestHelper.defaultHelper.currentTest
    weak var knowledgePointResult: KnowledgePointResult!
    var question: TeacherQuestion!
    var questionResult: QuestionResult!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(MultipleChoiceTableViewCell.self, forCellReuseIdentifier: "ChoiceCell")
        self.tableView.registerClass(QuestionContentTableViewCell.self, forCellReuseIdentifier: "ContentCell")
        let xib1 = UINib(nibName: "MultipleChoiceTableViewCell", bundle: nil)
        let xib2 = UINib(nibName: "QuestionContentTableViewCell", bundle: nil)
        self.tableView.registerNib(xib1, forCellReuseIdentifier: "ChoiceCell")
        self.tableView.registerNib(xib2, forCellReuseIdentifier: "ContentCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        
        self.pieChartView.delegate = self
        var xLabels = [String]()
        var yValues = [Double]()
        for i in 0..<self.question.choices.count{
            xLabels.append(String(Character(UnicodeScalar(65+i))))
            yValues.append(Double(self.questionResult.answersCount["\(i)"] ?? 0))
        }
        
        self.setChart(xLabels, values: yValues)
        self.pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)
    }
    
    
    func setChart(dataPoints: [String], values: [Double]) {
        self.pieChartView.usePercentValuesEnabled = true
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        pieChartView.data = pieChartData
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
    }
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1
        }
        else{
            return self.question.choices.count
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            cell.textLabel?.text = "难度：\(self.question!.difficultyString)"
            cell.detailTextLabel?.text = "抽到此题的人数：\(self.questionResult!.totalTaken ?? 0)"
            return cell
        }
        else if indexPath.section == 1{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! QuestionContentTableViewCell
            cell.content = self.question.content
            return cell
        }
        else{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as! MultipleChoiceTableViewCell
            cell.choiceNumber = indexPath.row
            cell.content = self.question.choices[indexPath.row]
            let count = self.questionResult.answersCount["\(indexPath.row+1)"] ?? 0
            cell.detailText = "\(count)人"
            return cell
        }
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 160
        }
        return 44
    }

    
    @IBAction func back(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
}
