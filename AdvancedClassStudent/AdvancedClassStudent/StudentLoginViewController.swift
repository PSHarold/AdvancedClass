//
//  LoginViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/8/31.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentLoginViewController: UIViewController {
    

    @IBOutlet weak var pwdTextfield: UITextField!
    @IBOutlet weak var userTextfield: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let hud = MBProgressHUD()
    var authHelper = StudentAuthenticationHelper.defaultHelper
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userTextfield.text = "41316014"
        self.pwdTextfield.text = "123"
         
        loginButton.layer.cornerRadius = 10.0
        let tapBackgroundGesture = UITapGestureRecognizer(target: self, action: "tapBackground")
        self.view.addGestureRecognizer(tapBackgroundGesture)
        // Do any additional setup after loading the view.
    }

    func toLoginIn(){
        self.loginButton.setTitle("登陆", forState: .Normal)
        self.loginButton.enabled = true
        self.pwdTextfield.enabled = true
        self.userTextfield.enabled = true
    }
    
    func logingIn(){
        self.loginButton.setTitle("登陆中...", forState: .Normal)
        self.loginButton.enabled = false
        self.pwdTextfield.enabled = false
        self.userTextfield.enabled = false
    }
    
    @IBAction func Login(sender: AnyObject) {
        self.logingIn()
        self.authHelper.login(userTextfield.text!,password:pwdTextfield.text!){
            (error,json) in
            if let error = error{
                self.showError(error)
                self.toLoginIn()
            }
            else{
                //let hud = self.showHudWithText("正在加载", mode: .Indeterminate)
                self.performSegueWithIdentifier("LoggedIn", sender: self)
            }
        }
        
    }
    
    @IBAction func endEditing(sender: AnyObject) {
        sender.resignFirstResponder()
    }
    

    func tapBackground(){
        self.pwdTextfield.resignFirstResponder()
        self.userTextfield.resignFirstResponder()
    }
    
    func loggedIn() {
        self.view.addSubview(self.hud)
        self.hud.labelText = "加载中"
        self.hud.mode = .Indeterminate
        self.hud.show(true)
    }
    
       
}
