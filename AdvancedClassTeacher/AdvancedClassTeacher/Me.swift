//
//  TeacherInfo.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON

class Teacher{
    var name: String!
    var gender: Bool!
    var userId: String
    var genderString:String{
        get{
            if !self.gender{
                return "男"
            }
            return "女"
        }
    }
    
    init(json: JSON){
        self.gender = json["gender"].boolValue
        self.name = json["name"].stringValue
        self.userId = json["user_id"].stringValue
    }
    
}

class Me: Teacher {
    var courses = [TeacherCourse]()
    var courseDict = [String:TeacherCourse]()
    var pendingAsks = [AskForLeave]()
    var pendingCount: Int{
        get{
            var count = 0
            for ask in self.pendingAsks{
                if ask.status == .PENDING{
                    count += 1
                }
            }
            return count
        }
    }
    
    override init(json: JSON) {
        super.init(json: json)
        for (_, course_json) in json["courses"]{
            let course = TeacherCourse(json: course_json, preview: true)
            self.courses.append(course)
            self.courseDict[course.courseId] = course
        }
        for askDict in json["pending_asks"].arrayValue{
            self.pendingAsks.append(AskForLeave(json: askDict))
        }
        
        self.courses.sortInPlace({$0.timesAndRooms.getTodaysPeriods() != nil && $1.timesAndRooms.getTodaysPeriods() == nil})

    }
}