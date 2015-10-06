//
//  ChartViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/1.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    @IBOutlet var chartView: BarChartView!
    override func viewDidLoad() {
        super.viewDidLoad()
        chartView.noDataText = "无图表"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
