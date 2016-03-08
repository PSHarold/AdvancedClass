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
    case MULTIPLE_CHOICE = 0
    case TRUE_OR_FALSE = 1
    case COMPLETION = 2
    case MULTIPLE_CHOICE_MULTIPLE_ANSWERS = 3
    case OTHER = 4
    static let allValues = [0, 1, 2, 3, 4]
}


class TeacherQuestion{
    
    static var allQuestions = [String: TeacherQuestion]()
    
    var preview = false
    var questionId: String!
    var content: String!
    var choices: [String]!
    var difficultyInt: Int!
    var knowledgePointId: String!
    var difficultyString: String!
    var questionType: QuestionType!
    
    
    static func createPreview(json: JSON) -> TeacherQuestion{
        let q = TeacherQuestion()
        q.preview = true
        q.questionId = json["question_id"].stringValue
        q.content = json["content"].stringValue
        q.difficultyInt = json["difficulty"].intValue
        q.questionType = QuestionType(rawValue: json["type"].intValue)
        TeacherQuestion.allQuestions[q.questionId] = q
        return q
    }
    
}


