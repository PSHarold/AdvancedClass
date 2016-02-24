//
//  Me.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/2/20.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class Me: Student {
    var courses = [StudentCourse]()
    var courseDict = [String:StudentCourse]()
    var unreadNotifications = [Notification]()
    var untakenTests = [Notification]()
    
    override init(json: JSON) {
        super.init(json: json)
        for (_, course_json) in json["courses"]{
            let course = StudentCourse(json: course_json, preview: true)
            self.courses.append(course)
            self.courseDict[course.courseId] = course
        }
    }
}