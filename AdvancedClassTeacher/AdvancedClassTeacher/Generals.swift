//
//  Globals.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/2/20.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
import UIKit
var alamofireManager: Alamofire.Manager!
let BASE_URL = TARGET_IPHONE_SIMULATOR == 0 ? "http://192.168.2.1:5000" : "http://localhost:5000"
//let BASE_URL = "http://localhost:5000"
let ROLE_FOR_TEACHER = 1



typealias ResponseHandler = (error: CError?, json: JSON!) -> Void
typealias ResponseMessageHandler = (error: CError?) -> Void
enum RequestType: String{
    
    case REGISTER = "/user/register/student"
    case SCHOOLS_INFO = "/user/register/getSchools"
    case MAJORS_INFO = "/user/register/getMajors"
    case DEPARTMENTS_INFO = "/user/register/getDepartments"
    case LOGIN = "/user/login"
    case GET_TOKEN_ONLY = "/user/login/getToken"
    case GET_NOTIFICAIONS = "/course/notification/getNotifications"
    case GET_SEAT_TOKEN = "/seat/getSeatToken"
    case GET_SEAT_MAP = "/seat/getSeatMap"
    case CHOOSE_SEAT = "/seat/chooseSeat"
    case FREE_SEAT = "/seat/freeSeat"
    case GET_SYLLABUS = "/course/syllabus/getSyllabus"
    case POST_TEST = "/course/test/postTest"
    case GET_QUESTIONS_IN_POINT = "/course/question/getQuestionsInPoint"
    case GET_UNFINISHED_TESTS = "/course/test/getUnfinishedTests"
    case GET_QUESTIONS_IN_LIST = "/course/question/getQuestionsInList"
    case GET_TEST_RESULTS = "/course/test/result/getTestResults"
    case GET_STUDENTS_IN_COURES = "/course/getStudentIds"
    case GET_UNTAKEN_STUDENTS = "/course/test/result/getUntakenStudents"
}
func getRequestFor(requestType:RequestType, method:Alamofire.Method, postBody:[String: AnyObject]?, headers:[String:String]?) -> Request{
    return alamofireManager.request(method, BASE_URL + requestType.rawValue, parameters: postBody, encoding: .JSON, headers: headers)
}


let hud = MBProgressHUD()
extension UIViewController{
    func showHudWithText(text:String, mode:MBProgressHUDMode = .Text,hideAfter:NSTimeInterval=1.0){
        hud.removeFromSuperViewOnHide = true
        hud.labelText = text
        hud.mode = mode
        if !self.view.subviews.contains(hud){
            self.view.addSubview(hud)
        }
        if mode == .Indeterminate{
            hud.show(true)
        }
        else{
            hud.show(true)
            hud.hide(true, afterDelay: hideAfter)
        }
    }
    
    func showError(error: CError, hideAfter: NSTimeInterval=1.0){
        self.showHudWithText(error.description, hideAfter: hideAfter)
    }
    
    func hideHud(){
        hud.hide(true)
    }
    
}

extension Int{
    func toTimeString(showFull: Bool = false) -> String{
        if self < 0{
            return ""
        }
        let hours = self / 3600
        let minutes = (self - hours * 3600) / 60
        let seconds = self % 60
        if showFull{
            return "\(hours)小时\(minutes)分钟\(seconds)秒"
        }
        let hs = hours != 0 ? "\(hours)小时" : ""
        let ms = minutes != 0 ? "\(minutes)分钟" : ""
        return hs + ms + "\(seconds)秒"
    }
    
    func toTimeComponents() -> (Int, Int, Int){
        if self <= 0{
            return (0, 0, 0)
        }
        let hours = self / 3600
        let minutes = (self - hours * 3600) / 60
        let seconds = self % 60
        return (hours, minutes, seconds)
    }
}

extension String{
    func toNSDate() -> NSDate? {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.dateFromString(self)
    }
    
}

extension NSDate{
    func toString() -> String{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.stringFromDate(self)
    }
    
}

extension Double {
    func toPercentageString() -> String{
        let formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        // you can set the minimum fraction digits to 0
        formatter.minimumFractionDigits = 0
        // and set the maximum fraction digits to 1
        formatter.maximumFractionDigits = 2
        return "\(formatter.stringFromNumber(self*100) ?? "0")%"
    }
}

