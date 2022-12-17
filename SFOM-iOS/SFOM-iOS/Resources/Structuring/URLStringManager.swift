//
//  File.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import Foundation


struct URLStringManager {
    private init() { }
    static func urlString(key: String) -> String?{
        guard let fileUrl = Bundle.main.url(forResource: "url", withExtension: "plist") else { return nil }
        guard let urlDictionary = NSDictionary(contentsOf: fileUrl) else { return nil }
        return urlDictionary[key] as? String
    }
}
