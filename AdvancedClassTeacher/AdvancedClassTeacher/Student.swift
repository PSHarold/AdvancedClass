//
//  StudentInfo.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class Student {
    var studentId:String!
    var classNo:String!
    var name:String!
    var photo:AnyObject!
    init(json:JSON){
        self.studentId = json["student_id"].stringValue
        self.classNo = json["class"].stringValue
        self.name = json["name"].stringValue
    }
}