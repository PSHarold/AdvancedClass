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


enum SeatHelperResult{
    case networkErrorAquiring
    case networkErrorUpdating
    case seatMapAquired
    case seatAlreadyOccupied
}
protocol PreStudentSeatHelperDelegate{
    func seatMapAquired()
    func networkError()
}

protocol StudentSeatHelperDelegate {
    func seatAlreadyOccupied()
    func networkError()
    //func seatMapAquired()
}

class StudentSeatHelper {
    
    var authHelper = StudentAuthenticationHelper.defaultHelper()
    var courseHelper = StudentCourseHelper.defaultHelper()
    var tempSeatDataArray = [JSON]()
    var preDelegate:PreStudentSeatHelperDelegate!
    var delegate:StudentSeatHelperDelegate!
    var columns = 0
    var rows = 0
    var seatArray = [[Seat?]]()
    var roomId:String!
    var seatDict = Dictionary<String,Seat>()
    static var instance:StudentSeatHelper!
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
    
    class func defaultHelper() -> StudentSeatHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = StudentSeatHelper()
            return self.instance!
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
    
    // Update the seat map of a room identified with roomId.
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
    
    
    
    // Get all seats of a room identified with roomId.
    private func getAllSeatsUsingColumnAndRowNumberWithRoomId(id:String){
        let request = self.authHelper.requestForSeatsWithRoomId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                for (_,seatData) in JSON(data)["_items"]{
                    let seat = Seat(json: seatData)
                    if seat.currentCourseId == self.courseHelper.currentCourse.courseId && seat.currentCourseSubId == self.courseHelper.currentCourse.subId{
                        if seat.currentStudentId == self.authHelper.myInfo.studentId{
                            seat.taken = false
                            seat.checked = true
                        }
                    }
                    self.seatDict[seat.seatId] = seat
                    self.seatArray[seat.row - 1][seat.column - 1] = seat
                }
                //self.seatDict[self.authHelper.myInfo.currentSeatId]?.taken = false
                //self.seatDict[self.authHelper.myInfo.currentSeatId]?.checked = true
                self.preDelegate.seatMapAquired()
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
                self.preDelegate.networkError()
                
            }
        }
        
    }

    
    
    

    
    
    func deselectSeat(seat:Seat){
        // Configurate custom Alamofire manager.
        let dict = ["cur_stu_id":"","cur_course":["course_id":"","sub_id":""]]
        let request = self.authHelper.requestForSeatSelectionWithSeatId(seat.id, etag: seat.etag, patchDict:dict)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let error = json["_error"]
                let issues = json["_issues"]
                if  error != JSON.null || issues != JSON.null {
                    let errorCode = error["code"]
                    if errorCode != JSON.null {
                        self.parseErrorCode(error["code"].stringValue, seat: seat)
                    }
                    else{
                        print("422..etag does not match...")
                    }
                    
                }
                else{
                    seat.etag = json["_etag"].stringValue
                    seat.checked = false
                }

            case .Failure(_, let error):
                print("Request failed with error: \(error)")
                self.delegate.networkError()
            }
        }

    }
    
    func selectSeat(seat:Seat){
        
        let dict:Dictionary<String,AnyObject> = ["cur_stu_id":self.authHelper.myInfo.studentId,"cur_course":["course_id":self.courseHelper.currentCourse.courseId,"sub_id":self.courseHelper.currentCourse.subId]]
        //let data = try! NSJSONSerialization.dataWithJSONObject(dict, options: NSJSONWritingOptions())
        let request = self.authHelper.requestForSeatSelectionWithSeatId(seat.id, etag: seat.etag, patchDict: dict)
        request.responseJSON(){
            (_,_,result) in
            
            switch result {
            case .Success(let data):
                let json = JSON(data)
                let error = json["_error"]
                let issues = json["_issues"]
                if  error != JSON.null || issues != JSON.null {
                    let errorCode = error["code"]
                    if errorCode != JSON.null {
                        self.parseErrorCode(error["code"].stringValue, seat: seat)
                    }
                    else{
                       
                    }
                    
                }
                else{
                    seat.etag = json["_etag"].stringValue
                    seat.checked = true
                }

            case .Failure(_, let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func parseErrorCode(code:String,seat:Seat){
        switch code{
        case "412":
            seat.taken = true
            self.delegate.seatAlreadyOccupied()
            case "403":
            print("an etag must be provided...", terminator: "")
        case "404":
            print("404", terminator: "")
        default:
            break

            
        }
    }
    
}