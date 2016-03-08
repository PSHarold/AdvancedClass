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
        if self.questionsAcquired{
            completionHandler(error: nil, json: nil)
            return
        }
        let authHelper = TeacherAuthenticationHelper.defaultHelper
        authHelper.getResponse(.GET_QUESTIONS_IN_POINT, method: .POST, postBody: ["course_id": TeacherCourse.currentCourse.courseId, "sub_id": TeacherCourse.currentCourse.subId, "point_id": self.knowledgePointId], headers: nil, tokenRequired: true){
            [unowned self]
            (error, json) in
            if error == nil{
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
    }
    
}


class Notification {
    var title:String!
    var content:String!
    var top:Bool!
    var createdOn:String!
    var createdOnTimeData:NSDate!
    var notificationId:String!
    var courseName = ""
    init(json:JSON){
        self.title = json["title"].stringValue
        self.content = json["content"].stringValue
        self.top = json["top"].boolValue
        self.notificationId = json["ntfc_id"].stringValue
        self.createdOn = json["created_on"].stringValue
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.createdOnTimeData = dateFormatter.dateFromString(self.createdOn) as NSDate!
    }
    
    func toDict() -> Dictionary<String,AnyObject>{
        return ["title":self.title,"top":self.top,"created_on":self.createdOn,"content":self.content]
    }
}

class TeacherCourse {
    static var currentCourse: TeacherCourse!
    
    var studentIdList = [String]()
    var name:String
    var courseId:String
    var subId:String
    var teachers = [String]()
    var timesAndRooms: TimesAndRooms
    var unreadNotifications = [Notification]()
    var untakenTests = []
    var students = [Student]()
    var notifications = [Notification]()
    var notificationsAcquired = false
    var syllabus: Syllabus!
    init(json:JSON, preview:Bool = true){
        self.name = json["course_name"].stringValue
        self.courseId = json["course_id"].stringValue
        self.subId = json["sub_id"].stringValue
        self.timesAndRooms = TimesAndRooms(json: json["times"])
        for (_, n) in json["unread_ntfcs"]{
            let notification = Notification(json: n)
            notification.courseName = self.name
            self.unreadNotifications.append(notification)
        }
    }
    
    func getNotifications(completionHandler: (error: CError?) -> Void){
        if self.notificationsAcquired{
            completionHandler(error: nil)
            return
        }
        else{
            TeacherAuthenticationHelper.defaultHelper.getResponse(RequestType.GET_NOTIFICAIONS, postBody: ["course_id":self.courseId,"sub_id":self.subId]){
                (error, json) in
                if error == nil{
                    for (_, n) in json["notifications"]{
                        let notification = Notification(json: n)
                        notification.courseName = self.name
                        self.notifications.append(notification)
                    }
                    self.notificationsAcquired = true
                }
                completionHandler(error: error)
                return
            }
        }
    }
    
    func getSyllabus(completionHandler: (error: CError?) -> Void){
        if self.syllabus != nil{
            completionHandler(error: nil)
            return
        }
        else{
            TeacherAuthenticationHelper.defaultHelper.getResponse(RequestType.GET_SYLLABUS, method: .POST, postBody: ["course_id": self.courseId, "sub_id": self.subId]){
                (error, json) in
                if error == nil{
                    self.syllabus = Syllabus(json: json)
                }
                completionHandler(error: error)
            }
        }
    }
    
    
    func refreshNotifications(){
        
    }
    
    func completeInfo(json:JSON){
        
    }
    
    
}