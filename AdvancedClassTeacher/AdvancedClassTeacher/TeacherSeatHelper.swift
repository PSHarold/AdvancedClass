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


class TeacherSeatHelper {
    static var _defaultHelper: TeacherSeatHelper?
    static var defaultHelper: TeacherSeatHelper{
        get{
            if self._defaultHelper == nil{
                self._defaultHelper = TeacherSeatHelper()
            }
            return self._defaultHelper!
        }
    }
    
    
    weak var authHelper = TeacherAuthenticationHelper.defaultHelper
    var tempSeatDataArray = [JSON]()
    var columns = 0
    var rows = 0
    var seatArray: [[Seat!]]!
    var roomId:String!
    var seatDict = Dictionary<String,Seat>()
    var totalSeatNumber = 0
    var seatToken = ""
    var isFinal = false
    var tempSeat: Seat!
    var retryTime = 0
    var seatByStudentId: [String: Seat]!
    var seatToLocate: Seat!
    func getSeatAtIndexPath(indexPath: NSIndexPath) -> Seat{
        return self.seatArray[indexPath.row][indexPath.section]
    }
    
    
    func getSeatToken(completionHandler: ResponseHandler){
        self.authHelper!.getResponsePOSTWithCourse(RequestType.GET_SEAT_TOKEN, parameters: [:]){
            [unowned self]
            (error, json) in
            if error == nil{
                self.seatToken = json["seat_token"].stringValue
                self.roomId = json["room_id"].stringValue
            }
            completionHandler(error: error, json: json)
        }
    }

    
    func getSeatMap(completionHandler: ResponseMessageHandler){
        self.authHelper!.getResponsePOSTWithCourse(RequestType.GET_SEAT_MAP, parameters: ["seat_token": self.seatToken, "check_final": false]){
            [unowned self]
            (error, json) in
            if error == nil{
                self.seatByStudentId = [String: Seat]()
                self.columns = json["col_num"].intValue
                self.rows = json["row_num"].intValue
                self.seatArray = [[Seat!]]()
                for _ in 1...self.rows{
                    self.seatArray.append(Array<Seat!>(count: self.columns, repeatedValue: nil))
                }
                for (_, seat_json) in json["seats"]{
                    let seat = Seat(json: seat_json)
                    if seat.currentStudentId != ""{
                        self.seatByStudentId[seat.currentStudentId] = seat
                    }
                    self.seatArray[seat.row-1][seat.column-1] = seat
                }
            }
            completionHandler(error: error)
        }
    }
    
    static func drop(){
        _defaultHelper = nil
    }
    
    
    func getAvatars()
    
}