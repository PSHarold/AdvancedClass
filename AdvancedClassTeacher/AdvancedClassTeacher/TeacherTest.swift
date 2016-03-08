
import Foundation
import SwiftyJSON




enum TestRandomType: Int{
    case MANUAL_FIXED = 0
    case MANUAL_SHUFFLED_ONLY = 1
    case MANUAL_RANDOMLY_CHOOSE = 2
    case AUTOMATIC_RANDOMLY_CHOOSE  = 3
    
}




class TeacherNewTest{
    
    
    
    
    var courseId = String(TeacherCourse.currentCourse.courseId)
    var subId = String(TeacherCourse.currentCourse.subId)
    var beginsOn: String!
    var beginsOnNSDate: NSDate!
    
    var expiresOn: String!
    var expiresOnNSDate: NSDate!
    var questions = [String: [Int: [String: AnyObject]]]()
    var message: String!
    var randomType: Int!
    var blacklist: [String]!
    var totalNum = 0
    
    var questiontDict = [String: Bool]()
    
    
    func postNewTest(completionHandler: ResponseHandler){
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        authHelper.getResponse(RequestType.POST_TEST, method: .POST, postBody: self.toDict(), headers: nil, tokenRequired: true, completionHandler: completionHandler)
    }
    
    func toDict() -> [String: AnyObject]{
        var dict = [String: AnyObject]()
        dict["begins_on"] = self.beginsOn
        dict["expires_on"] = self.expiresOn
        dict["message"] = self.message
        dict["blacklist"] = self.blacklist
        dict["questions"] = self.questions
        return dict
    }
    
    
    func hasQuestion(question: TeacherQuestion) -> Bool{
        return self.questiontDict[question.questionId] != nil
    }
    
    func addQuestion(question: TeacherQuestion, random:Bool=false){
        if self.questions[question.knowledgePointId] == nil{
            var t = [Int: [String: AnyObject]]()
            for type in QuestionType.allValues{
                t[type] = ["num": 0, "questions": [String]()]
            }
            self.questions[question.knowledgePointId] = t
        }
        
        var qList = self.questions[question.knowledgePointId]!
        if random{
            qList[question.questionType.rawValue]!["num"] = qList[question.questionType.rawValue]!["num"] as! Int + 1
        }
        var questions = qList[question.questionType.rawValue]!["questions"] as! [String]
        questions.append(question.questionId)
        qList[question.questionType.rawValue]!["questions"] = questions
        self.questions[question.knowledgePointId] = qList
        
        
        self.questiontDict[question.questionId] = true
        ++self.totalNum
    }
    
    func removeQuestion(question: TeacherQuestion, random:Bool=false){
        if var qList = self.questions[question.knowledgePointId]{
            if random{
                qList[question.questionType.rawValue]!["num"] = qList[question.questionType.rawValue]!["num"] as! Int - 1
            }
            var questions = qList[question.questionType.rawValue]!["questions"] as! [String]
            questions.removeAtIndex(questions.indexOf(question.questionId)!)
            qList[question.questionType.rawValue]!["questions"] = questions
            self.questions[question.knowledgePointId] = qList
            self.questiontDict.removeValueForKey(question.questionId)
            --self.totalNum
        }
        
    }
    
    func removeAllQuestions(){
        self.questions.removeAll()
        self.totalNum = 0
        self.questiontDict.removeAll()
    }
    
    func setRandomNumber(number: Int, questionType: QuestionType, knowledgePointId: String){
        if self.questions[knowledgePointId] == nil{
            self.questions[knowledgePointId] = [Int: [String: AnyObject]]()
        }
        var t = self.questions[knowledgePointId]!
        for type in QuestionType.allValues{
            t[type] = ["num": number, "questions": [String]()]
        }
    }
    
}


class TeacherTest{
    var courseId: String!
    var subId: String!
    var createdOn: String!
    var beginsOn: String!
    var beginsOnNSDate: NSDate!
    var expiresOn: String!
    var expiresOnNSDate: NSDate!
    var questions = [TeacherQuestion]()
    var questionIds = [String]()
    var message: String!
    var randomType: Int!
    var randomSettings: [String: AnyObject]!
    var by: String!
    var blackList: [String]!
    init(json:JSON){
        self.createdOn = json["createdOn"].stringValue
        self.beginsOn = json["begins_on"].stringValue
        self.beginsOnNSDate = self.beginsOn.toNSDate()
        self.expiresOn = json["expires_on"].stringValue
        self.expiresOnNSDate = self.expiresOn.toNSDate()
        
    }
    
    
}

