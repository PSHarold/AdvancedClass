//
//  TeacherInfo.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class Me: Student {
    var courses = [TeacherCourse]()
    var courseDict = [String:TeacherCourse]()
    
    
    override init(json: JSON) {
        super.init(json: json)
        for (_, course_json) in json["courses"]{
            let course = TeacherCourse(json: course_json, preview: true)
            self.courses.append(course)
            self.courseDict[course.courseId] = course
        }
    }
}