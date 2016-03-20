//
//  ErrorHandler.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/2/20.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON

enum CError: Int{
    case NETWORK_ERROR
    case NEED_TO_LOGIN_AGAIN
    
    case FORBIDDEN = 601
    case WRONG_PASSWORD = 602
    case ALREADY_LOGGED_IN = 603
    case BAD_TOKEN = 604
    case TOKEN_EXPIRED = 605
    case ONLY_ACCEPT_JSON = 606
    case FIELD_MISSING = 607
    case WRONG_FIELD_TYPE = 609
    case UNKNOWN_FIELD = 608
    case BASE64_ERROR = 620
    
    case RESOURCE_NOT_FOUND = 700
    case USER_NOT_FOUND = 701
    case MAIN_COURSE_NOT_FOUND = 702
    case SUB_COURSE_NOT_FOUND = 703
    case KNOWLEDGE_POINT_NOT_FOUND = 704
    case QUESTION_NOT_FOUND = 705
    case NOTIFICATION_NOT_FOUND = 706
    case SEAT_NOT_FOUND = 707
    case TEST_NOT_FOUND = 708
    case ROOM_NOT_FOUND = 709
    case SCHOOL_NOT_FOUND = 710
    case DEPARTMENT_NOT_FOUND = 711
    case MAJOR_NOT_FOUND = 712
    case CLASS_NOT_FOUND = 713
    
    case RESOURCE_ALREADY_EXISTS = 800
    case USER_ALREADY_EXISTS = 801
    case MAIN_COURSE_ALREADY_EXISTS = 802
    case SUB_COURSE_ALREADY_EXISTS = 803
    case KNOWLEDGE_POINT_ALREADY_EXISTS = 804
    case QUESTION_ALREADY_EXISTS = 805
    case NOTIFICATION_ALREADY_EXISTS = 806
    case SEAT_ALREADY_EXISTS = 807
    case TEST_ALREADY_EXISTS = 808
    case ROOM_ALREADY_EXISTS = 809
    
    case SEAT_ALREADY_TAKEN = 901
    case SEAT_ALREADY_CHOSEN = 902
    case SEAT_ALREADY_FREE_OR_TAKEN = 903
    case SEAT_TOKEN_EXPIRED = 904
    case BAD_SEAT_TOKEN = 905
    case SEAT_CHOOSING_NOT_AVAILABLE_YET = 906
    case COURSE_ALREADY_BEGUN = 907
    case COURSE_IS_NOT_ON_TODAY = 908
    case COURSE_ALREADY_OVER = 909
    case COURSE_NOT_BEGUN = 910
    case YOU_ARE_TOO_LATE = 911
    case RANDOM_TEST_NOT_SET = 920
    case YOU_DO_NOT_HAVE_THIS_COURSE = 921
}

func parseErrorString(error: CError) -> String{
    switch error{
    case .NETWORK_ERROR:
        return "网络错误！"
    case .NEED_TO_LOGIN_AGAIN:
        return ""
        
    case .FORBIDDEN:
        return "无权限！"
    case .WRONG_PASSWORD:
        return "密码错误！"
    case .ALREADY_LOGGED_IN:
        return "请不要重复登录！"
    case .BAD_TOKEN:
        return ""
    case .TOKEN_EXPIRED:
        return ""
    case .ONLY_ACCEPT_JSON:
        return ""
    case .FIELD_MISSING:
        return ""
    case .WRONG_FIELD_TYPE:
        return ""
    case .UNKNOWN_FIELD:
        return ""
    case .BASE64_ERROR:
        return ""
        
    case .RESOURCE_NOT_FOUND:
        return ""
    case .USER_NOT_FOUND:
        return "用户不存在！"
    case .MAIN_COURSE_NOT_FOUND:
        return "找不到此课程！"
    case .SUB_COURSE_NOT_FOUND:
        return "找不到此讲台！"
    case .KNOWLEDGE_POINT_NOT_FOUND:
        return "找不到此知识点！"
    case .QUESTION_NOT_FOUND:
        return "找不到此题目！"
    case .NOTIFICATION_NOT_FOUND:
        return "找不到此通知！"
    case .SEAT_NOT_FOUND:
        return "找不到此座位！"
    case .TEST_NOT_FOUND:
        return "找不到此测验！"
    case .ROOM_NOT_FOUND:
        return "找不到此教室！"
    case .SCHOOL_NOT_FOUND:
        return "找不到此学院！"
    case .DEPARTMENT_NOT_FOUND:
        return "找不到此系！"
    case .MAJOR_NOT_FOUND:
        return "找不到此专业！"
    case .CLASS_NOT_FOUND:
        return "找不到此班级！"
        
    case .RESOURCE_ALREADY_EXISTS:
        return ""
    case .USER_ALREADY_EXISTS:
        return "用户已存在！"
    case .MAIN_COURSE_ALREADY_EXISTS:
        return "课程已存在！"
    case .SUB_COURSE_ALREADY_EXISTS:
        return "讲台已存在！"
    case .KNOWLEDGE_POINT_ALREADY_EXISTS:
        return "知识点已存在！"
    case .QUESTION_ALREADY_EXISTS:
        return "题目已存在！"
    case .NOTIFICATION_ALREADY_EXISTS:
        return "通知已存在！"
    case .SEAT_ALREADY_EXISTS:
        return "座位已存在！"
    case .TEST_ALREADY_EXISTS:
        return "测验已存在！"
    case .ROOM_ALREADY_EXISTS:
        return ""
        
    case .SEAT_ALREADY_TAKEN:
        return "座位被抢走了！"
    case .SEAT_ALREADY_CHOSEN:
        return "你已经选了此座位！"
    case .SEAT_ALREADY_FREE_OR_TAKEN:
        return "座位已空！"
    case .SEAT_TOKEN_EXPIRED:
        return ""
    case .BAD_SEAT_TOKEN:
        return ""
    case .SEAT_CHOOSING_NOT_AVAILABLE_YET:
        return "选座还没有开始！"
    case .COURSE_ALREADY_BEGUN:
        return "已经上课了！"
    case .COURSE_IS_NOT_ON_TODAY:
        return "今天没有这门课！"
    case .COURSE_ALREADY_OVER:
        return "今天这节课已经结束了！"
    case .COURSE_NOT_BEGUN:
        return "这节课还没有开始！"
    case .YOU_ARE_TOO_LATE:
        return "你迟到太久！"
    case .RANDOM_TEST_NOT_SET:
        return ""
    case .YOU_DO_NOT_HAVE_THIS_COURSE:
        return "你没有权限查看这个课程！"
    }
    
}

func parseJSON(json:JSON) -> CError?{
    return CError(rawValue: json["error_code"].intValue)
}



