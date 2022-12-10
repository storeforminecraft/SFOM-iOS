//
//  EndPoint.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation

protocol MainCollection {
    var path: String { get }
}

protocol SubCollection {
    var parent: MainCollection { get }
    var path: String { get }
}

protocol Document {
    var isCurrentUser: Bool { get }
    var path: String { get }
}

protocol EndPoint {
    var reference: (collection: MainCollection,
              document: Document?,
              subCollection: SubCollection?,
              subDocument: Document?) { get }
}
