
import Foundation
import SwiftyJSON




enum TestRandomType: Int{
    case MANUAL_FIXED = 0
    case MANUAL_SHUFFLED_ONLY = 1
    case MANUAL_RANDOMLY_CHOOSE = 2
    case AUTOMATIC_RANDOMLY_CHOOSE  = 3    
}








class TeacherTest{
    
    var resultAcquired = false
    var results: TestResult!
    
    static func getNewTest() -> TeacherTest{
        let test = TeacherTest()
        test.courseId = String(TeacherCourse.currentCourse.courseId)
        test.subId = String(TeacherCourse.currentCourse.subId)
        test.questionsFixed = [TeacherQuestion]()
        test.questiontDict = [String: Bool]()
        return test
    }
    
    init(){
        
    }
    
    init(json: JSON){
        self.finishedStudentsCount = json["finished_students_count"].intValue
        self.expiresOn = json["expires_on"].stringValue
        self.beginsOn = json["begins_on"].stringValue
        self.finished = json["finished"].boolValue
        self.testId = json["test_id"].stringValue
        self.createdOn = json["created_on"].stringValue
        self.randomType = json["random_type"].intValue
    }
    var testId: String!
    var courseId = ""
    var subId = ""
    var finished = false
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
    var questionsForResults = [String: TeacherQuestion]()
    var message = ""
    var randomType: Int!
    var _blacklist: [String]?
    var blacklist: [String]{
        get{
            if self._blacklist == nil{
                return []
            }
            return self._blacklist!
        }
        set{
            self._blacklist = newValue
        }
    }
    var totalNum = 0
    var randomTypeEnum: TestRandomType{
        get{
            return TestRandomType(rawValue: self.randomType)!
        }
        set{
            self.randomType = newValue.rawValue
        }
    }
    
    
    var questiontDict: [String: Bool]!
    var questionsFixed: [TeacherQuestion]!
    var finishedStudents: [Student]!
    
    
    func toDict() -> [String: AnyObject]{
        var dict = [String: AnyObject]()
        dict["begins_on"] = self.beginsOn
        dict["expires_on"] = self.expiresOn
        dict["message"] = self.message
        dict["time_limit"] = self.timeLimit
        dict["blacklist"] = self.blacklist
        if self.randomTypeEnum == .MANUAL_FIXED || self.randomTypeEnum == .MANUAL_SHUFFLED_ONLY{
            dict["question_settings"] = ["questions": self.questionsFixed.map({$0.questionId}), "has_hint": []]
        }
        return dict
    }
    
    
    func hasQuestion(question: TeacherQuestion) -> Bool{
        return self.questiontDict[question.questionId] != nil
    }
    
    func addQuestion(question: TeacherQuestion, random:Bool=false){
        
        if self.randomTypeEnum == .MANUAL_FIXED || self.randomTypeEnum == .MANUAL_SHUFFLED_ONLY{
            self.questionsFixed.append(question)
            self.totalNum += 1
            self.questiontDict[question.questionId] = true
            return
        }
        
    }
    
    func removeQuestion(question: TeacherQuestion, random:Bool=false){
        
        if self.randomTypeEnum == .MANUAL_FIXED || self.randomTypeEnum == .MANUAL_SHUFFLED_ONLY{
            self.questionsFixed.removeAtIndex(self.questionsFixed.indexOf({ q in return q === question})!)
            self.totalNum -= 1
            self.questiontDict.removeValueForKey(question.questionId)
            return
        }
    }
    
    
    func removeAllQuestions(){
        
        self.totalNum = 0
        self.questiontDict?.removeAll()
    }
    
    func addQuestionForResults(question: TeacherQuestion){
        self.questionsForResults[question.questionId] = question
    }
    
    func setRandomNumber(number: Int, questionType: QuestionType, knowledgePointId: String){
    }

}

class QuestionResult{
    var questionId: String!
    var totalTaken = 0
    var totalCorrect = 0
    var studentsByAnswer = [String: [String]]()
    var answersByStudent = [String: [String]]()
    var correctRatio: Double = 0
    
    init(json: JSON){
        self.questionId = json["question_id"].stringValue
        self.totalTaken = json["total_taken"].intValue
        self.totalCorrect = json["total_correct"].intValue
        self.correctRatio = self.totalTaken == 0 ? 0.0 : Double(self.totalCorrect)/Double(self.totalTaken)
    }
}

class KnowledgePointResult{
    var knowledgePointId: String!
    var totalTaken = 0
    var totalCorrect = 0
    var correctRatio: Double = 0
    var questionResults = [String: QuestionResult]()
    init(json: JSON){
        self.knowledgePointId = json["point_id"].stringValue
        self.totalTaken = json["total_taken"].intValue
        self.totalCorrect = json["total_correct"].intValue
        self.correctRatio = self.totalTaken == 0 ? 0.0 : Double(self.totalCorrect)/Double(self.totalTaken)
    }
}

class TestResult {
    var tempQuestionIds = [String]()
    var questionResults = [String: QuestionResult]()
    var knowledgePointResults = [String: KnowledgePointResult]()
    var knowledgePointResultsSorted = [KnowledgePointResult]()
    init(json: JSON){
        for (_, poiontResultDict) in json["point_results"]{
            let p = KnowledgePointResult(json: poiontResultDict)
            self.knowledgePointResults[p.knowledgePointId] = p
            self.knowledgePointResultsSorted.append(p)
        }
        for (_, questionResult) in json["question_results"]{
            let p = QuestionResult(json: questionResult)
            self.questionResults[p.questionId] = p
            self.tempQuestionIds.append(p.questionId)
            
        }
        self.knowledgePointResultsSorted.sortInPlace({$0.correctRatio < $1.correctRatio})
    }
    
    
    
    func getQuestionResult(questionId: String) -> QuestionResult?{
        return self.questionResults[questionId]
    }
}



