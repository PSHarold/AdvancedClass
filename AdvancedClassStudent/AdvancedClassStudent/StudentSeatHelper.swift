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


typealias SeatResponseHandler = (error: MyError?, seatStatus: SeatStatus!) -> Void

class StudentSeatHelper {
    
    static var _defaultHelper: StudentSeatHelper?
    static var defaultHelper: StudentSeatHelper{
        get{
            if _defaultHelper == nil{
                _defaultHelper = StudentSeatHelper()
            }
            return _defaultHelper!
        }
    }
    
    
    weak var authHelper = StudentAuthenticationHelper.defaultHelper
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
    
    
    func getSeatToken(QRCode: String, completionHandler: ResponseHandler){
        self.authHelper!.getResponsePOSTWithCourse(RequestType.GET_SEAT_TOKEN, parameters: ["qr_code": QRCode]){
            [unowned self]
            (error, json) in
            if error == nil{
                self.seatToken = json["seat_token"].stringValue
                self.roomId = json["room_id"].stringValue
            }
            else if let error = error?.error{
                switch error{
                case .BAD_SEAT_TOKEN:
                    self.seatToken = ""
                default:
                    break
                }
            }
            completionHandler(error: error, json: json)
        }
    }
    
    func getSeatMap(completionHandler: ResponseMessageHandler){
        guard self.seatToken != "" else{
            completionHandler(error: MyError(cError: CError.SEAT_TOKEN_EXPIRED))
            return
        }
        self.authHelper!.getResponsePOST(RequestType.GET_SEAT_MAP, parameters: ["seat_token": self.seatToken, "check_final": false]){
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
                        if seat.currentStudentId == StudentAuthenticationHelper.me.studentId{
                            seat.status = .Checked
                        }
                        else{
                            self.seatByStudentId[seat.currentStudentId] = seat
                        }
                    }
                    self.seatArray[seat.row-1][seat.column-1] = seat
                }
            }
            completionHandler(error: error)
        }
    }
    
    func chooseSeat(indexPath: NSIndexPath, completionHandler: SeatResponseHandler){
        let seat = self.seatArray[indexPath.row][indexPath.section]
        self.authHelper!.getResponsePOST(RequestType.CHOOSE_SEAT, parameters: ["seat_id":seat.seatId, "seat_token":self.seatToken]){
            (error, json) in
            if let error = error{
                if error == CError.SEAT_ALREADY_TAKEN{
                    seat.status = .Taken
                    seat.currentStudentId = json["cur_stu"].stringValue
                }
                completionHandler(error: error, seatStatus: seat.status)
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
        self.authHelper!.getResponsePOST(RequestType.FREE_SEAT, parameters: ["seat_id":seat.seatId, "seat_token":self.seatToken]){
            (error, json) in
            if let error = error{
                completionHandler(error: error, seatStatus: seat.status)
            }
            else{
                seat.currentStudentId = ""
                seat.status = .Empty
                completionHandler(error: error, seatStatus: .Empty)
            }
        }
    }
       
    
    static func drop(){
        _defaultHelper = nil
    }
    
}