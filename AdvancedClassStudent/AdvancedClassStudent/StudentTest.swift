//
//  TestClass.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/3.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON

enum TestQuestionResultType: Int{
    case totallyCorrect = 1
    case wrong = 0
    case noAnswer = -1
    case halfCorrect = 2
    var description: String{
        switch self {
        case .totallyCorrect:
            return "正确"
        case .wrong:
            return "错误"
        case .noAnswer:
            return "未作答"
        case .halfCorrect:
            return "漏选"
        }
    }
}

class TestQuestionResult{
    var questionId: String
    var correct: Int
    var myAnswers: [String]
    var answers: [String]
    var correctType: TestQuestionResultType
    init(json: JSON){
        self.correct = json["correct"].intValue
        self.questionId = json["question_id"].stringValue
        self.myAnswers = json["my_answers"].rawValue as! [String]
        self.answers = json["answers"].rawValue as! [String]
        self.correctType = TestQuestionResultType(rawValue: self.correct)!
    }
}


protocol StudentTestDelegate{
    func allQuestionsAnswered(answered: Bool)
}

class StudentTest{
    init(json: JSON){
        self.finishedCount = json["finished_count"].intValue
        self.expiresOn = json["expires_on"].stringValue
        self.beginsOn = json["begins_on"].stringValue
        self.finished = json["finished"].boolValue
        self.testId = json["test_id"].stringValue
        self.createdOn = json["created_on"].stringValue
        self.taken = json["taken"].boolValue
        self.timeLimit = json["time_limit"].intValue
        
    }
    
    var results = [String: TestQuestionResult]()
    
    var myAnswers = [String: AnyObject]()
    var answeredCount = 0{
        didSet{
            if answeredCount != 0 && answeredCount == self.questionNum{
                self.delegate.allQuestionsAnswered(true)
            }
            else{
                self.delegate.allQuestionsAnswered(false)
            }
        }
    }
    var hasTriedPosting = false
    var questionsAcquired = false
    var testId: String!
    var delegate: StudentTestDelegate!
    var courseId = ""
    var subId = ""
    var finished = false
    var taken = false
    var finishedCount = 0
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
        self.questionNum = 0
        self.results = [String: TestQuestionResult]()
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
            self.answeredCount-=1
            return nil
        }
        self.answeredCount+=1
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

