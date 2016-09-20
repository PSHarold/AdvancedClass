
//
//  ResetPasswordConfirmTableViewController.swift
//  Face
//
//  Created by Harold on 16/4/22.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class ResetPasswordConfirmTableViewController: UITableViewController {

    
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        emailTextField.placeholder = StudentAuthenticationHelper.defaultHelper.emailToVerify!
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "请补全邮箱地址\(StudentAuthenticationHelper.defaultHelper.emailToVerify!)以验证账户"
        }
        return nil
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        self.showHudWithText("正在验证")
        StudentAuthenticationHelper.defaultHelper.resetPasswordConfirmEmail(self.emailTextField.text!){
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
            }
            else{
                self.hideHud()
                let alert = UIAlertController(title: nil, message: "已向\(self.emailTextField.text!)发送了验证邮件，请点击邮件中的链接重置密码！", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: {_ in self.navigationController?.popToRootViewControllerAnimated(true)}))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
   
}
