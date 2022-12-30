//
//  CornerRadiusRectangle.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/28.
//

import SwiftUI

struct CornerRadiusRectangle: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension CornerRadiusRectangle {
    func color(_ color: Color) -> some View {
        return self.fill(color)
    }
}
