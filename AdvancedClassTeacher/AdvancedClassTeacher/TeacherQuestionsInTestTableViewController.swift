//
//  TeacherQuestionsInTestTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherQuestionsInTestTableViewController: UITableViewController {

    var test:TeacherTest!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 0
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell", forIndexPath: indexPath) 
        cell.textLabel!.text = self.test.questionArray[indexPath.row].question
        

        return cell
    }
    

  
}
