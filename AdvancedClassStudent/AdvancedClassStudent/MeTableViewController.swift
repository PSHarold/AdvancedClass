//
//  MeTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController {
  //  weak var faceHelper = FaceHelper.defaultHelper
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let helper = StudentAuthenticationHelper.defaultHelper
        let me = helper.me
        self.courseLabel.text = StudentCourse.currentCourse.name
        self.studentIdLabel.text = me.studentId
        self.nameLabel.text = me.name
        self.genderLabel.text = me.genderString
        self.classLabel.text = me.className
        self.timeLabel.text = "第\(currentWeekNo)周  周\(currentDayNo)"
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2{
            if indexPath.row == 0{
                self.showHudWithText("正在加载")
                FaceHelper.defaultHelper.getFaceImages{
                    [unowned self]
                    error in
                    if let error = error{
                        self.showError(error)
                    }
                    else{
                        self.hideHud()
                        self.performSegueWithIdentifier("ShowFaces", sender: self)
                    }
                }
            }
        }
        else if indexPath.section == 3{
            
        }
    }
}
