//
//  NewStatusAsksTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/8.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class NewStatusAsksTableViewController: UITableViewController {

    let me = StudentAuthenticationHelper.defaultHelper.me
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(NewStatusAskTableViewCell.self, forCellReuseIdentifier: "cell")
        let xib = UINib(nibName: "NewStatusAskTableViewCell", bundle: nil)
        self.tableView.registerNib(xib, forCellReuseIdentifier: "cell")
    
    }

   

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = me.newStatusAsks.count
        if count == 0{
            self.navigationController?.popViewControllerAnimated(true)
        }
        return count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! NewStatusAskTableViewCell
        let ask = self.me.newStatusAsks[indexPath.row]
        let course = self.me.courseDict[ask.courseId]
        if let course = course{
            cell.courseName = course.name
            cell.timeString = "第\(ask.weekNo)周 周\(ask.dayNo) 第\(ask.periodNo)节"
            cell.status = ask.status
        }
        return cell
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
       // let authHelper = StudentAuthenticationHelper.defaultHelper
//        authHelper.readNewStatusAsks{
//            error in
//            
//        }
    }

}
