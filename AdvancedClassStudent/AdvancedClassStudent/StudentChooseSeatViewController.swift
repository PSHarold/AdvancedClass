//
//  StudentChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentChooseSeatViewController: UIViewController,SeatViewDataSource,SeatViewDelegate{
    
    var seatHelper = StudentSeatHelper.currentHelper
    var timer:NSTimer!
    var seatButtonDict = Dictionary<String,SeatButton>()
    
    let hud = MBProgressHUD()
    var currentSeat:Seat?
    var anotherSeat:Seat!
    @IBOutlet weak var seatView:SeatView!
    override func viewDidLoad() {
        super.viewDidLoad()
        seatView.delegate = self
        seatView.dataSource = self
        
               //self.timer = NSTimer(timeInterval: 5.0, target: self, selector: "tick", userInfo: nil, repeats: true)
       // NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.timer?.invalidate()
    }
    
    
    func numberOfColumns() -> Int {
        return self.seatHelper.columns
    }
    
    func numberOfRows() -> Int {
        return self.seatHelper.rows
    }
    
    
    
    func didSelectSeatAtIndexPath(indexPath: NSIndexPath) {
        
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
                }
                if seatStatus == .Empty{
                    self.currentSeat = nil
                }
                self.seatView.changeSeatStatusAtIndexPath(indexPath, seatStatus: seatStatus)
                self.hideHud()
            }

        
        case .Empty:
            if self.currentSeat != nil{
                self.showHudWithText("请先释放座位", hideAfter: 0.5)
                self.hideHud()
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
                    self.currentSeat = seat
                }
                
                self.hideHud()
            }
        default:
            return
        }

    }

    func seatStatusAtIndexPath(indexPath:NSIndexPath) -> SeatStatus{
        return self.seatHelper.getSeatAtIndexPath(indexPath).status
    }


}
