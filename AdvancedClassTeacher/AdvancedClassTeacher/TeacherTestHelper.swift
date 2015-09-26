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
    optional func knowledgePointsAcquired()
    optional func testResultAcquired()
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
    var expiredTestArray = [TeacherTest]()
    var unexpiredTestArray = [TeacherTest]()
    var _newTest:TeacherTest?
    var authHelper = TeacherAuthenticationHelper.defaultHelper()
    var teacherDelegate:TeacherTestHelperDelegate!
    var knowledgePoints:Chapters!
    static var instance:TeacherTestHelper?
    var allQuestionArray = [Question]()
    var allQuestionDict = Dictionary<String,Question>()
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
        self.expiredTestArray.removeAll(keepCapacity: false)
        self.unexpiredTestArray.removeAll(keepCapacity: false)
        self.doneAcquiring = false
        let request = self.authHelper.requestForTestsWithCourseId(courseHelper.currentCourse.courseId, subId: courseHelper.currentCourse.subId)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                let listJSON = JSON(data)["_items"]
                for (_,test) in listJSON{
                    self.processTest(TeacherTest(json:test))
                }
                self.sortTests()
                self.delegate.allTestsAcquired!()
            case .Failure:
                self.delegate.networkError()
            }
            
            
        }
        
        return 0
    }
    
    func processTest(test:TeacherTest){
        self.addTest(test)
    }
    
    //获取测试后加入到测试列表（分类）
    func addTest(test:TeacherTest){
        if test.expired{
            self.expiredTestArray.append(test)
        }
        else{
            self.unexpiredTestArray.append(test)
        }
    }
    
    //正在进行的测试放在前面
    func sortTests(){
        for temp in self.unexpiredTestArray{
            self.allTestArray.append(temp)
        }
        for temp in self.expiredTestArray{
            self.allTestArray.append(temp)
        }
        
    }
    
    
    func getQuestionWithId(id:String,test:TeacherTest){
        let request = self.authHelper.requestForQuestionWithId(id)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                if data.valueForKey("_error") == nil{
                    test.addAcquiredQuestion(Question(json: JSON(data)))
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
        let ids = test.getQuestionIds()
        for id in ids{
            self.getQuestionWithId(id,test: test)
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
    
    //获取所有问题
    func updateAllQuestions() -> Int{
        //未完成则返回，防止重复获取
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
                self.processQuestionList(JSON(data))
            case .Failure:
                self.delegate.networkError()
            }
        }
        return 0
    }
    
    
    func processQuestionList(list:JSON){
        let questionList = list["_items"]
        if questionList == JSON.null {
            self.delegate.networkError()
            return
        }
        //if questionList.count == 0 {
        //   self.gotResult(.noQuestionsOrTest)
        //   return
        //}
        
        for (_,questionJSON) in questionList{
            self.questionAcquired(Question(json: questionJSON))
        }
        self.getKnowledgePoints(self.courseHelper.currentCourse.courseId)
        self.delegate.allQuestionsAcquired!()
    }
    
    
    func questionAcquired(question:Question){
        self.allQuestionArray.append(question)
        self.allQuestionDict[question.id] = question
        ++self.currentQuestionNumber
    }
    
    
    
    func uploadQuestion(question:Question) -> Int{
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
        
        let dict = ["question_list":self.newTest.getQuestionIds(), "has_hint":self.newTest.hasHint,"random_num":self.newTest.randomNumber,"course_id":self.courseHelper.currentCourse.courseId,"expired":false,"start_time":self.dateTimeHelper.currentTime,"time_limit":self.newTest.timeLimitInt,"info":"","message":"","sub_id":self.courseHelper.currentCourse.subId]
        
        let request = self.authHelper.requestForTestUploading(dict as! Dictionary<String, AnyObject>)
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success:
                self.delegate.testUploaded!()
                 self.newTest = nil
            case .Failure(_, let error):
                print("Request failed with error: \(error)")
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
    
    func deleteQuestion(question:Question,indexPath:NSIndexPath) -> Int{
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
    
    func modifyQuestion(question:Question) -> Int{
        let request = self.authHelper.requestForQuestionModificationWithQuestionId(question.id, etag: question.etag, patchDict: question.toDict())
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success:
                self.delegate.questionUploaded!()
            case .Failure(_, let error):
               print(error)
            }
        }
        return 0
    }
    
    
    func getKnowledgePoints(courseId:String){
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

            case .Failure(_, let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getTestResults(testId:String){
        
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
extension Question{
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