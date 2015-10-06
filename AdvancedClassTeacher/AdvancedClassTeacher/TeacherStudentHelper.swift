
//
//  StudentHelper.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
protocol PreTeacherStudentHelperDelegate{
    func allStudentsAcquired()
}
protocol TeacherStudentHelperDelegate{
    
}
class TeacherStudentHelper {
    static var instance:TeacherStudentHelper?
    var preDelegate:PreTeacherStudentHelperDelegate!
    var alamofireManager : Alamofire.Manager!
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var studentArray = [Student]()
    var studentDict = Dictionary<String,Student>()
    var totalStudentNumber = 0
    var seatHelper = TeacherSeatHelper.defaultHelper()
    var _doneRequiring = true
    var _acquiredStudentNumber = 0
    var absentStudentDict = [String:Student]()
    var presentStudentDict = [String:Student]()
    var courseHelper = TeacherCourseHelper.defaultHelper()
    var doneRequiring:Bool{
        get{
            return self._doneRequiring
        }
        set{
            self._doneRequiring = newValue
            if newValue{
                self.acquiredStudentNumber = 0
            }
        }
    }
    var acquiredStudentNumber:Int{
        get{
            return self._acquiredStudentNumber
        }
        set{
            self._acquiredStudentNumber = newValue
            if newValue == self.totalStudentNumber{
                self.doneRequiring = true
            }
        }
    }
    private init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 3 // seconds
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }

    class func defaultHelper() -> TeacherStudentHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = TeacherStudentHelper()
            return self.instance!
        }
    }
    
    func getAllStudents() -> Int{
        if !doneRequiring{
           return 1
        }
        self.studentDict.removeAll(keepCapacity: false)
        self.studentArray.removeAll(keepCapacity: false)
        self.totalStudentNumber = self.courseHelper.currentCourse.studentIdList.count
        for id in self.courseHelper.currentCourse.studentIdList{
            self.getStudentWithId(id)
        }
        return 0
    }
    
    func updateStudentList(){
        for (_,seat) in self.seatHelper.seatDict{
            if seat.currentStudentId != ""{
                self.presentStudentDict[seat.currentStudentId] = self.studentDict[seat.currentStudentId]!
                self.absentStudentDict.removeValueForKey(seat.currentStudentId)
            }
        }
        for student in self.studentArray{
            if self.presentStudentDict[student.studentId] == nil{
                self.absentStudentDict[student.studentId] = student
                self.presentStudentDict.removeValueForKey(student.studentId)
            }
        }
    }
    
    
    func getStudentWithId(id:String){
        let request = self.authHelper.requestForStudentWithId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):                
                let student = Student(json: JSON(data))
                self.studentArray.append(student)
                self.studentDict[student.studentId] = student
                ++self.acquiredStudentNumber
                
                if self.doneRequiring{
                    self.preDelegate.allStudentsAcquired()
                }

            case .Failure(_, let error):
                _ = error
            }
            
        }
    }
    
}