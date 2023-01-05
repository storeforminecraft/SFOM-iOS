//
//  ButtonStyle.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/04.
//

import SwiftUI

struct NoAnimationButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}
