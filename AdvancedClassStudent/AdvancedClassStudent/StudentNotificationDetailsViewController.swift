//
//  StudentNotificationDetailsTableViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/10/3.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class StudentNotificationDetailsTableViewController: UITableViewController {
    var notification:Notification!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var contentText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.timeLabel.text = self.notification.time
        self.titleLabel.text = self.notification.title
        self.contentText.text = self.notification.content
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    
    
}
