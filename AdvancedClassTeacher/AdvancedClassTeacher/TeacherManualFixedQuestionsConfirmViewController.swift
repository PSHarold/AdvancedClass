//
//  TeacherQuestionsHintSettingsTableViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/8.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherManualFixedQuestionsConfirmTableViewController: UITableViewController {
    weak var test: TeacherTest?
    weak var helper = TeacherTestHelper.defaultHelper
    
    @IBAction func tapped(sender: AnyObject) {
        self.performSegueWithIdentifier("Next", sender: self)
    }
    var isRandom = false
    var editButton: UIBarButtonItem!
    func randomSwitched(isRandom: Bool){
        self.isRandom = isRandom
        self.editButton?.title = "编辑"
        self.tableView?.setEditing(false, animated: true)
        
        self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        
    }
    
    override func viewDidLoad() {
        self.test = self.helper!.newTest
        super.viewDidLoad()
    }


    @IBAction func editButtonTapped(sender: UIBarButtonItem) {
        self.editButton = sender
        let temp = !self.tableView.editing
        if temp{
            sender.title = "确定"
        }
        else{
            sender.title = "编辑"
        }
        self.tableView.setEditing(temp, animated: true)
    }
    

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 2
        }
        else{
            return self.test!.questionsFixed.count
        }
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
            if indexPath.row == 0{
                cell.textLabel?.text = "随机顺序"
                if self.isRandom{
                    cell.accessoryType = .Checkmark
                }
                else{
                    cell.accessoryType = .None
                }
            }
            else{
                cell.textLabel?.text = "固定顺序"
                if self.isRandom{
                    cell.accessoryType = .None
                }
                else{
                    cell.accessoryType = .Checkmark
                }
            }
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let question = self.test!.questionsFixed[indexPath.row]
        cell.textLabel?.text = question.content

        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0{
            if indexPath.row == 0{
                self.randomSwitched(true)
            }
            else{
                self.randomSwitched(false)
            }
        }
    }
    
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        else{
            if self.isRandom{
                return false
            }
            return true
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }
        else{
            return true
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        if toIndexPath.section == 0{
            self.tableView.reloadData()
        }
        let question = self.test!.questionsFixed[fromIndexPath.row]
        self.test!.questionsFixed.removeAtIndex(fromIndexPath.row)
        self.test!.questionsFixed.insert(question, atIndex: toIndexPath.row)
        
        
    }
    
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            let question = self.test!.questionsFixed[indexPath.row]
            self.test!.removeQuestion(question)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath, toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        if sourceIndexPath.section != proposedDestinationIndexPath.section {
            var row = 0
            if sourceIndexPath.section < proposedDestinationIndexPath.section {
                row = self.tableView(tableView, numberOfRowsInSection: sourceIndexPath.section) - 1
            }
            return NSIndexPath(forRow: row, inSection: sourceIndexPath.section)
        }
        return proposedDestinationIndexPath
    }
}
