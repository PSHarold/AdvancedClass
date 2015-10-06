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

class Notification {
    var title:String
    var content:String
    var top:Bool
    var time:String
    var timeData:NSDate!
    var id:String
    var etag:String
    var courseId:String!
    var subId:String!
    init(json:JSON){
        self.title = json["title"].stringValue
        self.content = json["content"].stringValue
        self.top = json["top"].boolValue
        self.id = json["_id"].stringValue
        self.etag = json["_etag"].stringValue
        self.time = json["time"].stringValue
        self.courseId = json["course_id"].stringValue
        self.subId = json["sub_id"].stringValue
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timeData = dateFormatter.dateFromString(self.time) as NSDate!
    }
    init(){
        self.title = ""
        self.content = ""
        self.top = false
        self.id = ""
        self.etag = ""
        self.time = ""
        self.timeData = nil
    }
}
extension Notification{
    func toDict() -> Dictionary<String,AnyObject>{
        return ["title":self.title,"top":self.top,"time":self.time,"content":self.content,"course_id":self.courseId,"sub_id":self.subId]
    }
}
class TeacherCourse {
    var studentIdList = [String]()
    var name:String!
    var courseId:String!
    var subId:String!
    var sortedNotifications = [Notification]()
    var unsortedNotifications = [Notification]()
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
    
    func sortNotifications(){
        var normalNotifications = [Notification]()
        var topNotifications = [Notification]()
        for notification in self.unsortedNotifications {
            if notification.top{
                topNotifications.append(notification)
            }
            else{
                normalNotifications.append(notification)
            }
        }
        let sortClosure = { (noti1:Notification,noti2:Notification) in noti1.timeData.compare(noti2.timeData) == NSComparisonResult.OrderedDescending }
        normalNotifications.sortInPlace(sortClosure)
        topNotifications.sortInPlace(sortClosure)
        for notification in topNotifications{
            self.sortedNotifications.append(notification)
        }
        for notification in normalNotifications{
            self.sortedNotifications.append(notification)
        }
        
    }
    
}