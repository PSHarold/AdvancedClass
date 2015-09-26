
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
    var studentList = [Student]()
    var studentDict = Dictionary<String,Student>()
    var totalStudentNumber = 0
    var _doneRequiring = true
    var _currentStudentNumber = 0
    var courseHelper = TeacherCourseHelper.defaultHelper()
    var doneRequiring:Bool{
        get{
            return self._doneRequiring
        }
        set{
            self._doneRequiring = newValue
            if newValue{
                self.currentStudentNumber = 0
            }
        }
    }
    var currentStudentNumber:Int{
        get{
            return self._currentStudentNumber
        }
        set{
            self._currentStudentNumber = newValue
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
        self.studentList.removeAll(keepCapacity: false)
        self.totalStudentNumber = self.courseHelper.currentCourse.studentIdList.count
        for id in self.courseHelper.currentCourse.studentIdList{
            self.getStudentWithId(id)
        }
        return 0
    }
    
    func getStudentWithId(id:String){
        let request = self.authHelper.requestForStudentWithId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):                
                let student = Student(json: JSON(data))
                self.studentList.append(student)
                self.studentDict[student.studentId] = student
                ++self.currentStudentNumber
                
                if self.doneRequiring{
                    self.preDelegate.allStudentsAcquired()
                }

            case .Failure(_, let error):
                _ = error
            }
            
        }
    }
    
}