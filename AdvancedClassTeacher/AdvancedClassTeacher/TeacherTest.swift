
import Foundation
import SwiftyJSON




enum TestType: Int{
    case MANUAL_FIXED = 0
    case MANUAL_SHUFFLED_ONLY = 1
    case MANUAL_RANDOMLY_CHOOSE = 2
    case AUTOMATIC_RANDOMLY_CHOOSE  = 3
    var description: String{
        get{
            switch self {
            case .MANUAL_FIXED:
                return "手动选题固定顺序"
            case .MANUAL_SHUFFLED_ONLY:
                return "手动选题随机顺序"
            default:
                return ""
            }
        }
    }
    
}








class TeacherTest{
    
    var resultAcquired = false
    var results: TestResult!
    var unfinishedStudents: [String]!
    var finishedStudents: [String]!
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
    var finishedCount: Int!
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
    var testType: Int!
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
    var testTypeEnum: TestType{
        get{
            return TestType(rawValue: self.testType)!
        }
        set{
            self.testType = newValue.rawValue
        }
    }
    
    
    var questiontDict: [String: Bool]!
    var questionsFixed: [TeacherQuestion]!

    
    
    
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
        self.finishedCount = json["finished_count"].intValue
        self.expiresOn = json["expires_on"].stringValue
        self.beginsOn = json["begins_on"].stringValue
        self.finished = json["finished"].boolValue
        self.testId = json["test_id"].stringValue
        self.createdOn = json["created_on"].stringValue
        self.testType = json["random_type"].intValue
    }
    
    
    
    func toDict() -> [String: AnyObject]{
        var dict = [String: AnyObject]()
        dict["begins_on"] = self.beginsOn
        dict["expires_on"] = self.expiresOn
        dict["message"] = self.message
        dict["time_limit"] = self.timeLimit
        dict["blacklist"] = self.blacklist
        if self.testTypeEnum == .MANUAL_FIXED || self.testTypeEnum == .MANUAL_SHUFFLED_ONLY{
            dict["question_settings"] = ["questions": self.questionsFixed.map({$0.questionId}), "has_hint": []]
        }
        return dict
    }
    
    
    func hasQuestion(question: TeacherQuestion) -> Bool{
        return self.questiontDict[question.questionId] != nil
    }
    
    func addQuestion(question: TeacherQuestion, random:Bool=false){
        
        if self.testTypeEnum == .MANUAL_FIXED || self.testTypeEnum == .MANUAL_SHUFFLED_ONLY{
            self.questionsFixed.append(question)
            self.totalNum += 1
            self.questiontDict[question.questionId] = true
            return
        }
        
    }
    
    func removeQuestion(question: TeacherQuestion, random:Bool=false){
        
        if self.testTypeEnum == .MANUAL_FIXED || self.testTypeEnum == .MANUAL_SHUFFLED_ONLY{
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
    var answersCount = [String: Int]()
    var correctRatio: Double = 0
    
    init(json: JSON){
        
        for (answer, count) in json["answers"]{
            self.answersCount[answer] = count.intValue
        }
        self.totalTaken = json["total_finished"].intValue
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
    var questionResultsSorted = [QuestionResult]()
    var questionResultsAscending = true
    init(json: JSON){
       
        self.totalTaken = json["total_finished"].intValue
        self.totalCorrect = json["total_correct"].intValue
        self.correctRatio = self.totalTaken == 0 ? 0.0 : Double(self.totalCorrect)/Double(self.totalTaken)
    }
    func sortQuestionPointResults(ascending: Bool){
        if ascending{
            self.questionResultsSorted.sortInPlace({$0.correctRatio < $1.correctRatio})
        }
        else{
            self.questionResultsSorted.sortInPlace({$0.correctRatio > $1.correctRatio})
        }
        self.questionResultsAscending = ascending
    }
    
    
}

class TestResult {
    var tempQuestionIds = [String]()
    var questionResults = [String: QuestionResult]()
    var questionResultsSorted = [QuestionResult]()
    var knowledgePointResults = [String: KnowledgePointResult]()
    var knowledgePointResultsSorted = [KnowledgePointResult]()
    var knowledgePointResultsAscending = true
    var questionResultsAscending = true
    
    
    init(){}
    
    
    func getResultsFromJSON(json: JSON){
        for (knowledgePointId, poiontResultDict) in json["point_results"]{
            let p = KnowledgePointResult(json: poiontResultDict)
            self.knowledgePointResults[knowledgePointId] = p
            p.knowledgePointId = knowledgePointId
            self.knowledgePointResultsSorted.append(p)
        }
        for (questionId, questionResult) in json["question_results"]{
            let p = QuestionResult(json: questionResult)
            self.questionResults[questionId] = p
            self.tempQuestionIds.append(questionId)
            p.questionId = questionId
            self.knowledgePointResults[questionResult["point_id"].stringValue]?.questionResults[questionId] = p
            self.knowledgePointResults[questionResult["point_id"].stringValue]?.questionResultsSorted.append(p)
            self.questionResultsSorted.append(p)
        }
        self.sortKnowledgePointResults(true)
        for p in self.knowledgePointResultsSorted{
            p.sortQuestionPointResults(true)
        }
        self.sortQuestionPointResults(true)
    }
    
    
    func sortKnowledgePointResults(ascending: Bool){
        if ascending == self.knowledgePointResultsAscending{
            return
        }
        if ascending{
            self.knowledgePointResultsSorted.sortInPlace({$0.correctRatio < $1.correctRatio})
        }
        else{
            self.knowledgePointResultsSorted.sortInPlace({$0.correctRatio > $1.correctRatio})
        }
        self.knowledgePointResultsAscending = ascending
    }
    
    func sortQuestionPointResults(ascending: Bool){
        if ascending == self.questionResultsAscending{
            return
        }
        if ascending{
            self.questionResultsSorted.sortInPlace({$0.correctRatio < $1.correctRatio})
        }
        else{
            self.questionResultsSorted.sortInPlace({$0.correctRatio > $1.correctRatio})
        }
        self.questionResultsAscending = ascending
    }
    
    func getQuestionResult(questionId: String) -> QuestionResult?{
        return self.questionResults[questionId]
    }
    func getQuestionResult(question: TeacherQuestion) -> QuestionResult?{
        return self.questionResults[question.questionId]
    }
}



