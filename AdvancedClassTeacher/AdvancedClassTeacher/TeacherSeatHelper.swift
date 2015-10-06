//
//  TeacherSeatHelper.swift
//  SeatView
//
//  Created by Harold on 15/8/22.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


enum SeatHelperResult{
    case networkErrorAquiring
    case networkErrorUpdating
    case seatMapAquired
    case seatAlreadyOccupied
}
protocol PreTeacherSeatHelperDelegate{
    func seatMapAquired()
    func networkError()
}

protocol TeacherSeatHelperDelegate {
    func networkError()
}

class TeacherSeatHelper {
    
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var courseHelper = TeacherCourseHelper.defaultHelper()
    var tempSeatDataArray = [JSON]()
    var preDelegate:PreTeacherSeatHelperDelegate!
    var delegate:TeacherSeatHelperDelegate!
    var columns = 0
    var rows = 0
    var seatArray = [[Seat?]]()
    var roomId:String!
    var seatDict = Dictionary<String,Seat>()
    static var instance:TeacherSeatHelper!
    var alamofireManager : Alamofire.Manager!
    var baseUrl = "http://localhost:5000/"
    var totalSeatNumber = 0
    var _currentSeatNumber = 0
    var _doneAcquiring = true
    // Automatically set doneAcquiring when current number equals total number.
    var currentSeatNumber:Int{
        get{
            return self._currentSeatNumber
        }
        set{
            self._currentSeatNumber = newValue
            if newValue == self.totalSeatNumber{
                self.doneAcquiring = true
            }
        }
    }
    
    var numberOfTakenSeats = 0
    
    
    
    var doneAcquiring:Bool{
        get{
            return self._doneAcquiring
        }
        set{
            self._doneAcquiring = newValue
            if newValue{
                self.currentSeatNumber = 0
            }
        }
    }
    
    // Configurate connection.
    private init(){
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 3 // seconds
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    class func defaultHelper() -> TeacherSeatHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = TeacherSeatHelper()
            return self.instance!
        }
    }
    
    
    
    func updateSeatMapWithRoomId(id:String){
        let request = self.authHelper.requestForSeatsWithRoomId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                for (_,seatData) in json["_items"]{
                    // Skip if current seat doesn't exist.
                    if seatData["status"].stringValue == "N"{
                        continue
                    }
                    
                    let seatId = seatData["seat_id"].stringValue
                    
                    let seat = self.seatDict[seatId]!
                    if seat.checked{
                        continue
                    }
                    seat.currentStudentId = seatData["cur_stu_id"].stringValue
                    seat.taken = (seat.currentStudentId != "")
                    seat.etag = seatData["_etag"].stringValue
                    
                }
                
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
                self.delegate.networkError()
            }
        }
    }
    
    
   
    func getAllSeatsWithRoomId(id:String){
        self.roomId = id
        let request = self.authHelper.requestForRoomWithId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                // Initialize the two dimension array of seats using acquired data.
                let json = JSON(data)
                self.rows = json["rows"].intValue
                self.columns = json["cols"].intValue
                self.roomId = json["room_id"].string
                for _ in 0...self.rows{
                    var temp = [Seat?]()
                    for _ in 0...self.columns{
                        temp.append(nil)
                    }
                    self.seatArray.append(temp)
                }
                // Begin to get all seats in the room.
                self.getAllSeatsUsingColumnAndRowNumberWithRoomId(id)
            case .Failure(_, let error):
                print(error)
                self.preDelegate.networkError()
            }
        }
        
    }
    
    // Get all seats of a room identified with roomId.
    private func getAllSeatsUsingColumnAndRowNumberWithRoomId(id:String){
        let request = self.authHelper.requestForSeatsWithRoomId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                for (_,seatData) in JSON(data)["_items"]{
                    let seat = Seat(json: seatData)
                    self.seatDict[seat.seatId] = seat
                    // if seat
                    self.seatArray[seat.row - 1][seat.column - 1] = seat
                }
                self.preDelegate.seatMapAquired()
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
                self.preDelegate.networkError()
            }
        }
    }    
    
    
    func selectSeat(seat:Seat){
        
    }
    
    func updateStudentList(){
        
    }
    
    
    
    func parseErrorCode(code:String,seat:Seat){
        switch code{
        case "404":
            print("404", terminator: "")
        default:
            break

            
        }
    }
    
}