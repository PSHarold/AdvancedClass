
//
//  TeacherInfo.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class Teacher {
    var name:String!
    var teacherId:String!
    var title:String!
    var description:String!
    var office:String!
    var complete = false
    init(json:JSON){
        self.name = json["name"].stringValue
        self.teacherId = json["teacher_id"].stringValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
    }
    
    func completeInfo(json: JSON){
        if self.complete{
            return
        }
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.office = json["office"].stringValue
        self.complete = true
    }
    
}