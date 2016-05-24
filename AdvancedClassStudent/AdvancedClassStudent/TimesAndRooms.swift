//
//  TimesAndRooms.swift
//  AdvancedClassStudent
//
//  Created by Harold on 16/2/20.
//  Copyright © 2016年 Harold. All rights reserved.
//

import Foundation
import SwiftyJSON
class TeachDay{
    var week = 0
    var day = 0
    init(week: Int, day: Int){
        self.day = day
        self.week = week
    }
}


class OnePeriod{
    var days = [Int]()
    var period: Int!
    var room_id:String!
    var room_name:String!
    var weeks = [Int]()
}

enum AvailablePeriodsMode{
    case Past
    case Future
    case All
}
class TimesAndRooms {
    var times = [OnePeriod]()
    init(json:JSON){
        for (_,time):(String,JSON) in json{
            let period = OnePeriod()
            for (_, day):(String,JSON) in time["days"]{
                period.days.append(day.intValue)
            }
            for (_, week):(String,JSON) in time["weeks"]{
                period.weeks.append(week.intValue)
            }
            period.room_id = time["room_id"].stringValue
            period.room_name = time["room_name"].stringValue
            period.period = time["period"].intValue
            self.times.append(period)
        }
    }
    func getAvailableWeeks(mode: AvailablePeriodsMode) -> [Int]{
        var weeks = Set<Int>()
        
        switch mode {
        case .Past:
            for period in self.times{
                let t = period.weeks.filter({$0<=currentWeekNo})
                let tweeks = Set<Int>(t)
                weeks = weeks.union(tweeks)
            }
            
        case .Future:
            for period in self.times{
                let t = period.weeks.filter({$0>=currentWeekNo})
                let tweeks = Set<Int>(t)
                weeks = weeks.union(tweeks)
            }
        case .All:
            for period in self.times{
                let tweeks = Set<Int>(period.weeks)
                weeks = weeks.union(tweeks)
            }
        }
        let sorted = Array<Int>(weeks)
        return sorted.sort()
    }
    
    
    
    func getAvailableDaysInWeek(weekNo: Int, mode: AvailablePeriodsMode) -> [Int]{
        var days: Set<Int>
        var arr = [Int]()
        
        for period in self.times{
            if period.weeks.contains(weekNo){
                arr += period.days
            }
        }
        switch mode {
        case .Past:
            if weekNo == currentWeekNo{
                arr = arr.filter({$0<=currentDayNo})
            }
        case .Future:
            if weekNo == currentWeekNo{
                arr = arr.filter({$0>=currentDayNo})
            }
        case .All:
            break
        }
        
        days = Set<Int>(arr)
        return Array(days).sort()
    }
    
    func getAvailablePeriodInWeek(weekNo: Int, andDay dayNo:Int) -> [Int]{
        var periods = Set<Int>()
        for period in self.times{
            if period.weeks.contains(weekNo) && period.days.contains(dayNo){
                periods.insert(period.period)
                return Array(periods).sort()
            }
        }
        return Array(periods).sort()
    }
    
}