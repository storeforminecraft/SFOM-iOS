//
//  ObservingScrollView+Action.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/05.
//

import Foundation

extension ObservingScrollView {
    func top(_ action: @escaping (_ value: CGFloat)->Void) ->  Self {
        self.configuration.topActions.append(action)
        return self
    }
    
    func bottom(_ action: @escaping (_ value: CGFloat)->Void) -> Self {
        self.configuration.bottomActions.append(action)
        return self
    }
}
