//
//  StudentAnswerQuestionsViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/8/17.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentAnswerQuestionsViewController: UIViewController, UIScrollViewDelegate, UIPopoverPresentationControllerDelegate{
    weak var testHelper = StudentTestHelper.defaultHelper
    var popoverViewController: StudentTestQuestionListTableViewController!
    var myPopoverPresentationController: UIPopoverPresentationController!
    var timer:NSTimer?
    var timeLimit = -1
    var test = StudentTestHelper.defaultHelper.currentTest
    @IBOutlet weak var scrollView:UIScrollView!
    var _done = 0
    var finished = false
    var currentPage = -1
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    var questionViewControllers: [StudentBaseQuestionTableViewController?]!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.popoverViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentTestQuestionListTableViewController") as! StudentTestQuestionListTableViewController
        self.popoverViewController.answerVC = self
        self.myPopoverPresentationController = UIPopoverPresentationController(presentedViewController: self.popoverViewController, presentingViewController: self)
        self.popoverViewController.preferredContentSize = CGSizeMake(200, CGFloat(self.test.questionNum*44))
        self.popoverViewController.modalPresentationStyle = .Popover
        
        
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(self.view.bounds.width*CGFloat(self.test.questionNum), 0)
        self.questionViewControllers = [StudentBaseQuestionTableViewController?](count: self.test.questionNum, repeatedValue: nil)
        
        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(StudentAnswerQuestionsViewController.tick), userInfo: nil, repeats: true)
       // NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        self.scrollToPage(0)
        self.scrollView.backgroundColor = UIColor.blackColor()
       
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
    }
    
    
    
    func instatiateAndAddSubQuestionPage(page: Int){
        let question = self.test.questions[page]
        var viewController: StudentBaseQuestionTableViewController
        switch question.questionType{
        case .MULTIPLE_CHOICE:
            fallthrough
        case .MULTIPLE_CHOICE_MULTIPLE_ANSWERS:
            viewController = StudentMultipleChoiceTableViewController()
        default:
            viewController = StudentBaseQuestionTableViewController()
        }
        viewController.question = question
        viewController.page = page
        var frame = self.view.bounds
        frame.origin.x = frame.size.width * CGFloat(page)
        viewController.view.frame = frame
        self.addChildViewController(viewController)
        self.scrollView.addSubview(viewController.view)
        self.questionViewControllers[page] = viewController
        
    }
    
    func questionViewControllerForPage(page: Int) -> UIViewController?{
        for viewController in self.questionViewControllers{
            if viewController?.page == page{
                return viewController
            }
        }
        return nil
    }
    
    func instantiateQuestionViewControllerIfNeeded(page: Int){
        if page < 0 || page >= self.test.questionNum{
            return
        }
        if self.questionViewControllerForPage(page) == nil{
            self.instatiateAndAddSubQuestionPage(page)
        }
        
    }
    
    func scrollToPage(page: Int, invokedByScroll: Bool = true){
        if page == self.currentPage{
            return
        }
        self.currentPage = page
        self.instantiateQuestionViewControllerIfNeeded(page)
        self.instantiateQuestionViewControllerIfNeeded(page - 1)
        self.instantiateQuestionViewControllerIfNeeded(page + 1)
        
        for i in 0..<self.questionViewControllers.count{
            if i < page - 1 || i > page + 1{
                if let vc = self.questionViewControllers[i]{
                    vc.view.removeFromSuperview()
                    vc.removeFromParentViewController()
                    self.questionViewControllers[i] = nil
                }
            }
            
        }
        
        if !invokedByScroll{
            self.scrollView.contentOffset = CGPointMake(self.view.bounds.width*CGFloat(page), 0)
        }
        
    }
    
  
    @IBAction func showQuestionList(sender: UIBarButtonItem) {
        if let pop = self.popoverViewController.popoverPresentationController{
            pop.permittedArrowDirections = .Any
            pop.delegate = self
            let view = sender.valueForKey("view") as? UIView
            pop.sourceView = view
            pop.sourceRect = view!.bounds
        }
        
        self.presentViewController(self.popoverViewController, animated: true, completion: nil)
        
    }
    
   
    
    func tick(){
        if timeLimit <= 10{
            self.timeLabel.textColor = UIColor.redColor()
        }
        else if self.timeLimit <= 30{
            self.timeLabel.textColor = UIColor.orangeColor()
        }
        timeLabel.text = "倒计时：" + (self.test.timeLimit).toTimeString()
        self.test.timeLimit -= 1
        if timeLimit < 0{
            self.timer!.invalidate()
            if self.presentedViewController != nil{
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            let alertController = UIAlertController(title: nil, message: "时间到！", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default){
                Void in
            })
            self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
    }
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5)
        self.scrollToPage(page)
    }
    
    
}
