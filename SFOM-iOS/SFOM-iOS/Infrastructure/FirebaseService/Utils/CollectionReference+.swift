//
//  CollectionReference+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/15.
//

import Firebase

extension CollectionReference {
    func filter(_ filters: [FirebaseFilter]) -> Query {
        return filters.reduce(self) { partialResult, filter in
            switch filter {
            case let `in`(field, values):
                return partialResult.whereField(field, in: values)
            case let notIn(field, values):
                return partialResult.whereField(field, notIn: values)
            case let isEqualTo(field, value):
                return partialResult.whereField(field, isEqualTo: value)
            case let isNotEqualTo(field, value):
                return partialResult.whereField(field, isNotEqualTo: value)
            case let isLessThan(field, value):
                return partialResult.whereField(field, isLessThan: value)
            case let isGraterThan(field, value):
                return partialResult.whereField(field, isGraterThan: value)
            case let isLessThanOrEqualTo(field, value):
                return partialResult.whereField(field, isLessThanOrEqualTo: value)
            case let isGreaterThanOrEqualTo(field, value):
                return partialResult.whereField(field, isGreaterThanOrEqualTo: value)
            case let arrayContains(field, value):
                return partialResult.whereField(field, arrayContains: value)
            case let arrayContainsAny(field, values):
                return partialResult.whereField(field, arrayContainsAny: values)
            }
        }
    }
}
