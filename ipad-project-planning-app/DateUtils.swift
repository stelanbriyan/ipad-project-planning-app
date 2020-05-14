//
//  DateUtils.swift
//  ipad-project-planning-app
//
//  Created by Stelan Simonsz on 5/14/20.
//  Copyright © 2020 Stelan Simonsz. All rights reserved.
//

import Foundation

public class DateUtils{
     let now = Date()
    
    public func getDateDiff(_ start: Date, end: Date) -> Int {
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: start) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: end) else {
            return 0
        }
        return end - start
    }
    
    public func getRemainingTimePercentage(_ start: Date, end: Date) -> Int {
        let elapsed = getTimeDiffInSeconds(start, end: end)
        let remaining = getTimeDiffInSeconds(now, end: end)
        
        print(end)
        var percentage = 100
        
        if elapsed > 0 {
            percentage = Int(100 - ((remaining / elapsed) * 100))
        }
        
        return percentage
    }
    
    public func getTimeDiffInSeconds(_ start: Date, end: Date) -> Double {
        let difference: TimeInterval? = end.timeIntervalSince(start)

        if Double(difference!) < 0 {
            return 0
        }
        
        return Double(difference!)
    }
    
    
}
