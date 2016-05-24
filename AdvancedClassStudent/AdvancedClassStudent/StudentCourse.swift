
//
//  StudentCourse.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class KnowledgePoint{
    var knowledgePointId: String!
    var content: String!
    var level: Int!
    var chapterNum: Int!
    var sectionNum: Int!
    init(json: JSON){
        self.knowledgePointId = json["point_id"].stringValue
        self.content = json["content"].stringValue
        self.level = json["level"].intValue
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
   
}

class StudentCourse {
    static var currentCourse: StudentCourse!
    
    var studentIdList = [String]()
    var name:String
    var courseId:String
    var subId:String
    var teachers = [Teacher]()
    var timesAndRooms:TimesAndRooms
    var unreadNotifications = [Notification]()
    var finishedTests = [StudentTest]()
    var unfinishedTests = [StudentTest]()
    var syllabus: Syllabus!
    var students = [String: Student]()
    var notifications = [Notification]()
    var notificationsAcquired = false
    var absenceList: [[String: Int]]!
    var asks = [AskForLeave]()
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
    
    

    
}