//
//  StudentInfoHelper.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
@objc protocol StudentHelperDelegate{
    optional func allStudentRequired()
}

class StudentHelper {
    static var instance:StudentHelper?
    var delegate:StudentHelperDelegate!
    var alamofireManager : Alamofire.Manager!
    var authHelper = StudentAuthenticationHelper.defaultHelper()
    var studentList = [Student]()
    var studentDict = Dictionary<String,Student>()
    var totalStudentNumber = 0
    var _doneRequiring = true
    var _currentStudentNumber = 0
    var courseHelper = StudentCourseHelper.defaultHelper()
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
    
    class func defaultHelper() -> StudentHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = StudentHelper()
            return self.instance!
        }
    }
    
    func getAllStudents() -> Int{
        if !doneRequiring{
            return 1
        }
        self.studentDict.removeAll(keepCapacity: false)
        self.studentList.removeAll(keepCapacity: false)
        for id in self.courseHelper.currentCourse.studentIdList{
            self.getStudentWithId(id)
            if self.doneRequiring{
                delegate.allStudentRequired!()
            }
        }
        return 0
    }
    
    func getStudentWithId(id:String){
        let request = self.authHelper.requestForStudentWithId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                 print(data)
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
            }
        }
    }

}