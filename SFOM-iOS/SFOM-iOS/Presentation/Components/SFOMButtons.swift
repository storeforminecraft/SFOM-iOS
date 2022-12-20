//
//  SFOMComponents.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI

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

public struct SFOMTabButton: View {
    @Binding var selectedIndex: Int
    private let tag: Int
    private let kind: Assets.TabBar

    init(kind: Assets.TabBar, tag: Int, selectedIndex: Binding<Int>) {
        self._selectedIndex = selectedIndex
        self.tag = tag
        self.kind = kind
    }

    public var body: some View {
        Button {
            selectedIndex = tag
        } label: {
            ZStack {
                Group {
                    kind.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    if self.selectedIndex == self.tag {
                        Color.accentColor.blendMode(.sourceAtop)
                    }
                }
            }.drawingGroup(opaque: false)
        }
    }
}

public struct SFOMBackButton: View {
    private var backAction: () -> Void

    init(backAction: @escaping () -> Void) {
        self.backAction = backAction
    }

    public var body: some View {
        Button {
            backAction()
        } label: {
            HStack {
                Assets.SystemIcon.backCircle.image
                Text(Localized.back)
            }.padding(.vertical)
        }
    }
}
