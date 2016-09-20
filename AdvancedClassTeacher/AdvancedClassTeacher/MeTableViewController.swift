//
//  MeTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var teacherIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var emailCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let helper = TeacherAuthenticationHelper.defaultHelper
        let me = helper.me
        self.courseLabel.text = TeacherCourse.currentCourse.name
        self.teacherIdLabel.text = me.userId
        self.nameLabel.text = me.name
        self.genderLabel.text = me.genderString
        self.timeLabel.text = "第\(currentWeekNo)周  周\(currentDayNo)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let me = TeacherAuthenticationHelper.defaultHelper.me
        
        if me.email == ""{
            emailCell.detailTextLabel?.text = "未填写"
        }
        else if !me.emailActivated{
            emailCell.detailTextLabel?.text = "未激活"
        }
        else{
            emailCell.detailTextLabel?.text = ""
        }
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
    }
    
}
