//
//  MyInformation.swift
//  AdvancedClassStudent
//
//  Created by Harold on 15/9/6.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class Student {
    var courses = [Dictionary<String,String>]()
    var studentId = ""
    var finishedTestIdArray:[String]!
    var name = ""
    var classNo = ""
    var currentSeatId = ""
    var currentCourseId = "00000000"
    var id:String!
    var etag:String!
    init(json:JSON,isMe:Bool = false){
        if isMe{
            self.finishedTestIdArray = [String]()
            for (_,testId) in json["finished_tests"]{
                self.finishedTestIdArray.append(testId.stringValue)
            }
            self.studentId = json["student_id"].stringValue
            self.name = json["name"].stringValue
            self.classNo = json["class"].stringValue
            self.currentSeatId = json["cur_seat_id"].stringValue
            self.id = json["_id"].stringValue
            self.etag = json["_etag"].stringValue
            for (_,course) in json["courses"]{
                self.courses.append(["courseId":course["course_id"].stringValue,"subId":course["sub_id"].stringValue])
            }
        }
    }
}