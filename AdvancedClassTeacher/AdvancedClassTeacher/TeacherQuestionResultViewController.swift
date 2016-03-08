////
////  TeacherQuestionResultViewController.swift
////  AdvancedClassTeacher
////
////  Created by Harold on 15/10/11.
////  Copyright © 2015年 Harold. All rights reserved.
////
//
//import UIKit
//import Charts
//class TeacherQuestionResultViewController: UIViewController, ChartViewDelegate{
//    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var pieChartView: PieChartView!
//    var question:TeacherQuestion!
//    let testHelper = TeacherTestHelper.defaultHelper()
//    var xValues:[String]!
//    var yValues:[Double]!
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        //self.tableView.delegate = self
//        self.pieChartView.delegate = self
//        if self.testHelper.testToView.timeLimitDict == nil{
//            self.xValues = ["A","B","C","D"]
//        }
//        else{
//            self.xValues = ["A","B","C","D","未作答"]
//        }
//        self.yValues = [Double]()
//        for sub in self.xValues{
//            self.yValues.append(Double(self.question.numberOfChoice[sub]!))
//        }
//        self.setChart(self.xValues, values: self.yValues)
//        // Do any additional setup after loading the view.
//    }
//    
//    func setChart(dataPoints: [String], values: [Double]){
//        self.pieChartView.usePercentValuesEnabled = true
//        var dataEntries: [ChartDataEntry] = []
//        
//        for i in 0..<dataPoints.count {
//            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
//            dataEntries.append(dataEntry)
//        }
//        
//        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "")
//        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
//        pieChartView.data = pieChartData
//        
//        var colors: [UIColor] = []
//        
//        for _ in 0..<dataPoints.count {
//            let red = Double(arc4random_uniform(256))
//            let green = Double(arc4random_uniform(256))
//            let blue = Double(arc4random_uniform(256))
//            
//            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
//            colors.append(color)
//        }
//        
//        pieChartDataSet.colors = colors
//        
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
//    }
//}
