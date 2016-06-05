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
    
    deinit{
        print("TestHelper Deinited!")
    }
    
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
        authHelper.getResponsePOSTWithCourse(RequestType.GET_QUESTIONS_IN_TEST, parameters: ["test_id": test.testId]){
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
        authHelper.getResponsePOSTWithCourse(RequestType.POST_TEST_ANSWERS, parameters: test.toDict()){
           // [unowned self]
            (error, json) in 
            if error == nil{
                test.taken = true
                var questionIds = [String]()
                for (_, result_dict) in json["results"]{
                    let questionResult = TestQuestionResult(json: result_dict)
                    test.results[questionResult.questionId] = questionResult
                    questionIds.append(questionResult.questionId)
                }
            }
            test.hasTriedPosting = true
            completionHandler(error: error)
        }
    }
    
    func getFinishedTestsInCourse(course: StudentCourse, page: Int, completionHandler: ResponseMessageHandler){
        assert(page >= 1)
        
        StudentAuthenticationHelper.defaultHelper.getResponsePOSTWithCourse(RequestType.GET_FINISHED_TESTS, parameters: ["course_id":course.courseId, "page": page, "descending": true]){
            (error, json) in
            if error == nil{
                course.finishedTests = [StudentTest]()
                for (_, n) in json["tests"]{
                    let test = StudentTest(json: n)
                    course.finishedTests.append(test)
                }
            }
            completionHandler(error: error)
        }
        
    }

    
    func getUnfinishedTestsInCourse(course: StudentCourse, completionHandler: ResponseMessageHandler){
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOSTWithCourse(RequestType.GET_UNFINISHED_TESTS, parameters: ["course_id": course.courseId]){
            (error, json) in
            if error == nil{
                course.unfinishedTests = [StudentTest]()
                for (_, test_json) in json["tests"]{
                    let test = StudentTest(json: test_json)
                    course.unfinishedTests.append(test)
                }
            }
            completionHandler(error: error)
            
        }
        
    }
    
    func getQuestionsForResults(test: StudentTest, completionHandler: ResponseMessageHandler){
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOSTWithCourse(RequestType.GET_QUESTIONS_FOR_RESULT, parameters: ["test_id": test.testId]){
            (error, json) in
            if error == nil{
                for (_, question_dict) in json["questions"]{
                    let question = StudentQuestion(json: question_dict)
                    test.addQuestion(question)
                }
            }
            completionHandler(error: error)
            
        }
    }
    
    func getMyTestResult(test: StudentTest, completionHandler: ResponseMessageHandler){
        let authHelper = StudentAuthenticationHelper.defaultHelper
        authHelper.getResponsePOSTWithCourse(RequestType.GET_STUDENT_TEST_RESULT, parameters: ["test_id": test.testId]){
            [unowned self]
            (error, json)in
            if error == nil{
                test.drop()
                var questionIds = [String]()
                for (question_id, result_dict) in json["results"]{
                    let questionResult = TestQuestionResult(json: result_dict)
                    test.results[question_id] = questionResult
                    questionIds.append(questionResult.questionId)
                }
                
                if questionIds.count != 0{
                    if test.questionsDict[questionIds[0]] == nil{
                        self.getQuestionsForResults(test){
                            error in
                            completionHandler(error: error)
                            return
                        }
                    }
                }
                else{
                    completionHandler(error: error)
                }
            }
            else{
                completionHandler(error: error)
            }
            
        }
    }
    
    
}
