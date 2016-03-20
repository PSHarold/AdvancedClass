//
//  TableViewController.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/15.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
import Alamofire
class StudentMultipleChoiceTableViewController: StudentBaseQuestionTableViewController,UIAlertViewDelegate{
    var choiceCells = [StudentMultipleChoiceTableViewCell]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(StudentMultipleChoiceTableViewCell.self, forCellReuseIdentifier: "ChoiceCell")
        self.tableView.registerClass(StudentQuestionContentTableViewCell.self, forCellReuseIdentifier: "ContentCell")
        let xib = UINib(nibName: "StudentMultipleChoiceTableViewCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "ChoiceCell")
        let xib2 = UINib(nibName: "StudentQuestionContentTableViewCell", bundle: nil)
        self.tableView.registerNib(xib2, forCellReuseIdentifier: "ContentCell")
        self.tableView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = UITableViewCell(style: .Value1, reuseIdentifier: "InfoCell")
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        case 1:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! StudentQuestionContentTableViewCell
            cell.content = self.question.content
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        case 2:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("ChoiceCell", forIndexPath: indexPath) as! StudentMultipleChoiceTableViewCell
            cell.choiceNumber = indexPath.row
            cell.content = self.question.choices[indexPath.row]
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2{
            return self.question.choices.count
        }
        else{
            return 1
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 44.0
        }
        if indexPath.section == 1{
            return 200
        }
        return 55
    }

}
