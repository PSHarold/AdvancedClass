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


@objc protocol TeacherTestHelperDelegate{
    optional func allKnowledgePointsAcquired()
    optional func testResultsAcquired()
    optional func allQuestionsAcquired()
    func networkError()
    optional func noQuestionsOrTest()
    optional func allTestsAcquired()
    optional func allQuestionsAcquiredWithTestId(id:String)
    optional func questionUploaded()
    optional func questionRemovedAtIndexPath(indexPath:NSIndexPath)
    optional func testUploaded()
    optional func testRemovedAtIndexPath(indexPath:NSIndexPath)
    optional func testUpdated()
}


class Chapter{
    var chapterNo:Int!
    var points:[String]!
    var No:Int!
    init(chapterNo:Int,points:[String]){
        self.chapterNo = chapterNo
        self.points = points
    }
}
class Chapters{
    var chapters = [Chapter]()
    var chaptersDict = Dictionary<String,Chapter>()
    var maxChapterNo = 0
    func addChapter(chapter:Chapter){
        if(self.maxChapterNo < chapter.chapterNo){
            self.maxChapterNo = chapter.chapterNo
        }
        self.chapters.append(chapter)
        self.chaptersDict["\(chapter.chapterNo)"] = chapter
    }
    func sortByChapter(){
        self.chapters.sortInPlace(){$0.chapterNo < $1.chapterNo}
        for var i = 0;i < self.chapters.count;++i{
            self.chapters[i].No = i
        }
    }
}


enum TestHelperResult{
    case networkError
    case noQuestionsOrTest
    case allQuestionsAcquired
    case allTestsAcquired
    case allQuestionsInTestAcquired
}

class TeacherTestHelper {
    var delegate:TeacherTestHelperDelegate!
    let dateTimeHelper = DateTimeHelper.defaultHelper()
    var courseHelper = TeacherCourseHelper.defaultHelper()
    var totalQuestionNumber = 0
    var _currentQuestionNumber = 0
    var totalTestNumber = 0
    var _currentTestNumber = 0
    var _doneAcquiring = true
    var alamofireManager : Alamofire.Manager!
    var allTestArray = [TeacherTest]()
    var allTestDict = Dictionary<String,TeacherTest>()
    //var expiredTestArray = [TeacherTest]()
   //var unexpiredTestArray = [TeacherTest]()
    var _newTest:TeacherTest?
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var teacherDelegate:TeacherTestHelperDelegate!
    var knowledgePoints:Chapters!
    static var instance:TeacherTestHelper?
    var allQuestionArray = [TeacherQuestion]()
    var allQuestionDict = Dictionary<String,TeacherQuestion>()
    var testToView:TeacherTest!
    var newTest:TeacherTest!{
        get{
            if let test = self._newTest{
                return test
            }
            self._newTest = TeacherTest()
            return self._newTest!
        }
        set{
            self._newTest = newValue
        }
    }
    var currentTestNumber:Int{
        get{
            return self._currentTestNumber
        }
        set{
            self._currentTestNumber = newValue
            if newValue == self.totalTestNumber{
                self.doneAcquiring = true
            }
        }
        
    }
    
    var currentQuestionNumber:Int{
        get{
            return self._currentQuestionNumber
        }
        set{
            self._currentQuestionNumber = newValue
            if newValue == self.totalTestNumber{
                self.doneAcquiring = true
            }
        }
    }
    
    var doneAcquiring:Bool{
        get{
            return self._doneAcquiring
        }
        set{
            self._doneAcquiring = newValue
            if !newValue{
                self.currentTestNumber = 0
                self.currentQuestionNumber = 0
            }
        }
    }
    private init() {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.timeoutIntervalForResource = 3 // seconds
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    //获取所有测试，若已有则不更新，无则更新
    func getAllTests() -> Int{
        if self.allTestArray.count != 0{
            self.delegate.allTestsAcquired!()
            return 0
        }
        else{
            return self.updateAllTests()
        }
    }
    
    //更新测试
    func updateAllTests() -> Int{
        if !self.doneAcquiring {
            return 1
        }
        self.allTestArray.removeAll(keepCapacity: false)
        self.allTestDict.removeAll(keepCapacity: false)
        //self.expiredTestArray.removeAll(keepCapacity: false)
        //self.unexpiredTestArray.removeAll(keepCapacity: false)
        self.doneAcquiring = false
        let request = self.authHelper.requestForTestsWithCourseId(courseHelper.currentCourse.courseId, subId: courseHelper.currentCourse.subId)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let listJSON = JSON(data)["_items"]
                for (_,test) in listJSON{
                    self.allTestArray.append(TeacherTest(json:test))
                }
                self.sortTests()
                //self.expiredTestArray.removeAll()
                //self.unexpiredTestArray.removeAll()
                self.delegate.allTestsAcquired!()
            case .Failure:
                self.delegate.networkError()
            }
            
            
        }
        
