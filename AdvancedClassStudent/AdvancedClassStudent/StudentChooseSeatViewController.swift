//
//  StudentChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentChooseSeatViewController: UIViewController, SeatViewDataSource, SeatViewDelegate, UIPopoverPresentationControllerDelegate{
    
    var seatHelper = StudentSeatHelper.currentHelper
    var timer:NSTimer!
    var seatButtonDict = Dictionary<String,SeatButton>()
    var popoverViewController: StudentInfoPopoverTableViewController!
    var myPopoverPresentationController: UIPopoverPresentationController!
    let hud = MBProgressHUD()
    var currentSeatIndex: NSIndexPath?
    
    @IBOutlet weak var seatView:SeatView!
    var lock = false
    
    
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        seatView.delegate = self
        seatView.dataSource = self
        self.popoverViewController = self.storyboard?.instantiateViewControllerWithIdentifier("StudentInfo") as! StudentInfoPopoverTableViewController
        
        self.myPopoverPresentationController = UIPopoverPresentationController(presentedViewController: self.popoverViewController, presentingViewController: self)
        self.popoverViewController.preferredContentSize = CGSizeMake(150, 100)
        
                        //self.timer = NSTimer(timeInterval: 5.0, target: self, selector: "tick", userInfo: nil, repeats: true)
       // NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
        self.popoverViewController.modalPresentationStyle = .Popover
    }
    
    
    
    override func viewWillDisappear(animated: Bool) {
        print(self.seatView.frame)
        super.viewDidDisappear(true)
        self.timer?.invalidate()
    }
    
    
    
    
    func numberOfColumns() -> Int {
        return self.seatHelper.columns
    }
    
    func numberOfRows() -> Int {
        return self.seatHelper.rows
    }
    
    
    
    func didSelectSeatAtIndexPath(indexPath: NSIndexPath, seatButton: SeatButton) {
        
        let seat = self.seatHelper.seatArray[indexPath.row][indexPath.section]!
        switch seat.status{
        case .Checked:
            self.showHudWithText("正在释放座位", mode: .Indeterminate)
            self.seatHelper.freeSeat(indexPath){
                (error, seatStatus) in
                
                if let error = error{
                    self.showError(error)
                    if error == CError.NETWORK_ERROR{
                        self.hideHud()
                        return
                    }
                    return
                }
                if seatStatus == .Empty{
                    self.currentSeatIndex = nil
                }
                self.seatView.changeSeatStatusAtIndexPath(indexPath, seatStatus: seatStatus)
                self.hideHud()
            }

        
        case .Empty:
            
            if self.currentSeatIndex != nil{
                self.showHudWithText("请先释放座位", hideAfter: 0.5)
                return
            }
            self.showHudWithText("正在锁定座位", mode: .Indeterminate)
            self.seatHelper.chooseSeat(indexPath){
                (error, seatStatus) in
                defer { self.seatView.changeSeatStatusAtIndexPath(indexPath, seatStatus: seatStatus) }
                if let error = error{
                    self.showError(error)
                    return
                }
                if seatStatus == .Checked{
                    self.currentSeatIndex = indexPath
                }
                self.hideHud()
            }
        case .Taken:
            let studentId = seat.currentStudentId
            let course = StudentCourse.currentCourse
            self.showHudWithText("正在获取", mode: .Indeterminate)
            course.getStudent(studentId){
                [unowned self]
                (error) in
                if let error = error{
                    self.showError(error)
                    return
                }
                else{
                    if let pop = self.popoverViewController.popoverPresentationController{
                        pop.permittedArrowDirections = .Any
                        pop.delegate = self
                        pop.sourceView = seatButton
                        pop.sourceRect = seatButton.bounds
                    }
                    self.hideHud()
                    self.popoverViewController.student = course.students[studentId]
                    self.presentViewController(self.popoverViewController, animated: true, completion: nil)
                }
            }
        
            
            
        default:
            return
        }

    }

    func seatStatusAtIndexPath(indexPath:NSIndexPath) -> SeatStatus{
        let status = self.seatHelper.getSeatAtIndexPath(indexPath).status
        if status == .Checked{
            self.currentSeatIndex = indexPath
        }
        return status
    }


}
