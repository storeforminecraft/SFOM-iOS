//
//  File.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Foundation

enum URLStringKey: String {
    case firebaseDatabaseURL
    case httpURL
    case resourceURL
    case imageURL
}

struct URLStringManager {
    private init() { }
    static func urlString(key: URLStringKey) -> String {
        guard let fileUrl = Bundle.main.url(forResource: "url", withExtension: "plist") else { fatalError("DOSEN'T EXIST URL FILE") }
        guard let urlDictionary = NSDictionary(contentsOf: fileUrl) else { fatalError("DOSEN'T EXIST URL KEY") }
        guard let result = urlDictionary[key.rawValue] as? String else { fatalError("COULDN'T CONVERT TO STRING") }
        return result
    }
}
