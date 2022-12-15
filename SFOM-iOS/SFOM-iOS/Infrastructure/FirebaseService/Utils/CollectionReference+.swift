//
//  CollectionReference+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/15.
//

import Firebase

extension CollectionReference {
    func filter(_ whereFields: [WhereField]) -> Query {
        return whereFields.reduce(self) { partialResult, whereField -> Query in
            partialResult.filter(whereField)
        }
    }
}
