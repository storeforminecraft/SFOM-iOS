//
//  SFOMComponents.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Combine

public struct SFOMTabButton: View {
    private let kind: Assets.tabBar
    private let action: () -> Void
    private var selected: Bool = false

    init(kind: Assets.tabBar, action: @escaping () -> Void) {
        self.kind = kind
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            kind.image
        }
    }
}

public struct SFOMButton: View {
    private let content: String
    private let accent: Bool
    private let spacer: Bool
    private let font: Font
    private let action: () -> Void

    public init<S>(_ content: S,
                   accent: Bool = true,
                   spacer: Bool = true,
                   font: Font = .body.bold(),
                   action: @escaping () -> Void
    ) where S: StringProtocol {
        self.content = content as? String ?? ""
        self.accent = accent
        self.spacer = spacer
        self.font = font
        self.action = action
    }

    public var body: some View {
        Button {
            action()
        } label: {
            if spacer {
                HStack {
                    Spacer()
                    Text(content)
                        .font(font)
                    Spacer()
                }
                    .padding()
                    .background(accent ? Color.accentColor : Color.accentColor.opacity(0.2))
                    .foregroundColor(accent ? Color.white : Color.accentColor)
                    .cornerRadius(12)
            } else {
                Text(content)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .font(font)
                    .background(accent ? Color.accentColor : Color.accentColor.opacity(0.2))
                    .foregroundColor(accent ? Color.white : Color.accentColor)
                    .cornerRadius(12)
            }
        }
    }
}
