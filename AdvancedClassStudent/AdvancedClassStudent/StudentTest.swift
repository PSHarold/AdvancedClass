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
    var myAnswers = [String: AnyObject]()
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
    
    func drop(){
        self.questions = [StudentQuestion]()
        self.questionsDict = [String: StudentQuestion]()
        self.myAnswers = [String: AnyObject]()
    }
    
    func addQuestion(question: StudentQuestion){
        self.questions.append(question)
        self.questionsDict[question.questionId] = question
        self.questionNum += 1
    }
    
    
    func changeMyAnswerWithQuestion(question: StudentQuestion, answer: AnyObject) -> AnyObject?{
        let questionId = question.questionId
        var already = false
        if let answer = answer as? Int{
            if self.myAnswers[questionId] == nil{
                self.myAnswers[questionId] = [Int]()
                
            }
            var a = self.myAnswers[questionId]! as! [Int]
            if a.contains({$0 == answer}){
                a.removeAtIndex(a.indexOf(answer)!)
                already = true
            }
            else{
                a.append(answer)
            }
            self.myAnswers[questionId] = a
            
        }
        else if let answer = answer as? String{
            if self.myAnswers[questionId] == nil{
                self.myAnswers[questionId] = [String]()
            }
            var a = self.myAnswers[questionId]! as! [String]
            if a.contains({$0 == answer}){
                a.removeAtIndex(a.indexOf(answer)!)
                already = true
            }
            else{
                a.append(answer)
            }
            self.myAnswers[questionId] = a
        }
        if already{
            return nil
        }
        return answer
    }
    
    func getMyAnswersWithQuestion(question: StudentQuestion) -> AnyObject?{
        return self.myAnswers[question.questionId]
    }
    
    
    func toDict() -> [String: AnyObject]{
        return ["my_answers": self.myAnswers, "test_id": self.testId]
    }
    
    func hasAnsweredQuestion(question: StudentQuestion) -> Bool{
        if let answers = self.myAnswers[question.questionId] as? [AnyObject]{
            if answers.count == 0{
                return false
            }
            return true
        }
        return false
    }
    
    
}

