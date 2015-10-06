//
//  StudentAnswerQuestionsViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/8/17.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentAnswerQuestionsViewController: UIViewController,StudentTestHelperDelegate{
    let testHelper = StudentTestHelper.defaultHelper()
    var timer:NSTimer?
    var timeLimit = -1
    var test:StudentTest!
    var scrollView:UIScrollView!
    var _done = 0
    var finished = false
    var uploaded = false
    var doneNumber:Int{
        get{
            return self._done
        }
        set{
            if self.finished{
                return
            }
            self._done = newValue
            if newValue == self.test.questionArray.count{
                self.answeringFinished()
                self.finished = true
            }
        }
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var submitButton: UIButton!
    
    var questionViewControllers = [StudentQuestionTableViewController]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.scrollView = self.view.viewWithTag(101) as! UIScrollView
        self.test = self.testHelper.testToView
        self.submitButton.hidden = true
        self.timeLimit = test.timeLimitInt
        self.timeLabel.text = "开始倒计时"
        self.scrollView.contentSize.width = CGFloat(self.test.questionArray.count) * self.view.frame.width
        var index = 0
        var frame = self.view.frame
        
        frame.origin.y = 0.0
        for question in self.test.questionArray{
            let vc = self.storyboard!.instantiateViewControllerWithIdentifier("StudentQuestionTableViewController") as! StudentQuestionTableViewController
            vc.initWithQuestion(question,hasHint:test.hasHint,total:self.test.questionArray.count,index:++index)
            self.questionViewControllers.append(vc)
            vc.tableView.frame = CGRectMake(frame.origin.x, 0.0, self.scrollView.frame.width, self.scrollView.frame.height)
            self.scrollView.addSubview(vc.tableView)
            //vc.tableView.frame = frame
            vc.tableView.layer.borderColor = UIColor.grayColor().CGColor
            vc.tableView.layer.borderWidth = 0.5
            frame.origin.x += frame.width
            self.addChildViewController(vc)
        }

        if test.timeLimitInt <= 0{
            self.timeLabel.hidden = true
            return
        }
        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.timer?.invalidate()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.testHelper.delegate = self
    }
    
    func toHourMinuteSecond(seconds:Int) ->String{
        if seconds>86400 || seconds<0{
            return "Inf"
        }
        let hours:Int = seconds/3600
        let minutes:Int = (seconds-hours*3600)/60
        let seconds:Int = (seconds-hours*3600) % 60
        let s1 = hours == 0 ? "" : "\(hours)小时"
        var s2 = "\(minutes)分钟"
        let s3 = "\(seconds)秒"
        if hours == 0 && minutes == 0{
            s2 = ""
        }
        return s1 + s2 + s3
    }
    
    func resultsUploaded() {
        let alertController = UIAlertController(title: nil, message: "提交成功！", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler:  {Void in self.navigationController!.popViewControllerAnimated(true)}))
        self.presentViewController(alertController, animated: true, completion:nil)
    }
    

    func networkError() {
        let alertController = UIAlertController(title: nil, message: "提交失败！网络错误！", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        for vc in self.questionViewControllers{
            vc.allowAnswering = false
        }
        self.submitButton.hidden = false
    }

    func answeringFinished(){
        self.submitButton.hidden = false
    }
    
    func submit(){
        self.testHelper.uploadResults(self.test)
    }
    
    
    @IBAction func cancel(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "若放弃则本次答题记录将被清除！确定要放弃作答吗？", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "继续答题", style: UIAlertActionStyle.Default, handler: nil))
        alertController.addAction(UIAlertAction(title: "放弃答题", style: UIAlertActionStyle.Destructive,handler:{
            Void in
            self.test.undoAll()
            self.navigationController!.popViewControllerAnimated(true)
        }))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    @IBAction func submitClicked(sender: AnyObject) {
        self.submit()
    }
    func tick(){
        if timeLimit <= 10{
            self.timeLabel.textColor = UIColor.redColor()
        }
        else if self.timeLimit <= 30{
            self.timeLabel.textColor = UIColor.orangeColor()
        }

        timeLabel.text = "倒计时：\(self.toHourMinuteSecond(timeLimit--))"
        if timeLimit < 0{
        self.timer!.invalidate()
        if self.presentedViewController != nil{
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let alertController = UIAlertController(title: nil, message: "时间到！", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "确定", style: UIAlertActionStyle.Default, handler: {
                Void in
            self.submit()
            }))
        self.presentViewController(alertController, animated: true, completion: nil)
            
            
        }
    }
    
}
