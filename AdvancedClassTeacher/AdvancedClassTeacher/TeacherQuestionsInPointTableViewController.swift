//
//  TeacherQuestionsInPointTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/5.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherQuestionsInPointTableViewController: UITableViewController {

    
    var knowledgePoint: KnowledgePoint!
    var selectedQuestion: TeacherQuestion!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
 

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.knowledgePoint.questions.count
    }

 
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        cell.textLabel?.text = self.knowledgePoint.questions[indexPath.row].content
        return cell
    }
 

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedQuestion = self.knowledgePoint.questions[indexPath.row]
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
 

    
}
