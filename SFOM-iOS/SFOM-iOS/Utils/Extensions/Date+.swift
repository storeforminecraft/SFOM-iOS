//
//  Date+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/19.
//

import Foundation

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: StringCollection.location)
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEEE"
        return formatter.string(from: self)
    }
    
    func ago() -> String {
        let minutes = self.agoMiniutes()
        let hours = minutes / 60
        let days = hours / 24
        let years = days / 365
        
        var time = ""
        if years > 0 {
            time = (years == 1 ? "\(StringCollection.Time.aYear.localized)" : "\(days)\(StringCollection.Time.years.localized)")
        } else if days > 0 {
            time = (days == 1 ? "\(StringCollection.Time.aDay.localized)" : "\(days)\(StringCollection.Time.days.localized)")
        } else if hours > 0 {
            time = (hours == 1 ? "\(StringCollection.Time.anHour.localized)" : "\(hours)\(StringCollection.Time.hours.localized)")
        } else {
            time = (minutes == 1 ? "\(StringCollection.Time.aMinute.localized)" : "\(minutes)\(StringCollection.Time.minutes.localized)")
        }
        return "\(time) \(StringCollection.Time.ago.localized)"
    }
    
    func agoMiniutes() -> Int{
        let miniutes = Int(Date().timeIntervalSince(self) / 60)
        return miniutes
    }
}
