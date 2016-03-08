////
////  TeacherAllResultsViewController.swift
////  AdvancedClassTeacher
////
////  Created by Harold on 15/10/11.
////  Copyright © 2015年 Harold. All rights reserved.
////
//
//import UIKit
//import Charts
//class TeacherAllResultsViewController: UIViewController, ChartViewDelegate {
//    @IBOutlet weak var barChartView: BarChartView!
//    var xLabels = [String]()
//    let testHelper = TeacherTestHelper.defaultHelper()
//    var test:TeacherTest!
//    var correctRate = [Double]()
//    var _currentQuestion:TeacherQuestion!
//    @IBOutlet weak var questionText: UITextView!
//    
//    @IBOutlet weak var detailButton: UIButton!
//    var currentQuestion:TeacherQuestion?{
//        get{
//            return self._currentQuestion
//        }
//        set{
//            self._currentQuestion = newValue
//            if newValue == nil{
//                self.questionText.text = ""
//                self.detailButton.enabled = false
//            }
//            else{
//                //self.questionText.enabled = false
//                self.detailButton.enabled = true
//                self.questionText.text = "题目：\n" + _currentQuestion.question
//            }
//            
//        }
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.barChartView.delegate = self
//        self.test = self.testHelper.testToView
//        for i in 0..<self.test.questionArray.count{
//            self.xLabels.append("第\(i+1)题")
//            self.correctRate.append(Double(self.test.questionArray[i].numberOfCorrect) / Double(self.test.resultsByStudentId.count) * 100)
//        }
//        self.currentQuestion = nil
//        self.setChart(self.xLabels, values: self.correctRate)
//        self.barChartView.animate(xAxisDuration: 2.0, yAxisDuration: 2.0)
//        
//    }
//    
//    @IBAction func showDetail(sender: AnyObject) {
//        self.performSegueWithIdentifier("ShowQuestionResult", sender: self)
//    }
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        let next = segue.destinationViewController as! TeacherQuestionResultViewController
//        next.question = self.currentQuestion
//    }
//    func setChart(dataPoints: [String], values: [Double]) {
//        self.barChartView.noDataText = "You need to provide data for the chart."
//        var dataEntries: [BarChartDataEntry] = []
//        for i in 0..<dataPoints.count {
//            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//        self.barChartView.descriptionText = ""
//        let chartDataSet = BarChartDataSet(yVals: dataEntries, label: "正确率")
//        let chartData = BarChartData(xVals: dataPoints, dataSet: chartDataSet)
//        self.barChartView.data = chartData
//        self.barChartView.xAxis.labelPosition = .Bottom
//        self.barChartView.scaleYEnabled = false
//        
//        
//        barChartView.drawGridBackgroundEnabled = false
//    }
//    
//    
//    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
//        self.currentQuestion = self.test.questionArray[entry.xIndex]
//    }
//}
