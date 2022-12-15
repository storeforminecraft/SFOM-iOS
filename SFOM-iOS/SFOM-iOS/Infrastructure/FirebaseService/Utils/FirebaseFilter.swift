//
//  FirebaseFilter.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/15.
//

import Foundation

enum FirebaseFilter {
    case `in`(_ field: String, values: [Any])
    case notIn(_ field: String, values: [Any])
    case isEqualTo(_ field: String, value: Any)
    case isNotEqualTo(_ field: String, value: Any)
    case isLessThan(_ field: String, value: Any)
    case isGraterThan(_ field: String, value: Any)
    case isLessThanOrEqualTo(_ field: String, value: Any)
    case isGreaterThanOrEqualTo(_ field: String, value: Any)
    case arrayContains(_ field: String, value: Any)
    case arrayContainsAny(_ field: String, values: [Any])
}
