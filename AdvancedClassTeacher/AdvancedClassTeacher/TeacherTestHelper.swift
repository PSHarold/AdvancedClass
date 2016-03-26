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

@objc class TeacherTestHelper: NSObject{
    
    static var _defaultHelper: TeacherTestHelper?
    static var defaultHelper:TeacherTestHelper{
        get{
            if _defaultHelper == nil{
                _defaultHelper = TeacherTestHelper()
            }
            return _defaultHelper!
        }
    }
    var currentTest: TeacherTest!
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
        
        self.authHelper!.getResponsePOST(RequestType.POST_TEST, postBody: dict){
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
        self.authHelper!.getResponsePOST(RequestType.GET_UNFINISHED_TESTS, postBody: ["course_id": course.courseId, "sub_id": course.subId]){
            (error, json) in
            if error == nil{
                course.unfinishedTests = [TeacherTest]()
                for (_, test_json) in json["tests"]{
                    let test = TeacherTest(json: test_json)
                    course.unfinishedTests.append(test)
                    course.testsDict[test.testId] = test
                }
            }
            completionHandler(error: error)
            
        }
    }
    
    
    
    
    func getFinishedTestsInCourse(course: TeacherCourse, page: Int, completionHandler: ResponseMessageHandler){
        assert(page >= 1)
        
        TeacherAuthenticationHelper.defaultHelper.getResponsePOST(RequestType.GET_FINISHED_TESTS, postBody: ["course_id":course.courseId,"sub_id":course.subId, "page": page, "descending": true]){
            (error, json) in
            if error == nil{
                if page == 1{
                    course.finishedTests = [TeacherTest]()
                }
                for (_, n) in json["tests"]{
                    let test = TeacherTest(json: n)
                    course.finishedTests.append(test)
                }
            }
            completionHandler(error: error)
        }

    }
    
    
    func getQuestionsWithQuestionIds(questionIds: [String], test: TeacherTest, completionHandler: ResponseMessageHandler){
        self.authHelper!.getResponsePOST(.GET_QUESTIONS_IN_LIST, postBody: ["questions": questionIds], subIdRequired: true){
            (error, json) in
            if error == nil{
                for (_, question_json) in json["questions"]{
                    test.addQuestionForResults(TeacherQuestion(json: question_json))
                }
            }
            completionHandler(error: error)
            
            
        }
    }
    
    func getTestResults(test: TeacherTest, completionHandler: ResponseMessageHandler){
        if !test.finished{
            completionHandler(error: CError.TEST_STILL_ONGOING)
            return
        }
        else if test.resultAcquired{
            completionHandler(error: nil)
        }
        else{
            self.authHelper!.getResponsePOST(RequestType.GET_TEST_RESULTS, postBody: ["test_id": test.testId], subIdRequired: true){
                [unowned self]
                (error, json) in
                if error == nil{
                    test.results = TestResult()
                    test.results.getResultsFromJSON(json["results"])
                    test.resultAcquired = true
                }
                
                self.getQuestionsWithQuestionIds(test.results.tempQuestionIds, test: test, completionHandler: completionHandler)
            }
        }
    }
    
    func getUntakenStudents(test: TeacherTest, completionHandler: ResponseMessageHandler){
        if test.finished && test.unfinishedStudents != nil{
            completionHandler(error: nil)
        }
        else{
            self.authHelper!.getResponsePOST(RequestType.GET_UNFINISHED_STUDENTS, postBody: ["test_id": test.testId], subIdRequired: true){
                (error, json) in
                if error == nil{
                    test.getUntakenStudentFromJSON(json, allStudent: TeacherCourse.currentCourse.studentIds)
                }
                completionHandler(error: error)
            }
        }
        
        
    }

    
    
}