//
//  ModifyPasswordTableViewController.swift
//  Face-Teacher
//
//  Created by Harold on 16/4/21.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class ModifyPasswordTableViewController: UITableViewController {
    
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var newPasswordField: UITextField!
    @IBOutlet weak var oldPasswordField: UITextField!
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2{
            
            if self.confirmPasswordField.text != self.newPasswordField.text{
                let alert: UIAlertController! = UIAlertController(title: nil, message: "新密码与确认密码不一致！", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
                return
            }
            
            TeacherAuthenticationHelper.defaultHelper.modifyPassword(self.oldPasswordField.text!, newPassword: self.newPasswordField.text!){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    let alert: UIAlertController! = UIAlertController(title: nil, message: "修改成功！", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: {_ in self.navigationController?.popViewControllerAnimated(true)}))
                    self.presentViewController(alert, animated: true, completion: nil)                }
            }
        }
    }
    
    @IBAction func endEditing(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
}