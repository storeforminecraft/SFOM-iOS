//
//  View+.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/27.
//

import SwiftUI
import UIKit

extension View {
    func halfModal<ModalView: View>(isPresented: Binding<Bool>, @ViewBuilder modalView: @escaping () -> ModalView) -> some View {
        return self.overlay(alignment: .bottom) {
            HalfModal(isPresented: isPresented) {
                modalView()
            }
        }
    }
}

struct HalfModal<ModalView: View>: View {
    @Binding private var isPresented: Bool
    @ViewBuilder private var modalView: () -> ModalView
    @State private var offset = CGFloat.zero
    @State private var currentHeight: CGFloat
    private let startValue: CGFloat
    private let detents: [CGFloat]
    
    init(isPresented: Binding<Bool>, detents: [Detents] = [Detents.medium],  @ViewBuilder modalView: @escaping () -> ModalView) {
        self._isPresented = isPresented
        self.modalView = modalView
        
        self.startValue = detents[0].value
        self.detents = [0] + detents.map{ $0.value }
        self.currentHeight = Detents.medium.value
    }
    
    var body: some View {
        VStack{
            if isPresented {
                VStack(alignment: .center) {
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 100, height: 5)
                        .foregroundColor(Color(.lightGray))
                        .padding(.vertical, 5)
                    modalView()
                        .padding(.top, 15)
                    Spacer()
                    HStack { Spacer() }
                }
                .frame(height: currentHeight)
                .ignoresSafeArea()
                .background(CornerRadiusRectangle(corners: [.topLeft, .topRight],
                                                  radius: 16)
                    .color(.white)
                    .ignoresSafeArea()
                    .shadow(color: Color(.lightGray), radius: 1, y: -1)
                )
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.easeIn, value: isPresented)
        .animation(.easeIn, value: currentHeight)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    if gesture.startLocation.y < 20, (currentHeight - gesture.location.y) > 0 {
                        currentHeight = currentHeight - gesture.location.y
                    }
                }
                .onEnded { _ in
                    currentHeight = detents.map { ($0, abs($0 - currentHeight)) }.min { $0.1 < $1.1 }?.0 ?? 0
                    if currentHeight <= 0 {
                        isPresented = false
                        currentHeight = startValue
                    }
                }
        )
        
    }
    
    enum Detents {
        case medium
        case large
        case custom(_ value: CGFloat)
        
        var value: CGFloat {
            switch self {
            case .medium: return UIScreen.main.bounds.height / 2 - 20
            case .large: return UIScreen.main.bounds.height - 100
            case let .custom(value): return value
            }
        }
    }
}

