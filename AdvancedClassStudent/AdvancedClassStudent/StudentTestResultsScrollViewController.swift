//
//  StudentTestResultsScrollViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/25.
//  Copyright © 2015年 Harold. All rights reserved.
//

import UIKit

class StudentTestResultsScrollViewController: UIViewController,UIScrollViewDelegate {
    
    let test = StudentTestHelper.defaultHelper().testToViewResult
    var scrollView:UIScrollView!
    @IBOutlet weak var notDoneLabel: UILabel!
    var questionViewControllers = [StudentTestResultsTableViewController]()
    var currentPage = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = self.view.viewWithTag(101) as! UIScrollView
        self.scrollView.delegate = self
        self.scrollView.contentSize.width = CGFloat(self.test.questionArray.count) * self.view.frame.width
        var index = 0
        var frame = self.view.frame
        self.notDoneLabel.hidden = true
        frame.origin.y = 0.0
        for question in self.test.questionArray{
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("StudentTestResultsTableViewController") as! StudentTestResultsTableViewController
            vc.initWithQuestion(question,myChoice:self.test.results[question.id]!,total:self.test.questionArray.count,index:++index)
            self.questionViewControllers.append(vc)
            self.addChildViewController(vc)
            vc.tableView.frame = CGRectMake(frame.origin.x, 0.0, self.scrollView.frame.width, self.scrollView.frame.height)
            self.scrollView.addSubview(vc.tableView)
            //vc.tableView.frame = frame
            vc.tableView.layer.borderColor = UIColor.grayColor().CGColor
            vc.tableView.layer.borderWidth = 0.5
            frame.origin.x += frame.width
            self.addChildViewController(vc)
        }
        self.notDoneLabel.hidden = self.test.questionArray[0].isDone
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let pageWidth = self.scrollView.frame.size.width;
        let page = Int(floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1);
        self.notDoneLabel.hidden = self.test.questionArray[page].isDone
    }
    
    
}
