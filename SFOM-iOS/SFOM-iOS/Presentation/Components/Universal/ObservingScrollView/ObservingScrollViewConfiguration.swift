//
//  ObservingScrollViewConfiguration.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/05.
//

import Foundation

final class ObservingScrollViewConfiguration {
    let showIndicators: Bool
    let additionalValue: CGFloat
    
    var topActions: [((_ value: CGFloat) -> Void)] = []
    var bottomActions: [(_ value: CGFloat) -> Void] = []
    
    init(showIndicators: Bool,
         additionalValue: CGFloat,
         topActions: [ (_: CGFloat) -> Void] = [],
         bottomActions: [ (_: CGFloat) -> Void] = []) {
        self.showIndicators = showIndicators
        self.additionalValue = additionalValue
        self.topActions = topActions
        self.bottomActions = bottomActions
    }
}
