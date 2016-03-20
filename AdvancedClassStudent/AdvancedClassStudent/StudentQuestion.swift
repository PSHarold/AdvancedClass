//
//  QuestionClass.swift
//  MultipleChoice
//
//  Created by Harold on 15/7/15.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON

enum QuestionType: Int{
    case MULTIPLE_CHOICE = 1
    case TRUE_OR_FALSE
    case MULTIPLE_CHOICE_MULTIPLE_ANSWERS
    case COMPLETION
    case OHTER
}

class StudentQuestion:NSObject{
    var questionId: String
    var content: String
    var questionType: QuestionType
    var choices: [String]!
    var points: Int
    var hint: String!
    var myAnswers: AnyObject!
    var difficulty: Int
    var difficultyString: String{
        get{
        switch self.difficulty{
            case 1:
                return "很简单"
            case 2:
                return "较简单"
            case 3:
                return "一般"
            case 4:
                return "较难"
            case 5:
                return "很难"
            default:
                return ""
            }
        }
    }
    
    
    init(json: JSON){
        self.questionId = json["question_id"].stringValue
        self.difficulty = json["difficulty"].intValue
        self.points = json["points"].intValue
        self.content = json["content"].stringValue
        self.questionType = QuestionType(rawValue: json["type"].intValue)!
        switch self.questionType{
        case .MULTIPLE_CHOICE:
            fallthrough
        case .MULTIPLE_CHOICE_MULTIPLE_ANSWERS:
            fallthrough
        case .TRUE_OR_FALSE:
            self.choices = json["choices"].rawValue as! [String]
            self.myAnswers = [String]()
        default:
            self.choices = nil
            self.myAnswers = ""
        }
        
    }
    
}


