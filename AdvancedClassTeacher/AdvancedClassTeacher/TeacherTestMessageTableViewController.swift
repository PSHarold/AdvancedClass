//
//  TeacherTestMessageTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/8.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherTestMessageTableViewController: UITableViewController {

    
    @IBOutlet weak var textField: UITextField!
    weak var test = TeacherTestHelper.defaultHelper.newTest
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textField.text = self.test!.message
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TeacherTestMessageTableViewController.endEditing(_:))))
    }
    
    func endEditing(sender: AnyObject){
        self.textField.resignFirstResponder()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        self.test!.message = self.textField.text!
    }
    

    @IBAction func textField(sender: UITextField) {
        sender.resignFirstResponder()
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    

}
