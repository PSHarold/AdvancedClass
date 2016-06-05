//
//  StudentPreChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentCourseActivitiesViewController: UIViewController{
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
        self.chooseSeatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getSeatMap)))
        self.chooseSeatButton.layer.masksToBounds = true
        self.chooseSeatButton.layer.cornerRadius = 10.0
        self.chooseSeatButton.layer.borderWidth = 0.3
        
    }
    
    func showHud(){
        self.showHudWithText("正在加载")
    }
    
    func tick(){
        self.remainingSeconds -= 1
        if self.remainingSeconds == 0{
            self.timer.invalidate()
        }
    }
    
    func getSeatMapMain(){
        self.showHudWithText("正在加载")
        self.remainingSeconds = 0
        StudentSeatHelper.defaultHelper.getSeatMap{
            [unowned self]
            error in
            if let error = error{
                self.showError(error)
            }
            else{
                self.hideHud()
                self.performSegueWithIdentifier("ShowSeatMap", sender: self)
            }
        }
    }
    
    func getSeatMap() {
        self.showHudWithText("正在加载")
        StudentSeatHelper.defaultHelper.getSeatMap{
            error in
            if let error = error{
                if error == CError.SEAT_TOKEN_EXPIRED || error == CError.BAD_SEAT_TOKEN{
                    self.takeQRCode()
                }
                else{
                    self.showError(error)
                }
            }
            else{
                self.getSeatMapMain()
            }
        }
    }
    
    func takeQRCode(){
        self.hideHud()
        let qrReader = SeatTokenQRCodeReaderViewController()
        qrReader.completionHandler = {
            [unowned self]
            error, json in
            if let error = error{
                self.showError(error)
                if let error = error.error{
                    switch error{
                    case .SEAT_CHOOSING_NOT_AVAILABLE_YET:
                        if self.timer == nil{
                            self.remainingSeconds = json["remaining_secs"].intValue
                            self.timer = NSTimer(timeInterval: 1.0, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
                            NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
                        }
                    case .COURSE_ALREADY_OVER:
                        self.seatPromptLabel.text = "课程已结束"
                        self.timer?.invalidate()
                    case CError.COURSE_ALREADY_BEGUN:
                        self.seatPromptLabel.text = "课程已开始"
                        self.timer?.invalidate()
                    default:
                        break
                    }
                }
            }
            else{
                self.getSeatMapMain()
            }
        }
        qrReader.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(qrReader, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
}
