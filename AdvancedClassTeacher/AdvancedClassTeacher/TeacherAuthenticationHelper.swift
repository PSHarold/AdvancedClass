
//
//  TeacherAuthenticationHelper.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/5.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
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
@objc protocol TeacherAuthenticationHelperDelegate{
    optional func myInformationUpdated()
    optional func loggedIn()
    optional func needLoggingIn()
    func networkError()
}


class TeacherAuthenticationHelper {
    
    
    
    static var instance:TeacherAuthenticationHelper?
    var alamofireManager : Alamofire.Manager!
    var delegate:TeacherAuthenticationHelperDelegate!
    var myInfo:Teacher!
    let baseRootUrl:String = TARGET_IPHONE_SIMULATOR == 0 ? "http://192.168.2.1:5000/" : "http://localhost:5000/"
    let urlDict = ["knowledgePoints":"knowledge_points","questions":"questions","tests":"tests","results":"results","courses":"courses","students":"students","teachers":"teachers","rooms":"rooms","notifications":"notifications"]
    

    func updateMyInformation(){
        let request = self.requestForMyInfoWithUser("B0000000",pass: "")
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
    
    func requestForNotificationsWithCourseId(id:String,subId:String) -> Request{
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["courses"]! + "/" + id + "/" + subId + "/" + self.urlDict["notifications"]!, parameters: nil, encoding: ParameterEncoding.URL, headers: nil)

    }
    
    func requestForMyInfoWithUser(user:String,pass:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["teachers"]! + "/\(user)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForTestsWithCourseId(id:String,subId:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["courses"]! + "/" + id + "/" + subId + "/" + self.urlDict["tests"]!, parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForQuestionUploading(question:Dictionary<String,AnyObject>) ->Request {
        return self.alamofireManager.request(.POST, self.baseRootUrl + self.urlDict["questions"]!, parameters: question, encoding: .JSON, headers: nil)
    }
    
    func requestForQuestionDeletionWithQuestionId(id:String,etag:String) ->Request {
        return self.alamofireManager.request(.DELETE, self.baseRootUrl + self.urlDict["questions"]! + "/\(id)", parameters: nil, encoding: .JSON, headers: ["If-Match":etag])
    }
    
    func requestForQuestionModificationWithQuestionId(id:String,etag:String,patchDict:Dictionary<String,AnyObject>) ->Request {
        return self.alamofireManager.request(.PATCH, self.baseRootUrl + self.urlDict["questions"]! + "/\(id)", parameters: patchDict, encoding: .JSON, headers: ["If-Match":etag])
    }
    
    func requestForResultsUploading(result:Dictionary<String,AnyObject>) ->Request {
        return self.alamofireManager.request(.POST, self.baseRootUrl + self.urlDict["results"]!, parameters: result, encoding: .JSON, headers: nil)
        
    }
    
    func requestForTestUploading(test:Dictionary<String,AnyObject>) ->Request {
         return self.alamofireManager.request(.POST, self.baseRootUrl + self.urlDict["tests"]!, parameters: test, encoding: .JSON, headers: nil)
    }
    
    func requestForStudentWithId(id:String) -> Request{
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["students"]! + "/\(id)", parameters: nil, encoding: ParameterEncoding.URL, headers: nil)
    }
    
    
    func requestForSeatSelectionWithSeatId(id:String,etag:String,patchDict:Dictionary<String,AnyObject>) -> Request{
        return self.alamofireManager.request(.PATCH, self.baseRootUrl + self.urlDict["seats"]! + "/\(id)", parameters: patchDict, encoding: .JSON, headers: ["If-Match":etag])
    }
    func requestForKnowledgePoints() -> Request{
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["knowledgePoints"]!, parameters: nil, encoding: .JSON, headers: nil)
    }
    
    func requestForQuestionsWithCourseId(id:String) ->Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["courses"]! + "/\(id)/" + self.urlDict["questions"]!, parameters: nil, encoding: .JSON, headers: nil)
    }
    
    func requestForTestResultsWithCourseId(id:String) -> Request {
        return self.alamofireManager.request(.GET, self.baseRootUrl + self.urlDict["results"]!, parameters: ["where":["test_id":id]], encoding: ParameterEncoding.URL, headers: nil)
    }
    
    func requestForTestModificationWithQuestionId(id:String,etag:String,patchDict:Dictionary<String,AnyObject>) ->Request {
        return self.alamofireManager.request(.PATCH, self.baseRootUrl + self.urlDict["tests"]! + "/\(id)", parameters: patchDict, encoding: .JSON, headers: ["If-Match":etag])
    }
    
    func requestForTestDeletionWithTestId(id:String,etag:String) ->Request{
        return self.alamofireManager.request(.DELETE, self.baseRootUrl + self.urlDict["tests"]! + "/\(id)", parameters: nil, encoding: .JSON, headers: ["If-Match":etag])
    }
    
    func requestForNotificationUploading(notification:Dictionary<String,AnyObject>) -> Request {
        return self.alamofireManager.request(.POST, self.baseRootUrl + self.urlDict["notifications"]!, parameters: notification, encoding: .JSON, headers: nil)
    }
    func requestForNoticationModificationWithId(id:String,etag:String,patchDict:Dictionary<String,AnyObject>) -> Request{
        return self.alamofireManager.request(.PATCH, self.baseRootUrl + self.urlDict["notifications"]! + "/\(id)", parameters: patchDict, encoding: .JSON, headers: ["If-Match":etag])
    }
    
    func requestForNotificationDeletionWithTestId(id:String,etag:String) ->Request{
        return self.alamofireManager.request(.DELETE, self.baseRootUrl + self.urlDict["notifications"]! + "/\(id)", parameters: nil, encoding: .JSON, headers: ["If-Match":etag])
    }
    func login(user:String,pass:String){
        let request = self.requestForMyInfoWithUser("B0000000",pass:"")
        request.responseJSON(){
            (_,_,result) in
            switch result {
            case .Success(let data):
                self.myInfo = Teacher(json: JSON(data))
                self.delegate.loggedIn!()
            case .Failure:
                self.delegate.networkError()
            }
            
            
        }
    }
    
    
    
    
    private init() {
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        configuration.timeoutIntervalForResource = 3 // seconds
        self.alamofireManager = Alamofire.Manager(configuration: configuration)

    }
    
    class func defaultHelper() -> TeacherAuthenticationHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = TeacherAuthenticationHelper()
            return self.instance!
        }
    }
    
 
   
    
}