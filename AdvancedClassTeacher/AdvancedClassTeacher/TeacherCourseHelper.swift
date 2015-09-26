//
//  CourseHelper.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
protocol TeacherCourseHelperDelegate{
    func allCoursesRequired()
}

class TeacherCourseHelper {
    static var instance:TeacherCourseHelper!
    var alamofireManager : Alamofire.Manager!
    var delegate:TeacherCourseHelperDelegate!
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var courseArray = [TeacherCourse]()
    var currentCourse:TeacherCourse!
    var _doneAcquiring = true
    var totalCourseNumber = 0
    var _currentCourseNumber = 0
    var currentCourseNumber:Int{
        get{
            return self._currentCourseNumber
        }
        set{
            self._currentCourseNumber = newValue
            if newValue == self.totalCourseNumber{
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
                self.currentCourseNumber = 0
            }
        }
    }
    
    
    func getAllCourses() -> Int{
        if self.courseArray.count == 0{
            //self.courseArray.removeAll(keepCapacity: false)
            self.totalCourseNumber = self.authHelper.myInfo.courses.count
            for course in self.authHelper.myInfo.courses{
                self.getCourseWithId(course["courseId"]!,subId: course["subId"]!)
                
            }
            return 0
        }
        else{
            return 0
        }
    }
    
    func getCourseWithId(id:String,subId:String) {
        
        let request = self.authHelper.requestForCourseWithCourseId(id, subId: subId)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                self.courseArray.append(TeacherCourse(json:JSON(data)["_items"][0]))
                ++self.currentCourseNumber
                if self.doneAcquiring{
                    self.delegate.allCoursesRequired()
                }
                
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getCurrentRoomId() -> String{
        return "cs0000"
    }
    

    private init() {
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        configuration.timeoutIntervalForResource = 3 // seconds
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        
    }
    
    class func defaultHelper() -> TeacherCourseHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = TeacherCourseHelper()
            return self.instance!
        }
    }

    
}