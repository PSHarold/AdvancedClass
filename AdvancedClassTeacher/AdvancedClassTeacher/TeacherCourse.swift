//
//  Course.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/7.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

enum AskForLeaveStatus: Int {
    case PENDING = 0
    case APPROVED = 1
    case DISAPPROVED = 2
}

class AskForLeave{
    var studentId: String!
    var courseId: String!
    var askId: String!
    var reason: String!
    var statusInt: Int!
    var status: AskForLeaveStatus!
    var weekNo: Int!
    var dayNo: Int!
    var periodNo: Int!
    var createdAt: String!
    var viewdAt: String!
    init(json: JSON){
        self.studentId = json["student_id"].stringValue
        self.courseId = json["course_id"].stringValue
        self.askId = json["ask_id"].stringValue
        self.reason = json["reason"].stringValue
        self.statusInt = json["status"].intValue
        self.status = AskForLeaveStatus(rawValue: self.statusInt)
        self.dayNo = json["day_no"].intValue
        self.periodNo = json["period_no"].intValue
        self.weekNo = json["week_no"].intValue
        self.createdAt = json["created_at"].stringValue
        self.viewdAt = json["viewed_at"].stringValue
    }
    
}


class KnowledgePoint{
    var knowledgePointId: String!
    var content: String!
    var level: Int!
    var questions = [TeacherQuestion]()
    var questionsAcquired = false
    var chapterNum: Int!
    var sectionNum: Int!
    var questionNum: Int!
    init(json: JSON){
        self.knowledgePointId = json["point_id"].stringValue
        self.content = json["content"].stringValue
        self.level = json["level"].intValue
        self.questionNum = json["question_num"].intValue
    }
    
    func getQuestions(completionHandler: ResponseHandler){
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        authHelper.getResponsePOST(.GET_QUESTIONS_IN_POINT, parameters: ["course_id": TeacherCourse.currentCourse.courseId, "point_id": self.knowledgePointId]){
            [unowned self]
            (error, json) in
            if error == nil{
                self.questions = []
                
                for (_, json) in json["questions"]{
                    let q = TeacherQuestion.createPreview(json)
                    q.knowledgePointId = self.knowledgePointId
                    self.questions.append(q)
                    
                }
                self.questionsAcquired = true
                completionHandler(error: nil, json: nil)
            }
            else{
                completionHandler(error: error, json: nil)
                self.questionsAcquired = false
            }
        }
    }
    
}

class Section{
    var sectionName: String!
    var chapterNum: Int!
    var sectionNum: Int!
    var plannedHours: Int!
    var knowledgePoints = [KnowledgePoint]()
    var knowledgePointsDict = [String: KnowledgePoint]()
    init(json: JSON){
        self.sectionName = json["section_name"].stringValue
        self.chapterNum = json["chapter_num"].intValue
        self.sectionNum = json["section_num"].intValue
        for (_, point_dict) in json["points"]{
            self.addKnowledgePoint(KnowledgePoint(json: point_dict))
            
        }
    }
    
    func addKnowledgePoint(point: KnowledgePoint){
        self.knowledgePoints.append(point)
        self.knowledgePointsDict[point.knowledgePointId] = point
    }
}

class Chapter{
    var chapterNum: Int!
    var chapterName: String!
    var sections = [Section]()
    var sectionsDict = [Int: Section]()
    init(json: JSON){
        self.chapterName = json["chapter_name"].stringValue
        self.chapterNum = json["chapter_num"].intValue
        for (_, section_dict) in json["sections"]{
            self.addSection(Section(json: section_dict))
        }
    }
    
    func addSection(section: Section){
        self.sections.append(section)
        self.sectionsDict[section.sectionNum] = section
    }


}

class Syllabus{
    var chapters = [Chapter]()
    var chaptersDict = [Int: Chapter]()
    var knowledgePoints = [String: KnowledgePoint]()
    func getChapterWithChapterNum(chapterNum: Int) -> Chapter?{
        return self.chaptersDict[chapterNum]
    }
    func getSectionWithChapterNum(chapterNum: Int, sectionNum: Int) -> Section?{
        return self.chaptersDict[chapterNum]?.sectionsDict[sectionNum]
    }
    init(json: JSON){
        for (_, chapter_dict) in json["chapters"]{
            self.addChapter(Chapter(json: chapter_dict))
        }
       // self.chapters.sortInPlace({$0.chapterNum < $1.chapterNum})
    }
    
    func addChapter(chapter: Chapter){
        self.chapters.append(chapter)
        self.chaptersDict[chapter.chapterNum] = chapter
        for section in chapter.sections{
            for point in section.knowledgePoints{
                self.knowledgePoints[point.knowledgePointId] = point
            }
        }
    }
    
}


class Notification {
    var title:String!
    var content:String!
    var onTop: Bool!
    var createdOn:String!
    var createdOnTimeData:NSDate!
    var notificationId:String!
    var courseName = ""
    init(json:JSON){
        self.title = json["title"].stringValue
        self.content = json["content"].stringValue
        self.onTop = json["on_top"].boolValue
        self.notificationId = json["ntfc_id"].stringValue
        self.createdOn = json["created_on"].stringValue
        
    }
    
    init(){}
    
    func toDict() -> Dictionary<String,AnyObject>{
        var a = ["title": self.title, "on_top": self.onTop, "content":self.content] as! Dictionary<String, AnyObject>
        if let id = self.notificationId{
            a["ntfc_id"] = id
        }
        return a
    }
}

class TeacherCourse {
    static var currentCourse: TeacherCourse!
    var studentDict = [String: Student]()
    var studentIdList = [String]()
    var classNames = [String]()
    var name:String
    var courseId:String
    var mainCourseId: String
    var subCourseId: String
    var teachers = [String]()
    var timesAndRooms: TimesAndRooms
    var unfinishedTests = [TeacherTest]()
    var testsDict = [String: TeacherTest]()
    var finishedTests = [TeacherTest]()
    var coverImage: UIImage?
    var studentIds = [String]()
    var notifications = [Notification]()
    var syllabus: Syllabus!
    var asks = [AskForLeave]()
    var absenceList: [(String, Int)]!
    var absenceListSorted: [(String, Int)]!
    
    init(json:JSON, preview:Bool = true){
        self.name = json["course_name"].stringValue
        self.courseId = json["course_id"].stringValue
        let a = self.courseId.characters.split("_")
        self.mainCourseId = String(a[0])
        self.subCourseId = String(a[1])
        self.timesAndRooms = TimesAndRooms(json: json["times"])
        for className in json["classes"].arrayValue{
            self.classNames.append(className.stringValue)
        }
    }
    
    
    
    
}