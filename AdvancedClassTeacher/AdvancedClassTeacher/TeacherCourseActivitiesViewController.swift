//
//  TeacherCourseActivitiesViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/26.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherCourseActivitiesViewController: UIViewController {
    weak var seatHelper = TeacherSeatHelper.defaultHelper
    @IBOutlet weak var chooseSeatButton: UIView!
    @IBOutlet weak var seatPromptLabel: UILabel!

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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chooseSeatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TeacherCourseActivitiesViewController.showSeatMap)))
        self.chooseSeatButton.layer.masksToBounds = true
        self.chooseSeatButton.layer.cornerRadius = 10.0
        self.chooseSeatButton.layer.borderWidth = 0.3
        // Do any additional setup after loading the view.
    }

    func showSeatMap() {
        self.seatHelper!.getSeatToken{
            (error, json) in
            if let error = error{
                self.showError(error)
                switch error{
                case .SEAT_CHOOSING_NOT_AVAILABLE_YET:
                    if self.timer == nil{
                        self.remainingSeconds = json["remaining_secs"].intValue
                        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(TeacherCourseActivitiesViewController.tick), userInfo: nil, repeats: true)
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
                self.seatHelper!.getSeatMap{
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
    func tick(){
        self.remainingSeconds -= 1
        if self.remainingSeconds == 0{
            self.timer.invalidate()
        }
    }
 }
