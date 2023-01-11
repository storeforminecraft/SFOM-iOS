//
//  SFOMReports.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/11.
//

import Foundation

enum SFOMReports: String {
    case a1
    case a2
    case a3
    case a4
    case a5
    case a6
    
    static let list: [Self] = [.a1, .a2, .a3, .a4, .a5, .a6]
    
    var reportCode: String {
        return "report:\(self.rawValue)"
    }
    
    var description: String {
        switch self {
        case .a1: return StringCollection.Report.reportA1.localized
        case .a2: return StringCollection.Report.reportA2.localized
        case .a3: return StringCollection.Report.reportA3.localized
        case .a4: return StringCollection.Report.reportA4.localized
        case .a5: return StringCollection.Report.reportA5.localized
        case .a6: return StringCollection.Report.reportA6.localized
        }
    }
}
