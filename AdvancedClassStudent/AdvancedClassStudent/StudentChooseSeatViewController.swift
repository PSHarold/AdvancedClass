//
//  StudentChooseSeatViewController.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit

class StudentChooseSeatViewController: UIViewController,SeatViewDataSource,SeatViewDelegate,StudentSeatHelperDelegate,SeatDelegate{
    
    var seatHelper = StudentSeatHelper.defaultHelper()
    var courseHelper = StudentCourseHelper.defaultHelper()
    var timer:NSTimer!
    var seatButtonDict = Dictionary<String,SeatButton>()
    var seatButtonArray = [[SeatButton]]()
    let hud = MBProgressHUD()
    var currentSeat:Seat?
    @IBOutlet weak var seatView:SeatView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.seatHelper.delegate = self
        seatHelper.delegate = self
        seatView.delegate = self
        seatView.dataSource = self
        Seat.delegate = self
        
        for _ in 0..<self.seatHelper.rows{
            var temp = [SeatButton]()
            for _ in 0..<self.seatHelper.columns{
                temp.append(SeatButton())
            }
            self.seatButtonArray.append(temp)
        }
        
        for (id,seat) in self.seatHelper.seatDict{
            let tempSeat = self.seatButtonArray[seat.row - 1][seat.column - 1]
            self.seatButtonDict[id] = tempSeat
            tempSeat.checked = seat.checked
            tempSeat.taken = seat.taken
        }
        
        self.timer = NSTimer(timeInterval: 5.0, target: self, selector: "tick", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(self.timer!, forMode: NSRunLoopCommonModes)
    }
    
    
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        self.timer!.invalidate()
    }
    
    func networkError() {
        self.hud.mode = .Text
        self.hud.labelText = "网络错误！"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        self.hud.hide(true, afterDelay: 1.0)

    }
    func tick(){
        seatHelper.updateSeatMapWithRoomId(self.courseHelper.getCurrentRoomId())
    }
    
    func numberOfColumns() -> Int {
        return seatHelper.columns
    }
    
    func numberOfRows() -> Int {
        return seatHelper.rows
    }
    
    
    
    func didSelectSeatAtIndexPath(indexPath: NSIndexPath) {
        let seat = self.seatHelper.seatArray[indexPath.section][indexPath.item]!
        if let curSeat = self.currentSeat{
            if curSeat !== seat{
                return
            }
        }
        if !seat.taken {
            self.hud.mode = .Indeterminate
            if seat.checked{
                self.hud.labelText = "正在释放座位"
                self.view.addSubview(self.hud)
                self.hud.show(true)
                self.seatHelper.deselectSeat(seat)
                //self.hud.removeFromSuperview()
            }
            else{
                
                self.hud.labelText = "正在锁定座位"
                self.view.addSubview(self.hud)
                self.hud.show(true)
                self.seatHelper.selectSeat(seat)
                //self.hud.removeFromSuperview()

            }
        }
    }
    
    func seatAtIndexPath(indexPath:NSIndexPath) -> SeatButton{
        let seatButton = self.seatButtonArray[indexPath.section][indexPath.item]
        if self.seatHelper.seatArray[indexPath.section][indexPath.item] == nil{
            seatButton.exists = false
        }
        return seatButton
    }
    func seatSelectedWithId(seatId: String, checked: Bool) {
        if checked{
            self.currentSeat = self.seatHelper.seatDict[seatId]!
        }
        else{
            self.currentSeat = nil
        }
        self.seatButtonDict[seatId]!.checked = checked
        self.hud.mode = .Text
        self.hud.userInteractionEnabled = false
        self.hud.labelText = checked ? "选座成功！" : "座位已释放！"
        self.view.addSubview(self.hud)
        self.hud.show(true)
        self.hud.hide(true, afterDelay: 0.5)
    }
    
    func seatTakenWithId(seatId: String, taken: Bool) {
        self.seatButtonDict[seatId]!.taken = taken
    }
    
    func seatAlreadyOccupied() {
        self.hud.mode = .Text
        self.hud.detailsLabelText = "座位被别人抢走了！"
        self.hud.labelText = "选座失败"
        self.hud.show(true)
        self.hud.hide(true, afterDelay: 1.2)
    }
}
