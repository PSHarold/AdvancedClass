//
//  EmailTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/22.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class EmailTableViewController: UITableViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let me = TeacherAuthenticationHelper.defaultHelper.me
        self.emailTextField.text = me.email
        self.statusLabel.text = me.emailActivated! ? "已验证" : "未验证"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 2{
            self.showHudIndeterminate("正在提交")
            TeacherAuthenticationHelper.defaultHelper.modifyEmail(self.emailTextField.text!){
                [unowned self]
                error in
                if let error = error{
                    self.showError(error)
                }
                else{
                    self.hideHud()
                    let alert = UIAlertController(title: nil, message: "修改成功！验证邮件已发到新邮箱，请尽快验证，否则将无法使用找回密码功能！", preferredStyle: .Alert)
                    alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: {_ in self.navigationController?.popViewControllerAnimated(true)}))
                    self.presentViewController(alert, animated: true, completion: nil)
                }
            }
            
        }
    }
    
}
