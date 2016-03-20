//
//  BaseTestHelper.swift
//  MyClassStudent
//
//  Created by Harold on 15/8/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
protocol TeacherNewTestDelegate{
    func questionAdded(currentQuestionNum: Int)
    func questionRemoved(currentQuestionNum: Int)
}

class TeacherTestHelper{
    
    static var _defaultHelper: TeacherTestHelper?
    static var defaultHelper:TeacherTestHelper{
        get{
            if _defaultHelper == nil{
                _defaultHelper = TeacherTestHelper()
            }
            return _defaultHelper!
        }
    }
    private var delegate: TeacherNewTestDelegate?
    private var _newTest: TeacherTest!
    weak var authHelper = TeacherAuthenticationHelper.defaultHelper
    var newTest: TeacherTest{
        get{
            if self._newTest == nil{
                self._newTest = TeacherTest.getNewTest()
            }
            return self._newTest
        }
    }

    func dropNewTest(){
        self._newTest = nil
    }
    
    func moveNewTestToTestList(){
        
    }
    
    
    func postNewTest(completionHandler: ResponseMessageHandler){
        var dict = self.newTest.toDict()
        dict["course_id"] = TeacherCourse.currentCourse.courseId
        dict["sub_id"] = TeacherCourse.currentCourse.subId
        
        self.authHelper!.getResponse(RequestType.POST_TEST, method: .POST, postBody: dict, headers: nil, tokenRequired: true){
            [unowned self]
            (error, json) in
            if error == nil{
                self.newTest.testId = json["test_id"].stringValue
                self.moveNewTestToTestList()
            }
            completionHandler(error: error)
        }
    }
    
    
    func getUnfinishedTestsInCourse(course: TeacherCourse, completionHandler: ResponseMessageHandler){
        self.authHelper!.getResponse(RequestType.GET_UNFINISHED_TESTS, postBody: ["course_id": course.courseId, "sub_id": course.subId]){
            (error, json) in
            if error == nil{
                for (_, test_json) in json["tests"]{
                    let test = TeacherTest().previewFromJSON(test_json)
                    course.unfinishedTests.append(test)
                    course.unfinishedTestsDict[test.testId] = test
                }
            }
            completionHandler(error: error)
            
        }
        
    }
    
}