//
//  MeTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/10.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class MeTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, RSKImageCropViewControllerDelegate {
    //  weak var faceHelper = FaceHelper.defaultHelper
    @IBOutlet weak var courseLabel: UILabel!
    @IBOutlet weak var studentIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    //@IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var classLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var infoCell: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatarImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.avatarClicked)))
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let me = StudentAuthenticationHelper.defaultHelper.me
        
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
    
    
    func imageCropViewControllerDidCancelCrop(controller: RSKImageCropViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func imageCropViewController(controller: RSKImageCropViewController, didCropImage croppedImage: UIImage, usingCropRect cropRect: CGRect) {
        self.dismissViewControllerAnimated(true){
            self.showHudWithText("正在上传")
            StudentAuthenticationHelper.defaultHelper.uploadAvatar(croppedImage){
                [unowned self]
                error in
                if error == nil{
                   self.showHudWithText("上传成功！", mode: .Text, hideAfter: 1.0)
                   self.avatarImageView.image = StudentAuthenticationHelper.defaultHelper.me.avartar
                }
                else{
                    self.showError(error!)
                }
            }
            
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        var img = info[UIImagePickerControllerOriginalImage] as! UIImage
        img = img.myFixOrientation()
        let cropper = RSKImageCropViewController(image: img, cropMode: .Square)
        cropper.delegate = self
        self.presentViewController(cropper, animated: true, completion: nil)
        
    }
    
    func choosePhoto(from: UIImagePickerControllerSourceType) {
        
        let imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = from
        
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func avatarClicked(){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "从相册选择照片", style: .Default){
            [unowned self]
            _ in
            self.choosePhoto(.PhotoLibrary)
            
            })
        
        alert.addAction(UIAlertAction(title: "使用摄像头拍照", style: .Default){
            [unowned self]
            _ in
            self.choosePhoto(.Camera)
            
            })
        alert.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
