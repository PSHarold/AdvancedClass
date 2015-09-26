
//
//  StudentCourse.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class StudentCourse {
    var studentIdList = [String]()
    var name:String!
    var courseId:String!
    var subId:String!
    var teacher:TeacherInfo!
    
    init(json:JSON){
        self.name = json["name"].stringValue
        self.courseId = json["course_id"].stringValue
        self.subId = json["sub_id"].stringValue
        for (_,id) in json["students"]{
            self.studentIdList.append(id.stringValue)
        }
    }

}