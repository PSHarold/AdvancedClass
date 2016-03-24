//
//  TeacherBrowseTableViewController.swift
//  MyClassStudent
//
//  Created by Harold on 15/8/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class KnowledgePointViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    weak var currentCourse = TeacherCourse.currentCourse
    weak var syllabus: Syllabus?
    var pointsTableView: UITableView!{
        get{
            return nil
        }
    }
    
    
    var expanded = [[Bool]]()
    var sectionHeaderRowNum = [[Int]]()
    var pointsWithRowNum = [[Int: KnowledgePoint]]()
    var lastSection = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pointsTableView.tableFooterView = UIView()
        self.pointsTableView.dataSource = self
        self.pointsTableView.delegate = self
        self.syllabus = self.currentCourse!.syllabus
        self.lastSection = self.syllabus!.chapters.count
        
        self.pointsTableView.registerClass(KnowledgePointSectionTableViewCell.self, forCellReuseIdentifier: "SectionCell")
        self.pointsTableView.registerClass(KnowledgePointTableViewCell.self, forCellReuseIdentifier: "PointCell")
        let sectionNib = UINib(nibName: "KnowledgePointSectionTableViewCell", bundle: nil)
        self.pointsTableView.registerNib(sectionNib, forCellReuseIdentifier: "SectionCell")
        let pointNib = UINib(nibName: "KnowledgePointTableViewCell", bundle: nil)
        self.pointsTableView.registerNib(pointNib, forCellReuseIdentifier: "PointCell")
        for i in 0..<self.syllabus!.chapters.count{
            let chapter = self.syllabus!.chapters[i]
            var expanded = [Bool]()
            var sectionHeaderRowNum = [Int]()
            for i in 0..<chapter.sections.count{
                expanded.append(false)
                sectionHeaderRowNum.append(i)
                
            }
            self.expanded.append(expanded)
            self.sectionHeaderRowNum.append(sectionHeaderRowNum)
            self.pointsWithRowNum.append([Int: KnowledgePoint]())
        }
    }
    

    
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == self.lastSection{
            return nil
        }
        let chapter = self.syllabus!.chapters[section]
        return "第\(chapter.chapterNum)章 \(chapter.chapterName)"
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let rowNum = indexPath.row
        let sectionNum = indexPath.section
        if sectionNum == self.lastSection{
            let cell = UITableViewCell()
            cell.separatorInset = UIEdgeInsetsZero
            cell.layoutMargins = UIEdgeInsetsZero
            return cell
        }
        var lastSection = true
        for i in 0..<self.sectionHeaderRowNum[sectionNum].count{
            
            let sectionHeaderRowNum = self.sectionHeaderRowNum[sectionNum][i]
            if rowNum > sectionHeaderRowNum{
                continue
            }
            
            lastSection = false
            if rowNum == sectionHeaderRowNum{
                let cell = self.pointsTableView.dequeueReusableCellWithIdentifier("SectionCell", forIndexPath: indexPath) as! KnowledgePointSectionTableViewCell
                cell.label.text = "\(i+1). " + self.syllabus!.chapters[sectionNum].sections[i].sectionName
                cell.expanded = self.expanded[sectionNum][i]
                cell.sectionNum = i
                return cell
                
            }
            else{
                let offset = rowNum - self.sectionHeaderRowNum[sectionNum][i-1]
                let cell = self.pointsTableView.dequeueReusableCellWithIdentifier("PointCell", forIndexPath: indexPath) as! KnowledgePointTableViewCell
                let point = self.syllabus!.chapters[sectionNum].sections[i-1].knowledgePoints[offset-1]
                self.pointsWithRowNum[sectionNum][rowNum] = point
                cell.knowledgePointContent = "\(offset). " + point.content
                //cell.indentationLevel = 5
                cell.knowledgePointLevel = point.level
                return cell
            }
            
            
        }
        if lastSection{
            let offset = rowNum - self.sectionHeaderRowNum[sectionNum].last!
            let cell = self.pointsTableView.dequeueReusableCellWithIdentifier("PointCell", forIndexPath: indexPath) as! KnowledgePointTableViewCell
            let point = self.syllabus!.chapters[sectionNum].sections.last!.knowledgePoints[offset-1]
            self.pointsWithRowNum[sectionNum][rowNum] = point
            cell.knowledgePointContent = "\(offset). " + point.content
            cell.knowledgePointLevel = point.level
            return cell
        }
        
    
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let count = self.syllabus!.chapters.count
        return count+1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == self.lastSection{
            return 1
        }
        var total = self.syllabus!.chapters[section].sections.count
        for i in 0..<self.expanded[section].count{
            if self.expanded[section][i]{
                total+=self.syllabus!.chapters[section].sections[i].knowledgePoints.count
            }
        }

        return total
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.pointsTableView.deselectRowAtIndexPath(indexPath, animated: false)
        let cell = self.pointsTableView.cellForRowAtIndexPath(indexPath) as? KnowledgePointSectionTableViewCell
        if cell == nil{
            return
        }
        
        let sectionNum = cell!.sectionNum
        let count = self.syllabus!.chapters[indexPath.section].sections[sectionNum].knowledgePoints.count
        
        let expandedNow = !self.expanded[indexPath.section][sectionNum]
        
        
        for i in sectionNum + 1 ..< self.sectionHeaderRowNum[indexPath.section].count{
            self.sectionHeaderRowNum[indexPath.section][i] = expandedNow ? self.sectionHeaderRowNum[indexPath.section][i] + count : self.sectionHeaderRowNum[indexPath.section][i] - count
        }
        
        self.expanded[indexPath.section][sectionNum] = expandedNow
        cell!.expanded = expandedNow
        let sectionCount = self.syllabus!.chapters[indexPath.section].sections[sectionNum].knowledgePoints.count
        let headerRowNum = self.sectionHeaderRowNum[indexPath.section][cell!.sectionNum]
        var indexPaths = [NSIndexPath]()
        var i = headerRowNum
        for _ in 0..<sectionCount{
            i += 1
            indexPaths.append(NSIndexPath(forItem: i, inSection: indexPath.section))
        }
        if expandedNow{
            self.pointsTableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }
        else{
            self.pointsTableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        }
        
        
    }
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.Delete
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String? {
        return "删除"
    }
    
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
       
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    
  
    

}
