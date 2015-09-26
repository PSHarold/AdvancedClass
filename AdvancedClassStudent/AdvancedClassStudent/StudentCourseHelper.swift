//
//  StudentCourseHelper.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
protocol StudentCourseHelperDelegate{
    func allCoursesRequired()
}

class StudentCourseHelper {
    static var instance:StudentCourseHelper!
    var alamofireManager : Alamofire.Manager!
    var delegate:StudentCourseHelperDelegate!
    var authHelper = StudentAuthenticationHelper.defaultHelper()
    var courseArray = [StudentCourse]()
    var currentCourse:StudentCourse!
    var _doneAcquiring = true
    var _totalCourseNumber = 0
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
    var totalCourseNumber:Int{
        get{
            return self._totalCourseNumber
        }
        set{
            self._totalCourseNumber = newValue
            self.doneAcquiring = false
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
                self.courseArray.append(StudentCourse(json:JSON(data)["_items"][0]))
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
    
    class func defaultHelper() -> StudentCourseHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = StudentCourseHelper()
            return self.instance!
        }
    }
    
    
}