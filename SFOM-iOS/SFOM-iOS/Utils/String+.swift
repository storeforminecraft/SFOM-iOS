//
//  String+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/18.
//

import Foundation

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }
    
    var lastWord: String? {
        self.components(separatedBy: [" "]).last
    }
    
    public subscript(r: Int, l: Int = Int.max) -> String {
        let startIndex = self.index(self.startIndex, offsetBy: r)
        let endIndex = self.index(self.startIndex, offsetBy: l == Int.max ? r+1 : min(l, self.count))
        return String(self[startIndex..<endIndex])
    }

}
