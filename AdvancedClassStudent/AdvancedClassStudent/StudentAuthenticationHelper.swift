//
//  LoginHelper.swift
//  AdvancedClassStudent
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
    var tempArgsOrBody: [String: AnyObject]!
    
    var originalHandler: ResponseHandler!
    var originalFileHandler: ResponseFileHandler!
    
    
    static var defaultHelper:StudentAuthenticationHelper{
        get{
            if _defaultHelper == nil{
                _defaultHelper = StudentAuthenticationHelper()
            }
            return _defaultHelper!
        }
    }
    
    
    
    
    func getResponsePOST(requestType:RequestType, parameters:[String: AnyObject], completionHandler: ResponseHandler){
        let request = getRequestPOST(requestType, parameters: parameters, GETParameters: ["token": self.token], headers: nil)
        request.responseJSON(){
            [unowned self]
            (_,_,result) in
            switch result{
            case .Success(let data):
                let json = JSON(data)
                let code = json["error_code"].intValue
                let msg = json["error_msg"].stringValue
                if code == CError.TOKEN_EXPIRED.rawValue{
                    self.tempPostBody=parameters
                    self.tempRequestType=requestType
                    self.originalHandler=completionHandler
                    self.getTokenBackground()
                    return
                }
                else if code > 0{
                    completionHandler(error: MyError(json: json), json: nil)
                }
                else{
                    completionHandler(error: nil, json: json)
                }
                
            case .Failure:
                completionHandler(error: MyError.NETWORK_ERROR, json: nil)
            }
            
        }
        
    }
    
    func getTokenBackground(){
        let request = getRequestPOST(.GET_TOKEN_ONLY, parameters: ["user_id": self.userId, "password": self.password, "role": ROLE_FOR_STUDENT], headers: nil)
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
                        self.originalHandler(error: MyError(json: json), json: nil)
                    }
                    else{
                        self.getTokenBackground()
                    }
                }
                else{
                    self.token = json["token"].stringValue
                    self.getResponsePOST(self.tempRequestType, parameters: self.tempPostBody, completionHandler: self.originalHandler)
                }
            case .Failure(_, _):
                self.originalHandler(error: MyError.NETWORK_ERROR, json: nil)
            }
        }
        
    }

    

    func login(userId:String,password:String,completionHandler: ResponseHandler){
        self.userId = userId
        self.password = password
        getResponsePOST(RequestType.LOGIN, parameters:["user_id":userId, "password": password, "role": 2]){
            [unowned self]
            (error,json) in            
            if error != nil{
                completionHandler(error: error, json: json)
            }
            else{
                self.token = json["token"].stringValue
                self.me = Me(json: json["user"])
                currentWeekNo = json["week_no"].intValue
                currentDayNo = json["day_no"].intValue
                StudentAuthenticationHelper.me = self.me
                completionHandler(error: nil, json: json)
            }
            
        }
    }
    
    func modifyPassword(oldPassword: String, newPassword: String, completionHandler: ResponseMessageHandler){
        self.getResponsePOST(RequestType.MODIFY_PASSWORD, parameters: ["new_pwd": newPassword, "old_pwd": oldPassword]){
            error, json in
            completionHandler(error: error)
        }
    }
    
    
    func getResponseGET(requestType: RequestType, parameters: [String: AnyObject]?, completionHandler: ResponseHandler){
        var args = parameters
        if args == nil{
            args = ["token": self.token]
        }
        else{
            args!["token"] = self.token
        }
        
        let request = getRequestGET(requestType, parameters: args, headers: nil)
        request.responseJSON(){
            [unowned self]
            (_,_,result) in
            switch result{
            case .Success(let data):
                let json = JSON(data)
                let code = json["error_code"].intValue
                if code == CError.TOKEN_EXPIRED.rawValue{
                    self.tempArgsOrBody=parameters
                    self.tempRequestType=requestType
                    self.originalHandler=completionHandler
                    self.getTokenBackground()
                    return
                }
                else if code > 0{
                    completionHandler(error: MyError(json: json), json: json)
                }
                else{
                    completionHandler(error: nil, json: json)
                }
                
            case .Failure:
                completionHandler(error: MyError.NETWORK_ERROR, json: nil)
            }
        }
    }
    
    func getResponsePOSTWithCourse(requestType:RequestType, parameters:[String: AnyObject], course: StudentCourse?=nil, completionHandler: ResponseHandler){
        var postBody = parameters
        var course = course
        if course == nil{
            course = StudentCourse.currentCourse
        }
        postBody["course_id"] = course!.courseId
        let request = getRequestPOST(requestType, parameters: postBody, GETParameters: ["token": self.token], headers: nil)
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
                    completionHandler(error: MyError(json: json), json: json)
                }
                else{
                    completionHandler(error: nil, json: json)
                }
                
            case .Failure:
                completionHandler(error: MyError.NETWORK_ERROR, json: nil)
            }
        }
        
    }
    
    
    func getResponseGetFile(requestType: RequestType, method: Alamofire.Method, parameters:[String: AnyObject]?, completionHandler: ResponseFileHandler){
        var argsOrBody = parameters
        if argsOrBody == nil && method == .GET{
            argsOrBody = ["token": self.token]
        }
        else if method == .GET{
            argsOrBody!["token"] = self.token
        }
        var request: Request
        if method == .GET{
            request = getRequestGET(requestType, parameters: argsOrBody, headers: nil)
        }
        else{
            request = getRequestPOST(requestType, parameters: argsOrBody ?? [:], GETParameters: ["token": self.token], headers: nil)
        }
        request.responseData(){
            [unowned self]
            (_,_,result) in
            switch result{
            case .Success(let data):
                let json = JSON(data)
                let code = json["error_code"].intValue
                if code == CError.TOKEN_EXPIRED.rawValue{
                    self.tempArgsOrBody=argsOrBody
                    self.tempRequestType=requestType
                    self.originalHandler = nil
                    self.originalFileHandler=completionHandler
                    self.getTokenBackground()
                    return
                }
                else if code > 0{
                    completionHandler(error: MyError(json: json), data: nil)
                }
                else{
                    completionHandler(error: nil, data: data)
                }
                
            case .Failure:
                completionHandler(error: MyError.NETWORK_ERROR, data: nil)
            }
        }
        
    }
    
    
    func postFile(requestType: RequestType, fileName: String, fileType: FileType, fileData: NSData, completionHandler: ResponseHandler){
        Alamofire.upload(.POST, BASE_URL+requestType.rawValue+"?token=\(self.token)",
                         headers: nil,
                         multipartFormData: {
                            multipartFormData in
                            
                            // import image to request
                            
                            //if let imageData = UIImageJPEGRepresentation(image, 0.5) {
                            multipartFormData.appendBodyPart(data: fileData, name: "file", fileName: fileName, mimeType: fileType.rawValue)
                            //}
                            
            },
                         encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .Success(let upload, _, _):
                                upload.responseJSON { _, _, result in
                                    switch result{
                                    case .Success(let data):
                                        let json = JSON(data)
                                        let code = json["error_code"].intValue
                                        if code == CError.TOKEN_EXPIRED.rawValue{
                                            self.getTokenBackground()
                                        }
                                        if code > 0{
                                            completionHandler(error: MyError(json: json), json: nil)
                                        }
                                        else{
                                            completionHandler(error: nil, json: json)
                                        }
                                        
                                    case .Failure:
                                        completionHandler(error: MyError.NETWORK_ERROR, json: nil)
                                    }
                                    
                                }
                            case .Failure(let encodingError):
                                print(encodingError)
                            }
        })
    }
    
    func getAvatar(force: Bool=false, completionHandler: ResponseMessageHandler){
        if self.me.avartar != nil && !force{
            completionHandler(error: nil)
        }
        self.getResponseGetFile(RequestType.GET_MY_AVATAR, method: .GET, parameters: [:]){
            [unowned self]
            error, data in
            if let error = error{
                completionHandler(error: error)
                return
            }
            guard let avartar = UIImage(data: data) else{
                completionHandler(error: error)
                return
            }
            self.me.avartar = avartar
            completionHandler(error: nil)
        }
    }

    
    
    private init(){
        
    }
    

    static func drop(){
       
        _defaultHelper = nil
        
    }
    
    
    
}