        return 0
    }
    
//    func processTest(test:TeacherTest){
//        self.addTest(test)
//    }
//
//    //获取测试后加入到测试列表（分类）
//    func addTest(test:TeacherTest){
//        if test.expired{
//            self.expiredTestArray.append(test)
//        }
//        else{
//            self.unexpiredTestArray.append(test)
//        }
//    }
    
    //正在进行的测试放在前面
    func sortTests(){
//        for temp in self.unexpiredTestArray{
//            self.allTestArray.append(temp)
//        }
//        for temp in self.expiredTestArray{
//            self.allTestArray.append(temp)
//        }
        let closure = {(test1:TeacherTest,test2:TeacherTest) -> Bool in
            if !test1.expired && test2.expired{
                return true
            }
            else if test1.expired && !test2.expired{
                return false
            }
            return test1.startTimeDate.compare(test2.startTimeDate) != NSComparisonResult.OrderedAscending
        }
        self.allTestArray.sortInPlace(closure)
    }
    
    
    func getQuestionWithId(id:String,test:TeacherTest){
        let request = self.authHelper.requestForQuestionWithId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                if data.valueForKey("_error") == nil{
                    test.addAcquiredQuestion(TeacherQuestion(json: JSON(data)))
                    //完成所有题目获取
                    if test.done {
                        self.delegate.allQuestionsAcquiredWithTestId!(test.id)
                    }
                }
                else{
                    self.delegate.networkError()
                }

            case .Failure(_, _):
                self.delegate.networkError()
            }
            
    
        }
    }
    
    func getQuestionsWithTest(test:TeacherTest){
        if test.questionArray.count != 0{
            self.delegate.allQuestionsAcquiredWithTestId!(test.id)
            return
        }
        let ids = test.questionIds
        for id in ids{
            self.getQuestionWithId(id,test: test)
        }
    }
    
    
    
    func endTestWithTest(test:TeacherTest){
        if test.expired{
            return
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"

        let request = self.authHelper.requestForTestModificationWithQuestionId(test.id, etag: test.etag, patchDict: ["expired":true,"deadline":dateFormatter.stringFromDate(NSDate())])
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success:
                self.sortTests()
                self.delegate.testUploaded!()
            case .Failure:
                self.delegate.networkError()
            }
        }
    }
    
    
    func getAllQuestions() -> Int{
        if self.allQuestionArray.count != 0{
            self.delegate.allQuestionsAcquired!()
            return 0
        }
        else{
            return self.updateAllQuestions()
        }
    }
    
    func modifyDeadlineWithTest(test:TeacherTest,date:String){
        let request = self.authHelper.requestForTestModificationWithQuestionId(test.id, etag: test.etag, patchDict: ["deadline":date])
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                test.etag = JSON(data)["_etag"].stringValue
                self.delegate.testUploaded!()
            case .Failure:
                self.delegate.networkError()
            }
        }
    }
    
    //获取所有问题
    func updateAllQuestions() -> Int{
        if !self.doneAcquiring {
            return 1
        }
        self.doneAcquiring = false
        self.allQuestionArray.removeAll(keepCapacity: false)
        self.allQuestionDict.removeAll(keepCapacity: false)
        let request = self.authHelper.requestForQuestionsWithCourseId(self.courseHelper.currentCourse.courseId)
        request.responseJSON{
            (_,_,result) in
            switch result {
            case .Success(let data):
                let questionList = JSON(data)["_items"]
                if questionList == JSON.null {
                    self.delegate.networkError()
                    return
                }
                for (_,questionJSON) in questionList{
                    self.questionAcquired(TeacherQuestion(json: questionJSON))
                }
                self.delegate.allQuestionsAcquired!()
                
            case .Failure:
                self.delegate.networkError()
            }
        }
        return 0
    }
    
   
    
    func questionAcquired(question:TeacherQuestion){
        self.allQuestionArray.append(question)
        self.allQuestionDict[question.id] = question
        ++self.currentQuestionNumber
    }
    
    
    
    func uploadQuestion(question:TeacherQuestion) -> Int{
        let request = self.authHelper.requestForQuestionUploading(question.toDict())
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success:
                self.delegate.questionUploaded!()
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
            }
        }
        return 0
    }
    
    func uploadTest() -> Int {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let time = self.dateTimeHelper.currentTime
        let dict = ["question_list":self.newTest.questionIds, "has_hint":self.newTest.hasHint,"random_num":self.newTest.randomNumber,"course_id":self.courseHelper.currentCourse.courseId,"expired":false,"start_time":time,"time_limit":self.newTest.timeLimitInt,"info":"","message":self.newTest.message,"sub_id":self.courseHelper.currentCourse.subId,"deadline":self.newTest.deadlineDate == nil ? "" : dateFormatter.stringFromDate(self.newTest.deadlineDate!)]
        self.newTest.startTime = time
        
        let request = self.authHelper.requestForTestUploading(dict as! Dictionary<String, AnyObject>)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                self.newTest.etag = json["_etag"].stringValue
                self.newTest.id = json["_id"].stringValue
                self.allTestArray.append(self.newTest)
                self.newTest = nil
                self.sortTests()
                self.delegate.testUploaded!()
            case .Failure:
                self.delegate.networkError()
            }
        }
        return 0
    }
    
    
    func deleteTest(test:TeacherTest,indexPath:NSIndexPath) -> Int{
        let request = self.authHelper.requestForTestDeletionWithTestId(test.id, etag: test.etag)
        request.responseData(){
            (_,_,result) in
            switch result {
            case .Success:
                self.delegate.testRemovedAtIndexPath!(indexPath)
            case .Failure:
                self.delegate.networkError()
            }
        }
        return 0
    }
    
    func deleteQuestion(question:TeacherQuestion,indexPath:NSIndexPath) -> Int{
        let request = self.authHelper.requestForQuestionDeletionWithQuestionId(question.id, etag: question.etag)
        request.responseData(){
            (_,_,result) in
            switch result {
            case .Success:
                self.delegate.questionRemovedAtIndexPath!(indexPath)
            case .Failure:
                self.delegate.networkError()
            }
        }
        return 0
    }
    
    func modifyQuestion(question:TeacherQuestion) -> Int{
        let request = self.authHelper.requestForQuestionModificationWithQuestionId(question.id, etag: question.etag, patchDict: question.toDict())
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                question.etag = JSON(data)["_etag"].stringValue
                self.delegate.questionUploaded!()
            case .Failure:
               self.delegate.networkError()
            }
        }
        return 0
    }
    
    
    func getKnowledgePoints(courseId:String){
        if self.knowledgePoints != nil{
            self.delegate.allKnowledgePointsAcquired!()
            return
        }
        let request = self.authHelper.requestForKnowledgePoints()
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)
                self.knowledgePoints = Chapters()
                for (_,chapter) in json["_items"][0]["chapters"]{
                    var temp = [String]()
                    for (_,point) in chapter["points"]{
                        temp.append(point.stringValue)
                    }
                    self.knowledgePoints.addChapter(Chapter(chapterNo: chapter["chapter"].intValue, points:temp ))
                }
                self.knowledgePoints.sortByChapter()
                self.delegate.allKnowledgePointsAcquired!()
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getTestResultsWithTest(test:TeacherTest){
        if test.resultsByStudentId != nil{
            self.delegate.testResultsAcquired!()
            return
        }
        test.resultsByStudentId = Dictionary<String,Dictionary<String,Result>>()
        test.resultsByQuestion = Dictionary<String,Dictionary<String,Result>>()
        let request = self.authHelper.requestForTestResultsWithCourseId(test.id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let json = JSON(data)["_items"]
                for (_,results) in json{
                    let studentId = results["student_id"].stringValue
                    for (_,result) in results["results"]{
                        let questionId = result["question_id"].stringValue
                        let question = test.questions[questionId]!
                        let result = Result(json: result["result"])
                        result.questionId = questionId
                        result.studentId = studentId
                        if result.isCorrect{
                            ++question.numberOfCorrect
                        }
                        ++question.numberOfChoice[result.choice]!
                        question.studentsWithChocie[result.choice]!.append(studentId)
                        if test.resultsByQuestion[questionId] == nil{
                            test.resultsByQuestion[questionId] = Dictionary<String,Result>()
                        }
                        if test.resultsByStudentId[studentId] == nil{
                            test.resultsByStudentId[studentId] = Dictionary<String,Result>()
                        }
                        test.resultsByQuestion[questionId]![studentId] = result
                        test.resultsByStudentId[studentId]![questionId] = result
                    }
                }
                self.delegate.testResultsAcquired!()
            case .Failure:
                self.delegate.networkError()
            }
        }
    }    
    
    class func defaultHelper() -> TeacherTestHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = TeacherTestHelper()
            return self.instance!
        }
    }
    
}
extension TeacherQuestion{
    func toDict() -> Dictionary<String,AnyObject>{
        var answer:String!
        switch self.answer{
        case 0:
            answer = "A"
        case 1:
            answer = "B"
        case 2:
            answer = "C"
        case 3:
            answer = "D"
        default:
            answer = ""
        }
        let dict = ["course_id":self.courseId,"content":self.question , "answer":["\(answer!)"] , "choices":["A":self.choices["A"]!, "B":self.choices["B"]!,"C":self.choices["C"]!,"D":self.choices["D"]!], "chapter":self.chapter,"knowledge_point":self.knowledgePoint,"answer_detail":self.answerDetail,"difficulty":self.difficultyInt]
        return dict as! Dictionary<String, AnyObject>
    }
}