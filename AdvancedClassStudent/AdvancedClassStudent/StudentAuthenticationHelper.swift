//
//  LoginHelper.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/2.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class StudentAuthenticationHelper{
    
    
    
    static var _defaultHelper:StudentAuthenticationHelper?
    static weak var me: Me!
    var tokenRetryCount = 0
    let MAX_TOKEN_RETRY_COUNT = 3
    var me: Me!
    var userId = ""
    var password = ""
    var token = ""
    var tempRequestType:RequestType!
    var tempMethod:Alamofire.Method!
    var tempPostBody:[String: AnyObject]!
    var tempHeaders:[String:String]!
    var originalHandler:((error:CError?, json:JSON!) -> Void)!
    
    static var defaultHelper:StudentAuthenticationHelper{
        get{
            if _defaultHelper == nil{
                _defaultHelper = StudentAuthenticationHelper()
            }
            return _defaultHelper!
        }
    }
    
    
    
  
    
    
    
    func getResponsePOST(requestType:RequestType, postBody:[String: AnyObject], subIdRequired: Bool = false, completionHandler: ResponseHandler){
        var postBody = postBody
        postBody["token"] = self.token
        if subIdRequired{
            let course = StudentCourse.currentCourse
            postBody["course_id"] = course.courseId
            postBody["sub_id"] = course.subId
        }
        let request = getRequestFor(requestType, method: .POST, postBody: postBody, headers: nil)
        request.responseJSON(){
            [unowned self]
            (_,_,result) in
            switch result{
            case .Success(let data):
                let json = JSON(data)
                let code = json["error_code"].intValue
                if code == CError.TOKEN_EXPIRED.rawValue{
                    self.tempPostBody=postBody
                    self.tempRequestType=requestType
                    self.originalHandler=completionHandler
                    self.getTokenBackground()
                    return
                }
                else if code > 0{
                    completionHandler(error: CError(rawValue: code), json: json)
                }
                else{
                    completionHandler(error: nil, json: json)
                }
                
            case .Failure:
                completionHandler(error: CError.NETWORK_ERROR, json: nil)
            }
        }
        
    }
    
    func getTokenBackground(){
        let request = getRequestFor(.GET_TOKEN_ONLY, method: .POST, postBody: ["user_id": self.userId, "password": self.password, "role": ROLE_FOR_STUDENT], headers: nil)
        request.responseJSON(){
            [unowned self]
            _,_,result in
            switch result{
            case .Success(let data):
                let json = JSON(data)
                let code = json["error_code"].intValue
                if code > 0{
                    if self.tokenRetryCount == self.MAX_TOKEN_RETRY_COUNT{
                        self.tokenRetryCount = 0
                        self.originalHandler(error: CError(rawValue: code), json: nil)
                    }
                    else{
                        self.getTokenBackground()
                    }
                }
                else{
                    self.token = json["token"].stringValue
                    self.getResponsePOST(self.tempRequestType, postBody: self.tempPostBody, completionHandler: self.originalHandler)
                }
            case .Failure(_, _):
                self.originalHandler(error: CError.NETWORK_ERROR, json: nil)
            }
        }
        
    }

    

    func login(userId:String,password:String,completionHandler: (error: CError?, json: JSON?) -> Void){
        self.userId = userId
        self.password = password
        getResponsePOST(RequestType.LOGIN, postBody:["user_id":userId, "password": password, "role": 2]){
            [unowned self]
            (error,json) in            
            if error != nil{
                completionHandler(error: error, json: json)
            }
            else{
                self.token = json["token"].stringValue
                self.me = Me(json: json["user"])
                StudentAuthenticationHelper.me = self.me
                completionHandler(error: nil, json: json)
            }
            
        }
    }
    
    private init(){
        
    }
    

    
    
    func logout(){
        
    }
    
}