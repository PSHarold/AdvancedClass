//
//  BaseTestHelper.swift
//  MyClassStudent
//
//  Created by Harold on 15/8/16.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
protocol TeacherNewTestDelegate{
    func questionAdded(currentQuestionNum: Int)
    func questionRemoved(currentQuestionNum: Int)
}

class TeacherTestHelper{
    
    static var _defaultHelper: TeacherTestHelper?
    static var defaultHelper:TeacherTestHelper{
        get{
            if _defaultHelper == nil{
                _defaultHelper = TeacherTestHelper()
            }
            return _defaultHelper!
        }
    }
    private var delegate: TeacherNewTestDelegate?
    private var _newTest: TeacherNewTest!
    var newTest: TeacherNewTest{
        get{
            if self._newTest == nil{
                self._newTest = TeacherNewTest()
            }
            return self._newTest
        }
    }

    func dropNewTest(){
        self._newTest = nil
    }
    
    func addQuestionToNewTest(question: TeacherQuestion){
        self.newTest.addQuestion(question)
        self.delegate!.questionAdded(self.newTest.totalNum)
    }
    func removeQuestionToNewTest(question: TeacherQuestion){
        self.newTest.removeQuestion(question)
        self.delegate!.questionRemoved(self.newTest.totalNum)
    }
    
    
    
    
}