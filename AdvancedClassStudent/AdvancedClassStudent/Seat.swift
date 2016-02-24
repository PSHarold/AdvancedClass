//
//  MySeatButton.swift
//  SeatsScrollView
//
//  Created by Harold on 15/8/20.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import UIKit
import SwiftyJSON
protocol SeatDelegate{
    func seatTakenWithId(seatId:String,taken:Bool)
    //func seatDidBecomeAvailableWithId(seatId:String)
    func seatSelectedWithId(seatId:String,checked:Bool)
}

enum SeatStatus: Int{
    case Empty = 5
    case Checked = 6
    case Taken = 7
    case Broken = 1
    case NONEXISTENT = 2
}

class Seat{
    var me = StudentAuthenticationHelper.me
    var column: Int
    var row: Int
    var seatId: String
    var currentStudentId: String
    var status: SeatStatus = .Empty
    init(json:JSON){
        self.row = json["row"].intValue
        self.column = json["col"].intValue
        self.seatId = json["seat_id"].stringValue
        self.currentStudentId = json["cur_stu"].stringValue
        let statusInt = json["status"].intValue
        if statusInt == 0{
            if self.currentStudentId != ""{
                if self.currentStudentId == me.studentId{
                    self.status = .Checked
                }
                else{
                    self.status = .Taken
                }
            }
            else{
               self.status = .Empty
            }
        }
        else{
            self.status = SeatStatus(rawValue: statusInt)!
        }
    }
}
