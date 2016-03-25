//
//  StudentTestHelper.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/20.
//  Copyright (c) 2015年 Harold. All rights reserved.
//
import UIKit
import Foundation
import Alamofire
import SwiftyJSON



class StudentTestHelper {
    static var instance:StudentTestHelper?
    
 
    
    static var defaultHelper: StudentTestHelper{
        get{
            if let helper = self.instance{
                return helper
            }
            else{
                self.instance = StudentTestHelper()
                return self.instance!
            }
        }
    }

    var currentTest: StudentTest!
    
    func getQuestionsInUntakenTest(test: StudentTest, completionHandler: ResponseMessageHandler){
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.GET_QUESTIONS_IN_TEST, postBody: ["test_id": test.testId], subIdRequired: true){
         //   [unowned self]
            (error, json) in
            test.drop()
            if error == nil{
                for (_, question_json) in json["questions"]{
                    test.addQuestion(StudentQuestion(json: question_json))
                }
            }
            completionHandler(error: error)
        }
    }
   
    func postTestAnswers(test: StudentTest, completionHandler: ResponseMessageHandler){
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.POST_TEST_ANSWERS, postBody: test.toDict(), subIdRequired: true){
           // [unowned self]
            (error, json) in 
            if error != nil{
                test.taken = true
            }
            completionHandler(error: error)
        }
    }
    
    func getUnfinishedTestsInCourse(course: StudentCourse, completionHandler: ResponseMessageHandler){
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(RequestType.GET_UNFINISHED_TESTS, postBody: ["course_id": course.courseId, "sub_id": course.subId]){
            (error, json) in
            if error == nil{
                for (_, test_json) in json["tests"]{
                    let test = StudentTest().previewFromJSON(test_json)
                    course.unfinishedTests.append(test)
                }
            }
            completionHandler(error: error)
            
        }
        
    }

    
    
}
