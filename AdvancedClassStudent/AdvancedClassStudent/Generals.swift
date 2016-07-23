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


var currentDayNo: Int = 0
var currentWeekNo: Int = 0


//let BASE_URL = TARGET_IPHONE_SIMULATOR == 0 ? "http://115.159.125.226/api" : "http://localhost:5000/api"
let BASE_URL = TARGET_IPHONE_SIMULATOR == 0 ? "http://192.168.2.1:5000/api" : "http://localhost:5000/api"

let ROLE_FOR_TEACHER = 1
let ROLE_FOR_STUDENT = 2


typealias ResponseHandler = (error: MyError?, json: JSON!) -> Void
typealias ResponseMessageHandler = (error: MyError?) -> Void
typealias ResponseFileHandler = (error: MyError?, data: NSData!) -> Void

enum RequestType: String{
    
    case REGISTER = "/user/register/student"
    case SCHOOLS_INFO = "/user/register/getSchools"
    case MAJORS_INFO = "/user/register/getMajors"
    case DEPARTMENTS_INFO = "/user/register/getDepartments"
    case LOGIN = "/user/login"
    case GET_TOKEN_ONLY = "/user/login/getToken"
    case GET_MY_AVATAR = "/user/my_avatar"
    
    case GET_NOTIFICAIONS = "/course/notification/getNotifications"
    case GET_SEAT_TOKEN = "/seat/getSeatToken"
    case GET_SEAT_MAP = "/seat/getSeatMap"
    case CHOOSE_SEAT = "/seat/chooseSeat"
    case FREE_SEAT = "/seat/freeSeat"
    case GET_SYLLABUS = "/course/syllabus/getSyllabus"
    case POST_TEST = "/course/test/postTest"
    case END_TEST = "/course/test/endTest"
    case GET_QUESTIONS_IN_POINT = "/course/question/getQuestionsInPoint"
    case GET_QUESTIONS_IN_TEST = "/course/test/getQuestionsInTest"
    case GET_UNFINISHED_TESTS = "/course/test/getUnfinishedTests"
    case GET_FINISHED_TESTS = "/course/test/getFinishedTests"
    case GET_QUESTIONS_IN_LIST = "/course/question/getQuestionsInList"
    case GET_TEST_RESULTS = "/course/test/result/getTestResults"
    case GET_STUDENTS_IN_COURES = "/course/getStudents"
    case GET_UNFINISHED_STUDENTS = "/course/test/result/getUnfinishedStudents"
    case GET_STUDENT = "/course/getStudentInfo"
    case POST_TEST_ANSWERS = "/course/test/postAnswers"
    case GET_STUDENT_TEST_RESULT = "/course/test/result/getStudentResult"
    case GET_QUESTIONS_FOR_RESULT = "/course/test/getQuestionsInTestForResult"
    
    
    case GET_FACES = "/user/get_faces"
    case GET_FACE_IMAGE = "/user/get_face_img"
    case ADD_FACE = "/user/add_face"
    case TEST_FACE = "/user/test_face"
    case DELETE_FACE = "/user/delete_face"
    case GET_ASKS_FOR_LEAVE = "/course/my_asks_for_leave"
    case ASK_FOR_LEAVE = "/course/ask_for_leave"
    case READ_NEW_STATUS_ASKS = "/course/read_new_status_ask"
    case DELETE_ASK_FOR_LEAVE = "/course/delete_ask_for_leave"
    case GET_MY_ABSENCE_LIST = "/course/get_my_absence_list"
    case CHECK_IF_CAN_CHECK_IN = "/course/check_if_can_check_in"
    case CHECK_IN = "/course/check_in"
    case VERIFY_QR_CODE = "/course/verify_qr_code"
    case MODIFY_PASSWORD = "/user/modify_password"
    case GET_EMAIL = "/user/get_email"
    case MODIFY_EMAIL = "/user/modify_email"
    case RESET_PASSWORD_GET_EMAIL = "/user/reset_password_get_email"
    case RESET_PASSWORD_CONFIRM_EMAIL = "/user/reset_password"
    case GET_COVER = "/course/get_cover"
}
enum FileType: String{
    case JPG = "image/jpeg"
    case PNG = "image/png"
}

