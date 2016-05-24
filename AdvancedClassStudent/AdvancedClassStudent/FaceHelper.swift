//
//  FaceHelper.swift
//  Face
//
//  Created by Harold on 16/4/4.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
class FaceHelper{
    static var _defaultHelper: FaceHelper?
    static var defaultHelper: FaceHelper{
        if _defaultHelper == nil{
            _defaultHelper = FaceHelper()
        }
        return _defaultHelper!
    }
    
    static func drop(){
        _defaultHelper = nil
    }
    var faceIds = [String]()
    var faceImages = [String: FaceImage]()
    var faceAcquiredCount = 0
    
    weak var authHelper = StudentAuthenticationHelper.defaultHelper
    
    func getFaceIds(completionHandler: ResponseMessageHandler){
        self.faceIds = []
        self.faceAcquiredCount = 0
        self.authHelper!.getResponseGET(RequestType.GET_FACES, parameters: [:]){
            (error, json) in
            if error == nil{
                for (_, id) in json["faces"]{
                    self.faceIds.append(id.stringValue)
                }
            }
            completionHandler(error: error)
        }
    }
    
    
    
    
    func getFaceImages(completionHandler: ResponseMessageHandler){
        self.getFaceIds{
            error in
            if error == nil{
                if self.faceIds.count == 0{
                    completionHandler(error: nil)
                }
                for faceId in self.faceIds{
                    self.getFaceImage(faceId){
                        [unowned self]
                        error in
                        if error == nil{
                            self.faceAcquiredCount += 1
                            if self.faceAcquiredCount == self.faceIds.count{
                                self.faceAcquiredCount == 0
                                completionHandler(error: nil)
                            }
                        }
                        else{
                            completionHandler(error: error)
                        }
                    }
                }

            }
            else{
                completionHandler(error: error)
            }
        }
    }
    
    func getFaceImage(faceId: String, completionHandler: ResponseMessageHandler){
        self.authHelper!.getResponseGetFile(RequestType.GET_FACE_IMAGE, method: .POST, parameters: ["face_id": faceId]){
            [unowned self]
            error, img in
            if error == nil{
                self.faceImages[faceId] = FaceImage(faceId: faceId, image: UIImage(data: img)!)
            }
            completionHandler(error: error)
        }
    }
    
    
    
    func addFace(faceImage: UIImage, completionHandler: ResponseMessageHandler){
        let data = UIImageJPEGRepresentation(faceImage, 0.5)!
        self.authHelper!.postFile(RequestType.ADD_FACE, fileName: "face.jpg", fileType: FileType.JPG, fileData: data){
            [unowned self]
            error, json in
            if error == nil{
                let faceId = json["face_id"].stringValue
                self.faceIds.append(faceId)
                self.faceImages[faceId] = FaceImage(faceId: faceId, image: faceImage)
            }
            completionHandler(error: error)
        }
    }
    
    func deleteFace(faceId: String, completionHandler: ResponseMessageHandler){
        self.authHelper!.getResponsePOST(RequestType.DELETE_FACE, parameters: ["face_id": faceId]){
            [unowned self]
            error, json in
            if error == nil{
                if let index = self.faceIds.indexOf(faceId){
                    self.faceIds.removeAtIndex(index)
                }
                self.faceImages.removeValueForKey(faceId)                
            }
            completionHandler(error: error)
        }
    }
    
    func testFace(faceImage: UIImage, completionHandler: (MyError?, Bool!) -> Void) {
        let data = UIImageJPEGRepresentation(faceImage, 0.5)!
        self.authHelper!.postFile(RequestType.TEST_FACE, fileName: "face.jpg", fileType: FileType.JPG, fileData: data){
            error, json in
            if error == nil{
                let result = json["is_same_person"].boolValue
                completionHandler(nil, result)
                return
            }
            completionHandler(error, nil)
        }
    }
    
    
}