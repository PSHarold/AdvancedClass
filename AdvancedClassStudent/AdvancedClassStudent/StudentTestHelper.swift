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

@objc protocol StudentTestHelperDelegate{
    optional func allQuestionsAcquired()
    func networkError()
    optional func noTests()
    optional func allTestsAcquired()
    optional func testResultsAcquiredWithTestId(id:String)
    optional func resultsUploaded()
}

enum TestHelperResult{
    case networkError
    case noQuestionsOrTest
    case allQuestionsAcquired
    case allTestsAcquired
}


class StudentTestHelper {
    static var instance:StudentTestHelper?
    var delegate:StudentTestHelperDelegate!
    let authHelper = StudentAuthenticationHelper.defaultHelper()
    let dateTimeHelper = DateTimeHelper.defaultHelper()
    var total = 0
    var current = 0;
    var done = true
    var courseHelper = StudentCourseHelper.defaultHelper()
    var randomNumber = 0
    var alamofireManager:Alamofire.Manager!
    var testArray = [StudentTest]()
    var testDict = Dictionary<String,StudentTest>()
    var expiredTestArray = [StudentTest]()
    var finishedTestArray = [StudentTest]()
    var unfinishedTestArray = [StudentTest]()
    var testToView:StudentTest!
    
 
    
    class func defaultHelper() -> StudentTestHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = StudentTestHelper()
            return self.instance!
        }
    }

    
    
    
    
    private init(){
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        configuration.timeoutIntervalForResource = 3 // seconds
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        
    }
    
    func getAllTests(){
       // if self.testArray.count == 0{
        self.updateAllTests()
       // }
       // else{
        //    self.delegate.allTestsAcquired!()
        //    return 0
       // }
    }
    
    
    
    func updateAllTests(){
        self.testArray.removeAll(keepCapacity: false)
        self.testDict.removeAll(keepCapacity: false)
        self.expiredTestArray.removeAll(keepCapacity: false)
        self.finishedTestArray.removeAll(keepCapacity: false)
        self.unfinishedTestArray.removeAll(keepCapacity: false)
        self.current = 0
       // self.done = false
        let request = self.authHelper.requestForTestsWithCourseId(courseHelper.currentCourse.courseId, subId: courseHelper.currentCourse.subId)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let listJSON = JSON(data)["_items"]
                var hasItems = false
                for (_,test) in listJSON{
                    hasItems = true
                    self.processTestJSON(test)
                }
                if !hasItems{
                    self.delegate.noTests!()
                    return
                }
                self.sortTests()
                self.delegate.allTestsAcquired!()
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
                self.delegate.networkError()
            }
        }
    }
    
    
    func processTestJSON(testJSON: JSON) {
        let test = StudentTest(json: testJSON)
        self.checkIfFinished(test)
        self.checkIfExpired(test)
        if test.expired{
            self.expiredTestArray.append(test)
        }
        else{
            if test.finished{
                self.finishedTestArray.append(test)
            }
            else{
                self.unfinishedTestArray.append(test)
            }
        }
        self.testDict[test.id] = test
        
        
    }
    
    func checkIfFinished(test:StudentTest){
        test.finished = self.authHelper.myInfo.finishedTestIdArray.contains(test.id)
    }
    
    func checkIfExpired(test:StudentTest){
        
    }
    
    
    //未做的测试放在前面
    func sortTests(){
        for temp in self.unfinishedTestArray{
            self.testArray.append(temp)
        }
        for temp in self.finishedTestArray{
            self.testArray.append(temp)
        }
        for temp in self.expiredTestArray{
            self.testArray.append(temp)
        }
    }
    
    
    
    //异步获取某个题目
    func getQuestionWithId(id:String,test:StudentTest){
        let request = self.authHelper.requestForQuestionWithId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                if data.valueForKey("_error") == nil{
                    test.addAcquiredQuestion(Question(json: JSON(data)))
                    //完成所有题目获取
                    if test.doneAcquiring {
                        self.delegate.allQuestionsAcquired!()
                    }
                }
                else{
                    self.delegate.networkError()
                }
                
            case .Failure(_, let error):
                self.delegate.networkError()
                print(error)
            }
            
            
        }
    }
    
    
    func getQuestionsWithTest(test:StudentTest){
        if test.questionIds.count == 0{
            self.delegate.networkError()
            return
        }
        if test.questionArray.count != 0{
            self.delegate.allQuestionsAcquired!()
            return
        }
        if test.finished{
            for (id,_) in test.results{
                self.getQuestionWithId(id, test: test)
            }
            return
        }
        
        if test.randomNumber == 0{
            for id in test.questionIds{
                self.getQuestionWithId(id,test: test)
            }
        }
        else{
            func randomNo() -> Int {
                return Int(arc4random()) % (test.randomNumber)
            }
            self.total = test.randomNumber
            var randomNumbers = [Int]()
            
            for _ in 0..<test.randomNumber{
                var random = randomNo()
                
                while(randomNumbers.contains(random)){
                    random = randomNo()
                }
                randomNumbers.append(random)
                self.getQuestionWithId(test.questionIds[random], test: test)
            }
        }
        
    }
    
    func hasFinishedAnswering(test:StudentTest) -> Bool{
        for question in test.questionArray{
            if question.result["my_choice"]! == ""{
                return true
            }
        }
        return false
    }
    
    func uploadResults(test:StudentTest) -> Int{
        var results = NSArray()
        for (id,question) in test.questions{
            test.results[id] = (question.result["my_choice"] as! String)
            let temp = ["question_id":id,"result":question.result]
            results =  results.arrayByAddingObject(temp)
        }
        let dict = ["results":results, "student_id":self.authHelper.myInfo.studentId,"random_num":self.randomNumber,"test_id":test.id,"question_num":test.total]
        let request = self.authHelper.requestForResultsUpload(dict)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success:
                self.authHelper.myInfo.finishedTestIdArray.append(test.id)
                let request = self.authHelper.requestForMyInfoModification(["finished_tests":self.authHelper.myInfo.finishedTestIdArray])
                request.responseJSON(){
                    (_,_,result) in
                    switch result {
                    case .Success(let data):
                        self.authHelper.myInfo.etag = JSON(data)["_etag"].stringValue
                        self.delegate.resultsUploaded!()
                    case .Failure:
                        self.delegate.networkError()
                    }
                }
            case .Failure:
                self.delegate.networkError()
                
            }
        }

        test.finished = true
        return 0
    }
    
    
    func getTestResultsWithTest(test:StudentTest){
        if test.results.count != 0{
            self.delegate.testResultsAcquiredWithTestId!(test.id)
            return
        }
        let request = self.authHelper.requestForTestResultsWithTestId(test.id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let results = JSON(data)["_items"][0]
                for (_,result) in results["results"]{
                    let questionId = result["question_id"].stringValue
                    let myChoice = result["result"]["my_choice"].stringValue
                    test.results[questionId] = myChoice
                }
                self.delegate.testResultsAcquiredWithTestId!(test.id)
            case .Failure(_, let error):
                self.delegate.networkError()
                print(error)
            }
        }
    }
    
    
    
}

extension Array{
    func contains(element:Int) -> Bool{
        for a in self{
            if a as! Int == element{
                return true
            }
        }
        return false
    }
    
    func contains(element:String) -> Bool{
        for a in self{
            if a as! String == element{
                return true
            }
        }
        return false
    }
}
