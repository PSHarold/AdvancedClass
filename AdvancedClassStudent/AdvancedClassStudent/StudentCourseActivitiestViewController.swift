//
//  StudentPreChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentCourseActivitiestViewController: UIViewController{
    var seatHelper = StudentSeatHelper.currentHelper
    @IBOutlet weak var chooseSeatButton: UIView!
    var timer: NSTimer!
    var remainingSeconds = 0{
        didSet{
            if remainingSeconds == 0{
                self.seatPromptLabel.text = "已开放"
                return
            }
           
            self.seatPromptLabel.text = self.remainingSeconds.toTimeString()
        }
    }
    
   
    
    @IBOutlet weak var seatPromptLabel: UILabel!
    
    let hud = MBProgressHUD()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chooseSeatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(StudentCourseActivitiestViewController.chooseSeat)))
        self.chooseSeatButton.layer.masksToBounds = true
        self.chooseSeatButton.layer.cornerRadius = 10.0
        self.chooseSeatButton.layer.borderWidth = 0.3
        
    }
    
    func showHud(){
        self.showHudWithText("正在加载", mode: .Indeterminate)
    }
    
    func tick(){
        self.remainingSeconds -= 1
        if self.remainingSeconds == 0{
            self.timer.invalidate()
        }
    }
    
    func chooseSeat() {
        self.showHud()
        self.seatHelper.getSeatToken{
            (error, json) in
            if let error = error{
                self.showError(error)
                switch error{
                case .SEAT_CHOOSING_NOT_AVAILABLE_YET:
                    if self.timer == nil{
                        self.remainingSeconds = json["remaining_secs"].intValue
                        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(StudentCourseActivitiestViewController.tick), userInfo: nil, repeats: true)
                        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
                    }
                case .COURSE_ALREADY_OVER:
                    self.seatPromptLabel.text = "课程已结束"
                case CError.COURSE_ALREADY_BEGUN:
                    self.seatPromptLabel.text = "课程已开始"
                default:
                    break
                }
               
            }
            else{
                self.seatHelper.getSeatMap{
                     (error, json) in
                    if let error = error{
                        self.showError(error)
                        
                        
                    }
                    else{
                        self.remainingSeconds = 0
                        self.hideHud()
                        self.performSegueWithIdentifier("ShowSeatMap", sender: self)
                    }
                }
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
   
}
