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

class Seat{
    var column:Int!
    var row:Int!
    var seatId:String!
    var id:String!
    var roomId:String!
    var etag:String!
    var currentStudentId:String!
    static var delegate:SeatDelegate!
    var currentCourseId:String!
    var currentCourseSubId:String!
    var exists = true
    var _checked = false
    var _taken = false
    
    var checked:Bool{
        get{
            return self._checked
        }
        set{
            self._checked = newValue
            Seat.delegate?.seatSelectedWithId(self.seatId, checked: newValue)
        }
        
    }
    var taken:Bool{
        
        get{
            return self._taken
        }
        set{
            self._taken = newValue
            Seat.delegate?.seatTakenWithId(self.seatId, taken: newValue)
        }
        
    }
    
    init(json:JSON){
        let row = json["row"].intValue
        let column = json["col"].intValue
        //let seat = self.seats[row][column]
        self.row = row
        self.column = column
        self.roomId = json["room_id"].stringValue
        self.etag = json["_etag"].stringValue
        self.seatId = json["seat_id"].stringValue
        self.currentStudentId = json["cur_stu_id"].stringValue
        self.currentCourseId = json["cur_course"]["course_id"].stringValue
        self.currentCourseSubId = json["cur_course"]["sub_id"].stringValue
        //print(self.currentStudentId)
        self.taken = (self.currentStudentId != "")
        self.id = json["_id"].stringValue
        //self.seatDict[seat.seatId] = seat
        switch json["status"].stringValue{
        case "N":
            self.exists = false
        default:
            self.exists = true
        }
        
    }
    
    
    
    
}
