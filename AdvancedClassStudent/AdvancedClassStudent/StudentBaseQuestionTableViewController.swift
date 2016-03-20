//
//  StudentBaseQuestionTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/3/20.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class StudentBaseQuestionTableViewController: UITableViewController {

    var page = -1
    var question: StudentQuestion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView = UITableView(frame: self.tableView.frame, style: .Grouped)
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorInset = UIEdgeInsetsZero

    }
}
