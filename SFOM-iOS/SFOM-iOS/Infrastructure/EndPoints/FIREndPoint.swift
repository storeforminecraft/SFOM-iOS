//
//  FIREndPoint.swift
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
    var needUid: Bool { get }
    func path(uid: String?) -> String
}

protocol FIREndPoint {
    var reference: (collection: MainCollection,
                    document: Document?,
                    subCollection: SubCollection?,
                    subDocument: Document?,
                    subCollection2: SubCollection?,
                    subDocument2: Document?) { get }
}
