//
//  TestClass.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/3.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON



class StudentTest{
    
    func previewFromJSON(json: JSON) -> StudentTest{
        self.finishedStudentsCount = json["finished_students_count"].intValue
        self.expiresOn = json["expires_on"].stringValue
        self.beginsOn = json["begins_on"].stringValue
        self.finished = json["finished"].boolValue
        self.testId = json["test_id"].stringValue
        self.createdOn = json["created_on"].stringValue
        return self
    }
    var myAnswers = [String: [AnyObject]]()
    var questionsAcquired = false
    var testId: String!
    var courseId = ""
    var subId = ""
    var finished = false
    var taken = false
    var createdOn: String!
    var _beginsOn: String?
    var beginsOn: String{
        get{
            if self._beginsOn == nil{
                return ""
            }
            return self._beginsOn!
        }
        set{
            self._beginsOn = newValue
            self.beginsOnNSDate = newValue.toNSDate()
        }
        
    }
    var beginsOnNSDate: NSDate!
    var timeLimit = -1
    var finishedStudentsCount: Int!
    var _expiresOn: String?
    var expiresOn: String{
        get{
            if self._expiresOn == nil{
                return ""
            }
            return self._expiresOn!
        }
        set{
            self._expiresOn = newValue
            self.expiresOnNSDate = newValue.toNSDate()
        }
        
    }
    
    var expiresOnNSDate: NSDate!
    var questionsDict = [String: StudentQuestion]()
    var questions = [StudentQuestion]()
    var message = ""
    var questionNum = 0
    
    
    
    func addQuestion(question: StudentQuestion){
        self.questions.append(question)
        self.questionsDict[question.questionId] = question
        ++self.questionNum
    }
    
    
    func makeAnswerWithQuestionId(questionId: String, answer: AnyObject){
        if self.myAnswers[questionId] == nil{
            self.myAnswers[questionId] = [AnyObject]()
        }
        self.myAnswers[questionId]!.append(answer)
    }
    
    func toDict() -> [String: AnyObject]{
        return ["my_answers": self.myAnswers, "test_id": self.testId]
    }
    
    
}

