//
//  TeacherCourseActivitiesViewController.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 16/3/26.
//  Copyright © 2016年 Harold. All rights reserved.
//

import UIKit

class TeacherCourseActivitiesViewController: UIViewController{
    weak var seatHelper = TeacherSeatHelper.defaultHelper
    @IBOutlet weak var chooseSeatButton: UIView!
    @IBOutlet weak var checkInWithFaceButton: UIView!
    @IBOutlet weak var seatPromptLabel: UILabel!
    @IBOutlet weak var showStudentsLabel: UILabel!
    
    @IBOutlet weak var showStudentListButton: UIView!
    var timer: NSTimer!
    var remainingSeconds = 0{
        didSet{
            if remainingSeconds == 0{
                self.seatPromptLabel.text = "已开放"
                self.showStudentsLabel.text = "已开放"
                return
            }
            let t = self.remainingSeconds.toTimeString()
            self.showStudentsLabel.text = t
            self.seatPromptLabel.text = t
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.chooseSeatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TeacherCourseActivitiesViewController.showSeatMap)))
        self.showStudentListButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(TeacherCourseActivitiesViewController.showStudentList)))
        self.checkInWithFaceButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.checkInWithFace)))
        self.chooseSeatButton.layer.masksToBounds = true
        self.chooseSeatButton.layer.cornerRadius = 10.0
        self.chooseSeatButton.layer.borderWidth = 0.3
        self.showStudentListButton.layer.masksToBounds = true
        self.showStudentListButton.layer.cornerRadius = 10.0
        self.showStudentListButton.layer.borderWidth = 0.3
        self.checkInWithFaceButton.layer.masksToBounds = true
        self.checkInWithFaceButton.layer.cornerRadius = 10.0
        self.checkInWithFaceButton.layer.borderWidth = 0.3
        
        // Do any additional setup after loading the view.
    }
    
    func checkInWithFace(){
        self.seatHelper!.getSeatToken{
            (error, json) in
            if let error = error{
                self.showError(error)
            }
            else{
               self.performSegueWithIdentifier("ShowFaceStudentList", sender: self)
            }
        }

        
    }
    func showSeatMap(){
        self.getSeatMap(true)
    }
    
    func showStudentList(){        
        self.showHudIndeterminate("正在加载")
        let courseHelper = TeacherCourseHelper.defaultHelper
        courseHelper.getAttendanceListAuto(TeacherCourse.currentCourse){
            [unowned self]
            error, json in
            if let error = error{
                guard let cerror = error.error else{
                    self.showError(error)
                    return
                }
                switch cerror{
                case .SEAT_CHOOSING_NOT_AVAILABLE_YET:
                    if self.timer == nil{
                        self.remainingSeconds = json["remaining_secs"].intValue
                        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(TeacherCourseActivitiesViewController.tick), userInfo: nil, repeats: true)
                        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
                    }
                case .COURSE_ALREADY_OVER:
                    self.showStudentsLabel.text = "课程已结束，无法签到"
                case .COURSE_ALREADY_BEGUN:
                    fallthrough
                case .YOU_ARE_TOO_LATE:
                    self.showStudentsLabel.text = "课程已开始，无法签到"
                default:
                    break
                }
                self.showError(error)
                
            }
            else{
                self.hideHud()
                self.showStudentsLabel.text = "已开放"
                
                self.performSegueWithIdentifier("ShowAttendanceList", sender: self)
            }
            
        }

    }

    func getSeatMap(showMapOrList: Bool) {
        self.seatHelper!.getSeatToken{
            (error, json) in
            if let error = error{
                self.showError(error)
                guard let cerror = error.error else{
                    self.showError(error)
                    return
                }
                switch cerror{
                case .SEAT_CHOOSING_NOT_AVAILABLE_YET:
                    if self.timer == nil{
                        self.remainingSeconds = json["remaining_secs"].intValue
                        self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(TeacherCourseActivitiesViewController.tick), userInfo: nil, repeats: true)
                        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
                    }
                case .COURSE_ALREADY_OVER:
                    self.seatPromptLabel.text = "课程已结束"
                    self.showStudentsLabel.text = "课程已结束"
                case .COURSE_ALREADY_BEGUN:
                    self.seatPromptLabel.text = "课程已开始"
                    self.showStudentsLabel.text = "课程已开始"
                default:
                    break
                }
                
            }
            else{
                self.seatHelper!.getSeatMap{
                    (error) in
                    if let error = error{
                        self.showError(error)
                    }
                    else{
                        self.remainingSeconds = 0
                        self.hideHud()
                        if showMapOrList{
                            self.performSegueWithIdentifier("ShowSeatMap", sender: self)
                        }
                       
                        
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
