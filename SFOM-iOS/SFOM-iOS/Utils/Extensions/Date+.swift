//
//  Date+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/19.
//

import Foundation

extension Date {
    func ago() -> String {
        let minutes = self.agoMiniutes()
        let hours = minutes / 60
        let days = hours / 24
        
        var time = ""
        if days > 0 {
            time = (days == 1 ? "\(Localized.Time.aDay)" : "\(days)\(Localized.Time.days)")
        } else if hours > 0 {
            time = (hours == 1 ? "\(Localized.Time.anHour)" : "\(hours)\(Localized.Time.hours)")
        } else {
            time = (minutes == 1 ? "\(Localized.Time.aMinute)" : "\(minutes)\(Localized.Time.minutes)")
        }
        return "\(time) \(Localized.Time.ago)"
    }
    
    func agoMiniutes() -> Int{
        let miniutes = Int(Date().timeIntervalSince(self) / 60)
        return miniutes
    }
}
