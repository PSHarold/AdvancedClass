//
//  MeTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  //  weak var faceHelper = FaceHelper.defaultHelper
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var infoCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarClicked)))
        let helper = StudentAuthenticationHelper.defaultHelper
        let me = helper.me
        self.courseLabel.text = StudentCourse.currentCourse.name
        self.studentIdLabel.text = me.studentId
        self.nameLabel.text = me.name
      //  self.genderLabel.text = me.genderString
        self.classLabel.text = me.className
        self.timeLabel.text = "第\(currentWeekNo)周  周\(currentDayNo)"
        self.avatarImageView.layer.cornerRadius = self.avatarImageView.frame.size.width / 2
        self.avatarImageView.clipsToBounds = true;
        let auth = StudentAuthenticationHelper.defaultHelper
        auth.getAvatar{
            error in
            if error == nil{
                self.avatarImageView.image = auth.me.avartar
               // self.avatarImageView.setNeedsDisplay()
            }
        }
        
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 100.0
        }
        return 44.0
    }
//    
//    func choosePhoto()
//    
//    func avatarClicked(){
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//        alert.addAction(UIAlertAction(title: "拍照", style: .Default, handler: ((UIAlertAction) -> Void)?)
//    }
    
}
