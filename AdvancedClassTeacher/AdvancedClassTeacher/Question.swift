//
//  QuestionClass.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/15.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class Question:NSObject{
    var question:String
    var answer:Int
    var choices = [String:String]()
    var id:String
    var chapter:Int
    var knowledgePoint:String
    var etag:String
    var courseId:String
    var answerDetail:String
    var difficultyInt = -1
    
    var difficultyString:String{
        get{
            switch self.difficultyInt{
            case 0:
                return "简单"
            case 1:
                return "中等"
            case 2:
                return "困难"
            default:
                return ""
            }
        }
    }
    init(json:JSON){
        self.question = json["content"].stringValue
        self.etag = json["_etag"].stringValue
        self.choices["A"] = json["choices","A"].stringValue
        self.choices["B"] = json["choices","B"].stringValue
        self.choices["C"] = json["choices","C"].stringValue
        self.choices["D"] = json["choices","D"].stringValue
        let answers = json["answer"]
        self.courseId = json["course_id"].stringValue
        self.id = json["_id"].stringValue
        self.chapter = json["chapter"].intValue
        self.knowledgePoint = json["knowledge_point"].stringValue
        self.answerDetail = json["answer_detail"].stringValue
        self.difficultyInt = json["difficulty"].intValue
        switch answers[0].stringValue{
        case "A":
            self.answer = 0
        case "B":
            self.answer = 1
        case "C":
            self.answer = 2
        case "D":
            self.answer = 3
        default:
            self.answer = -1
        }

    }
     
    
    override init(){
        self.question = ""
        self.answer = -1
        for name in ["A","B","C","D"]{
            self.choices[name] = ""
        }
        self.id = ""
        self.chapter = 0
        self.knowledgePoint = ""
        self.etag = ""
        self.courseId = ""
        self.answerDetail = ""
    }
}