func getRequestGET(requestType:RequestType, parameters:[String: AnyObject]?, headers:[String:String]?) -> Request{
    return alamofireManager.request(.GET, BASE_URL + requestType.rawValue, parameters: parameters, encoding: .URL, headers: headers)
}
func getRequestPOST(requestType:RequestType, parameters: [String: AnyObject], GETParameters: [String: AnyObject]?=nil, headers:[String:String]?) -> Request{
    var s = ""
    if let params = GETParameters{
        s = "?"
        var count = 1
        for (key, value) in params{
            s += "\(key)=\(value)"
            if count < params.count{
                s += "&"
            }
            count += 1
        }
    }
    return alamofireManager.request(.POST, BASE_URL + requestType.rawValue + s, parameters: parameters, encoding: .JSON, headers: headers)
}

let hud = MBProgressHUD()
extension UIViewController{
    func showHudWithText(text:String, mode:MBProgressHUDMode = .Indeterminate,hideAfter:NSTimeInterval=1.0){
        hud.removeFromSuperViewOnHide = true
        hud.labelText = text
        hud.mode = mode
        
        if let _ = self as? UITableViewController{
            if !self.parentViewController!.view.subviews.contains(hud){
                self.parentViewController!.view.addSubview(hud)
            }
        }
        else{
            if !self.view.subviews.contains(hud){
                self.view.addSubview(hud)
            }
        }
        
        if mode == .Indeterminate{
            hud.show(true)
        }
        else{
            hud.show(true)
            hud.hide(true, afterDelay: hideAfter)
        }
    }
    
    func showError(error: MyError, hideAfter: NSTimeInterval=1.0){
        self.showHudWithText(error.description, mode: .Text, hideAfter: hideAfter)
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

extension Array {
    subscript (safe index: UInt) -> Element? {
        return Int(index) < count ? self[Int(index)] : nil
    }
}

extension UIImage{
    func fixOrientation() -> UIImage {
        
        // No-op if the orientation is already correct
        if ( self.imageOrientation == UIImageOrientation.Up ) {
            return self;
        }
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform: CGAffineTransform = CGAffineTransformIdentity
        
        if ( self.imageOrientation == UIImageOrientation.Down || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Left || self.imageOrientation == UIImageOrientation.LeftMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
        }
        
        if ( self.imageOrientation == UIImageOrientation.Right || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform,  CGFloat(-M_PI_2));
        }
        
        if ( self.imageOrientation == UIImageOrientation.UpMirrored || self.imageOrientation == UIImageOrientation.DownMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
        }
        
        if ( self.imageOrientation == UIImageOrientation.LeftMirrored || self.imageOrientation == UIImageOrientation.RightMirrored ) {
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx: CGContextRef = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
                                                      CGImageGetBitsPerComponent(self.CGImage), 0,
                                                      CGImageGetColorSpace(self.CGImage),
                                                      CGImageGetBitmapInfo(self.CGImage).rawValue)!;
        
        CGContextConcatCTM(ctx, transform)
        
        if ( self.imageOrientation == UIImageOrientation.Left ||
            self.imageOrientation == UIImageOrientation.LeftMirrored ||
            self.imageOrientation == UIImageOrientation.Right ||
            self.imageOrientation == UIImageOrientation.RightMirrored ) {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage)
        } else {
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage)
        }
        let a = StudentSeatHelper.defaultHelper
        
        // And now we just create a new UIImage from the drawing context and return it
        return UIImage(CGImage: CGBitmapContextCreateImage(ctx)!)
    }
}

