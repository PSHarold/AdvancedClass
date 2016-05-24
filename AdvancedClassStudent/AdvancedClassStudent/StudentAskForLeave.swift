//
//  StudentAskForLeave.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/5/24.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON

enum AskForLeaveStatus: Int {
    case PENDING = 0
    case APPROVED = 1
    case DISAPPROVED = 2
}

class AskForLeave{
    
    var courseId: String!
    var askId: String!
    var reason: String!
    var statusInt: Int!
    var status: AskForLeaveStatus!
    var weekNo: Int!
    var dayNo: Int!
    var periodNo: Int!
    var createdAt: String!
    var viewdAt: String!
    init(json: JSON){
        self.courseId = json["course_id"].stringValue
        self.askId = json["ask_id"].stringValue
        self.reason = json["reason"].stringValue
        self.statusInt = json["status"].intValue
        self.status = AskForLeaveStatus(rawValue: self.statusInt)
        self.dayNo = json["day_no"].intValue
        self.periodNo = json["period_no"].intValue
        self.weekNo = json["week_no"].intValue
        self.createdAt = json["created_at"].stringValue
        self.viewdAt = json["viewed_at"].stringValue
    }
    init(){
        
    }
    
    func toDict() -> [String: AnyObject]{
        return ["reason": self.reason, "week_no": self.weekNo, "day_no": self.dayNo, "period_no": self.periodNo]
    }
}
