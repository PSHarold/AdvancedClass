//
//  StudentChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class TeacherSeatViewController: UIViewController, SeatViewDataSource, SeatViewDelegate, UIPopoverPresentationControllerDelegate{
    
    var seatHelper = TeacherSeatHelper.defaultHelper
    var timer:NSTimer!
    var seatButtonDict = Dictionary<String,SeatButton>()
    var popoverViewController: StudentInfoPopoverTableViewController!
    var myPopoverPresentationController: UIPopoverPresentationController!
    let hud = MBProgressHUD()
    var currentSeatIndex: NSIndexPath?
    weak var courseHelper = TeacherCourseHelper.defaultHelper
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
        case .Taken:
            let studentId = seat.currentStudentId
            let course = TeacherCourse.currentCourse
            self.showHudWithText("正在获取", mode: .Indeterminate)
            self.courseHelper!.getStudent(studentId, course: course){
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
