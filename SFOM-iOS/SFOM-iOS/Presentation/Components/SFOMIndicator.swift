//
//  SFOMIndicator.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/11.
//

import SwiftUI
import Combine

final class SFOMIndicatorConfigure {
    let width: CGFloat
    let height: CGFloat
    let color: Color
    let lastColor: Color
    let backgroundColor: Color
    let cornerRadius: CGFloat
    
    init(  width: CGFloat,
           height: CGFloat,
           color: Color = .accentColor,
           lastColor: Color = .clear,
           backgroundColor: Color = .clear,
           cornerRadius: CGFloat = 0) {
        self.width = width
        self.height = height
        self.color = color
        self.lastColor = lastColor
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
    }
}

struct SFOMIndicator: View {
    private var offsetY: CGFloat = 0
    let configure: SFOMIndicatorConfigure
    
    @Binding var state: Bool
    
    @State private var isAnimating: Bool = false
    @State private var isTransition: Bool = false {
        didSet {
            withAnimation {
                isAnimating = isTransition
            }
        }
    }
    
    init(state: Binding<Bool>) {
        self.configure = SFOMIndicatorConfigure(width: 400, height: 10)
        self._state = state
    }
    
    init(configure: SFOMIndicatorConfigure, state: Binding<Bool>) {
        self.configure = configure
        self._state = state
    }
    
    var body: some View {
        VStack {
            if state {
                GeometryReader { proxy in
                    
                    RadialGradient(gradient:
                                    Gradient(colors: [configure.color, configure.lastColor]),
                                   center: .center,
                                   startRadius: 0,
                                   endRadius: configure.width / 2)
                    .animation(.linear(duration: 1.5)
                        .repeatForever(autoreverses: false),
                               value: self.isAnimating)
                    .offset(x: isAnimating ? proxy.size.width : -configure.width)
                }
            } else {
                HStack { Spacer() }
            }
        }
        .frame(height: configure.height)
        .background(configure.backgroundColor)
        .cornerRadius(configure.cornerRadius)
        .onReceive(Just(state)) { res in
            withAnimation {
                isAnimating = res
            }
        }
    }
}
