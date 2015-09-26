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

class TeacherCourse {
    var studentIdList = [String]()
    var name:String!
    var courseId:String!
    var subId:String!
    var numberOfStudents:Int{
        get{
            return self.studentIdList.count
        }
    }
    

    init(json:JSON){
        self.name = json["name"].stringValue
        self.courseId = json["course_id"].stringValue
        self.subId = json["sub_id"].stringValue
        for (_,id) in json["students"]{
            self.studentIdList.append(id.stringValue)
        }
    }
    
    
}