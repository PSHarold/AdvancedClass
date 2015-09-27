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
@objc protocol StudentAuthenticationHelperDelegate{
    optional func myInformationUpdated()
    optional func loggedIn()
    optional func needLoggingIn()
    func networkError()
}


class StudentAuthenticationHelper{
    
    
    
    static var instance:StudentAuthenticationHelper?
    var myInfo:Student!
    var alamofireManager : Alamofire.Manager!
   // var request:Request
    //var courseHelper = StudentCourseHelper.defaultHelper()
    var delegate:StudentAuthenticationHelperDelegate!

    let baseRootUrl:String = TARGET_IPHONE_SIMULATOR == 0 ? "http://192.168.2.1:5000/" : "http://localhost:5000/"
    
    let urlDict = ["knowledgePoints":"knowledge_points","questions":"questions","tests":"tests","results":"results","courses":"courses","students":"students","rooms":"rooms","seats":"seats"]
    
    
    
    func requestForSeatWithId(id:String) ->Request {
        
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["seats"]! + "/\(id)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForRoomWithId(id:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["rooms"]! + "/\(id)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForSeatsWithRoomId(id:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["rooms"]! + "/\(id)/seats", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForCourseWithCourseId(id:String,subId:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["courses"]! + "/\(id)/\(subId)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForQuestionWithId(id:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["questions"]! + "/\(id)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForMyInfoWithUser(user:String,pass:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["students"]! + "/\(user)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForTestsWithCourseId(id:String,subId:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["courses"]! + "/" + id + "/" + subId + "/" + self.urlDict["tests"]!, parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    
    func requestForResultsUpload(result:Dictionary<String,AnyObject>) ->Request {
        return self.alamofireManager.request(.POST, self.baseRootUrl + self.urlDict["results"]!, parameters: result, encoding: .JSON, headers: nil)
        
    }
    
    func requestForStudentWithId(id:String) -> Request{
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["students"]! + "/\(id)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForTestResultsWithTestId(id:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["results"]!, parameters: ["where":["student_id":self.myInfo.studentId],"test_id":id], encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForSeatSelectionWithSeatId(id:String,etag:String,patchDict:Dictionary<String,AnyObject>) -> Request{
        return self.alamofireManager.request(.PATCH, self.baseRootUrl + self.urlDict["seats"]! + "/\(id)", parameters: patchDict, encoding: .JSON, headers: ["If-Match":etag])
    }
    
    func updateMyInformation(){
        let request = self.requestForMyInfoWithUser("41316014",pass: "")
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                _ = data
            case .Failure(_, let error):
                _ = error
            }
        }
    }
    
    
    func foo(){
        
    }
    
    func login(user:String,pass:String){
        let request = self.requestForMyInfoWithUser("41316014",pass:"")
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                self.myInfo = Student(json: JSON(data),isMe: true)
                self.delegate.loggedIn!()
            case .Failure(_, let error):
                self.delegate.networkError()
            }
            
            
        }
    }
    
    func allCoursesRequired(){
        self.delegate.loggedIn!()
    }
    
    
    private init() {
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        configuration.timeoutIntervalForResource = 3 // seconds
        self.alamofireManager = Alamofire.Manager(configuration: configuration)
        
        
    }
    
    class func defaultHelper() -> StudentAuthenticationHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = StudentAuthenticationHelper()
            return self.instance!
        }
    }
    
    
    
}