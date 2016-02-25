//
//  StudentSeatHelper.swift
//  SeatView
//
//  Created by Harold on 15/8/22.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


typealias SeatResponseHandler = (error: CError?, seatStatus: SeatStatus!) -> Void
class StudentSeatHelper {
    
    static var currentHelper = StudentSeatHelper()
    
    
    weak var authHelper = StudentAuthenticationHelper.defaultHelper
    var tempSeatDataArray = [JSON]()
    var columns = 0
    var rows = 0
    var seatArray: [[Seat!]]!
    var roomId:String!
    var seatDict = Dictionary<String,Seat>()
    var totalSeatNumber = 0
    var seatToken = ""
    var seatMapToken = ""
    var isFinal = false
    var tempSeat: Seat!
    var retryTime = 0
    
    func getSeatAtIndexPath(indexPath: NSIndexPath) -> Seat{
        return self.seatArray[indexPath.row][indexPath.section]
    }
    
    
    func getSeatToken(completionHandler: ResponseHandler){
        self.authHelper!.getResponse(RequestType.GET_SEAT_TOKEN, postBody: ["course_id": StudentCourse.currentCourse.courseId, "sub_id": StudentCourse.currentCourse.subId]){
            [unowned self]
            (error, json) in
            if error == nil{
                self.seatToken = json["seat_token"].stringValue
                self.seatMapToken = json["seat_map_token"].stringValue
                self.roomId = json["room_id"].stringValue
            }
            completionHandler(error: error, json: json)
        }
    }
    
    func getSeatMap(completionHandler: ResponseHandler){
        self.authHelper!.getResponse(RequestType.GET_SEAT_MAP, postBody: ["seat_map_token": self.seatMapToken, "check_final": false]){
            [unowned self]
            (error, json) in
            if error == nil{
                self.columns = json["col_num"].intValue
                self.rows = json["row_num"].intValue
                self.seatArray = [[Seat!]]()
                for _ in 1...self.rows{
                    self.seatArray.append(Array<Seat!>(count: self.columns, repeatedValue: nil))
                }
                for (_, seat_json) in json["seats"]{
                    let seat = Seat(json: seat_json)
                    if seat.currentStudentId == StudentAuthenticationHelper.me.studentId{
                        seat.status = .Checked
                    }
                    self.seatArray[seat.row-1][seat.column-1] = seat
                }
            }
            completionHandler(error: error, json: json)
        }
    }
    
    func chooseSeat(indexPath: NSIndexPath, completionHandler: SeatResponseHandler){
        let seat = self.seatArray[indexPath.row][indexPath.section]
        self.authHelper!.getResponse(RequestType.CHOOSE_SEAT, postBody: ["seat_id":seat.seatId, "seat_token":self.seatToken]){
            [unowned self]
            (error, json) in
            if let error = error{
                if error == CError.SEAT_TOKEN_EXPIRED{
                    self.getSeatToken{
                        (error, json) in
                        self.chooseSeat(indexPath, completionHandler: completionHandler)
                        return
                    }
                }
                else if error == CError.SEAT_ALREADY_TAKEN{
                    seat.status = .Taken
                    seat.currentStudentId = json["cur_stu"].stringValue
                }
                completionHandler(error: error as CError?, seatStatus: seat.status)
            }
            else{
                seat.currentStudentId = StudentAuthenticationHelper.me.studentId
                seat.status = .Checked
                completionHandler(error: error, seatStatus: .Checked)
            }
        }
    }
    
    func freeSeat(indexPath: NSIndexPath, completionHandler: SeatResponseHandler){
        let seat = self.seatArray[indexPath.row][indexPath.section]
        self.authHelper!.getResponse(RequestType.FREE_SEAT, postBody: ["seat_id":seat.seatId, "seat_token":self.seatToken]){
            [unowned self]
            (error, json) in
            if let error = error{
                if error == CError.SEAT_TOKEN_EXPIRED{
                    self.getSeatToken{
                        (error, json) in
                        self.freeSeat(indexPath, completionHandler: completionHandler)
                    }
                }
                else{
                    completionHandler(error: error as CError?, seatStatus: seat.status)
                }
            }
            else{
                seat.currentStudentId = ""
                seat.status = .Empty
                completionHandler(error: error, seatStatus: .Empty)
            }
        }
    }
    
}