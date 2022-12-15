//
//  Query+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/15.
//

import Firebase

extension Query {
    func filter(_ whereField: WhereField) -> Query{
        switch whereField {
        case let .`in`(field, values):
            return self.whereField(field, in: values)
        case let .notIn(field, values):
            return self.whereField(field, notIn: values)
        case let .isEqualTo(field, value):
            return self.whereField(field, isEqualTo: value)
        case let .isNotEqualTo(field, value):
            return self.whereField(field, isNotEqualTo: value)
        case let .isLessThan(field, value):
            return self.whereField(field, isLessThan: value)
        case let .isGreaterThan(field, value):
            return self.whereField(field, isGreaterThan: value)
        case let .isLessThanOrEqualTo(field, value):
            return self.whereField(field, isLessThanOrEqualTo: value)
        case let .isGreaterThanOrEqualTo(field, value):
            return self.whereField(field, isGreaterThanOrEqualTo: value)
        case let .arrayContains(field, value):
            return self.whereField(field, arrayContains: value)
        case let .arrayContainsAny(field, values):
            return self.whereField(field, arrayContainsAny: values)
        }
    }
}
