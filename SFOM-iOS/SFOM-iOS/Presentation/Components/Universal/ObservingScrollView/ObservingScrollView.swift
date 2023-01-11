//
//  ObservingScrollView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/04.
//

import SwiftUI

public struct ObservingScrollView<Content>: View where Content: View {
    var configuration: ObservingScrollViewConfiguration
    @ViewBuilder let content: () -> Content
    
    @State private var superViewOffset: CGFloat = .zero
    @State private var superViewSize: CGFloat = .zero
    @State private var scrollSize: CGFloat = .zero
    @State private var scrollOffset: CGFloat = .zero
    
    init(showIndicators: Bool = true,
         additionalValue: CGFloat = 200,
         @ViewBuilder content: @escaping () -> Content) {
        self.configuration = .init(showIndicators: showIndicators,
                                   additionalValue: additionalValue)
        self.content = content
    }
    
    public var body: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .global).origin.y
            let size = proxy.size.height
            ScrollView (showsIndicators: configuration.showIndicators){
                ZStack (alignment:.topLeading){
                    scrollObservableBar
                    ScrollSizeBar
                    content()
                }
            }
            .preference(key: ViewSizeKey.self, value: size)
            .onAppear{
                self.superViewOffset = offset
                self.superViewSize = size
            }
        }
        .onPreferenceChange(ViewSizeKey.self) { size in
            self.superViewSize = size
        }
    }
    
    private var scrollObservableBar: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .global).origin.y
            Color.clear
                .preference(key: ScrollOffsetKey.self, value: offset)
                .onAppear{
                    self.scrollOffset = offset
                }
        }
        .onPreferenceChange(ScrollOffsetKey.self) { value in
            let topValue = value - superViewOffset
            let bottomValue = -(scrollSize + (topValue - superViewSize))
            
            if topValue > configuration.additionalValue {
                self.configuration.topActions.forEach { action in
                    action(topValue)
                }
            }
            if (scrollSize < superViewSize && -topValue > configuration.additionalValue) ||
                bottomValue > configuration.additionalValue {
                self.configuration.bottomActions.forEach { action in
                    action(bottomValue)
                }
            }
        }
        .frame(height: 0)
    }
    
    private var ScrollSizeBar: some View {
        GeometryReader { proxy in
            let size = proxy.size.height
            Color.clear
                .preference(key: ViewSizeKey.self, value: size)
                .onAppear{
                    self.scrollSize = size
                }
        }
        .onPreferenceChange(ViewSizeKey.self) { value in
            self.scrollSize = value
        }
        .frame(width: 0)
    }
}

