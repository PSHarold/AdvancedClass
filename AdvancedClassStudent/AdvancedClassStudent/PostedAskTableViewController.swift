//
//  PostedAskTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/9.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class PostedAskTableViewController: UITableViewController {
    var ask: AskForLeave!
    var times = StudentCourse.currentCourse.timesAndRooms
    @IBOutlet weak var viewedAtLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var reasonTextView: UITextView!
    @IBOutlet weak var askTimeLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createdAtLabel.text = self.ask.createdAt
        self.reasonTextView.text = self.ask.reason
        self.askTimeLabel.text = "第\(self.ask.weekNo)周 周\(self.ask.dayNo) 第\(self.ask.periodNo)节"
        switch self.ask.status! {
        case .PENDING:
            self.statusLabel.textColor = UIColor.orangeColor()
            self.statusLabel.text = "待审核"
        case .APPROVED:
            self.statusLabel.textColor = UIColor.greenColor()
            self.statusLabel.text = "已批准"
        case .DISAPPROVED:
            self.statusLabel.textColor = UIColor.redColor()
            self.statusLabel.text = "不批准"
        }
        if self.ask.viewdAt == ""{
            self.viewedAtLabel.text = "无"
            self.viewedAtLabel.textColor = UIColor.grayColor()
        }
        else{
            self.viewedAtLabel.text = self.ask.viewdAt
            self.viewedAtLabel.textColor = UIColor.blackColor()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
