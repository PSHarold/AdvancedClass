//
//  TeacherPreCurrentStudentListViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/10/7.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherPreCurrentStudentListViewController: UIViewController, TeacherStudentHelperDelegate{
    let studentHelper = TeacherStudentHelper.defaultHelper()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.studentHelper.delegate = self
        
    }
    
    func networkError(){
        
    }
    
    @IBAction func showStudentList(sender: AnyObject) {
        self.studentHelper.updateStudentList()
    }
    func allStudentsAcquired(){
        self.performSegueWithIdentifier("ShowStudentList", sender: self)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
