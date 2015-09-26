//
//  DateTimeHelper.swift
//  AdvancedClassTeacher
//
//  Created by Harold on 15/9/2.
//  Copyright (c) 2015年 Harold. All rights reserved.
//

import Foundation
class DateTimeHelper {
    static var instance:DateTimeHelper?
    
    var currentTime:String{
        get{
            return "测试时间"
        }
    }
    private init(){
        
    }
    class func defaultHelper() -> DateTimeHelper{
        if let helper = self.instance{
            return helper
        }
        else{
            self.instance = DateTimeHelper()
            return self.instance!
        }
    }
    
    
}