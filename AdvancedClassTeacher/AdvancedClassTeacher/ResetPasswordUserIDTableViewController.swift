//
//  ResetPasswordUserIDTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/22.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class ResetPasswordUserIDTableViewController: UITableViewController {
    
    @IBOutlet weak var userIdTextField: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1{
            self.showHudIndeterminate("正在提交")
            TeacherAuthenticationHelper.defaultHelper.requestToResetPassword(self.userIdTextField.text!){
                [unowned self]
                error in
                if let error = error{
                    switch error.error!{
                    case .EMAIL_NOT_ACTIVATED:
                        let alert = UIAlertController(title: nil, message: "您的邮箱未激活或者未填写邮箱，无法找回密码，请与管理员联系！", preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    default:
                        self.showError(error)
                    }
                    
                }
                else{
                    self.hideHud()
                    self.performSegueWithIdentifier("ConfirmEmail", sender: self)
                }
                
            }
        }
    }
    
    
    
}
