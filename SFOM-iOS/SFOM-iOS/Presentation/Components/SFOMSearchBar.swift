//
//  SFOMSearchBar.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI

public struct SFOMSearchBar: View {
    private let cornerRadius: CGFloat = 24
    
    private var placeholder: String
    @Binding private var text: String
    @Binding private var state: Bool
    
    init(placeholder: String, text: Binding<String>, state: Binding<Bool>) {
        self.placeholder = placeholder
        self._text = text
        self._state = state
    }
    
    public var body: some View {
        HStack (alignment: .center) {
            if state {
                Button {
                    state = false
                } label: {
                    Assets.SystemIcon.back.image
                        .font(.SFOMFont14)
                        .padding(.leading)
                }
            }
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .font(.SFOMFont14)
                .onSubmit {
                    if state { state = false }
                    state = (text != "")
                }
            
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 12)
        .frame(height: 50)
        .background(Color.searchBarColor)
        .cornerRadius(cornerRadius)
        .foregroundColor(.textPrimaryColor)
        .overlay(RoundedRectangle(cornerRadius: cornerRadius)
            .stroke(Color.textPrimaryColor, lineWidth: 2))
    }
}
