
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
protocol TeacherStudentHelperDelegate{
    func allStudentsAcquired()
    func networkError()
}
class TeacherStudentHelper {
    static var instance:TeacherStudentHelper?
    var delegate:TeacherStudentHelperDelegate!
    var alamofireManager : Alamofire.Manager!
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var studentArray = [Student]()
    var studentDict = Dictionary<String,Student>()
    var totalStudentNumber = 0
    var seatHelper = TeacherSeatHelper.defaultHelper()
    var _doneRequiring = false
    var _acquiredStudentNumber = 0
    var absentStudentDict = [String:Student]()
    var absentStudentArray = [Student]()
    var presentStudentDict = [String:Student]()
    var presentStudentArray = [Student]()
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
    
    func getAllStudents(){
        self.studentDict.removeAll(keepCapacity: false)
        self.studentArray.removeAll(keepCapacity: false)
        self.totalStudentNumber = self.courseHelper.currentCourse.studentIdList.count
        for id in self.courseHelper.currentCourse.studentIdList{
            self.getStudentWithId(id)
        }
    }
    
    func updateStudentList(){
        self.absentStudentArray.removeAll()
        self.presentStudentArray.removeAll()
        for (_,seat) in self.seatHelper.seatDict{
            if seat.currentStudentId != ""{
                let student = self.studentDict[seat.currentStudentId]!
                self.presentStudentDict[seat.currentStudentId] = student
                self.presentStudentArray.append(student)
                self.absentStudentDict.removeValueForKey(seat.currentStudentId)
            }
        }
        
        for student in self.studentArray{
            if self.presentStudentDict[student.studentId] == nil{
                self.absentStudentDict[student.studentId] = student
                self.absentStudentArray.append(student)
                self.presentStudentDict.removeValueForKey(student.studentId)
            }
        }
        self.delegate.allStudentsAcquired()
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
                    self.delegate.allStudentsAcquired()
                }

            case .Failure(_, let error):
                _ = error
            }
            
        }
    }
    
}