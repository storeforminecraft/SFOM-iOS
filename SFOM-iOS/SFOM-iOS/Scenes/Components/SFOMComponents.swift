//
//  SFOMComponents.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI
import Kingfisher

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

public struct SFOMNavigationLink<Destination>: View where Destination: View {
    private let content: String
    private let accent: Bool
    private let spacer: Bool
    private let font: Font
    var destination: () -> Destination

    public init<S>(_ content: S,
                   accent: Bool = true,
                   spacer: Bool = true,
                   font: Font = .body.bold(),
                   destination: @escaping () -> Destination
    ) where S: StringProtocol {
        self.content = content as? String ?? ""
        self.accent = accent
        self.spacer = spacer
        self.font = font
        self.destination = destination
    }

    public var body: some View {
        NavigationLink {
            destination()
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

public struct SFOMPostView<Destination>: View where Destination: View {
    var post: Post
    var destination: () -> Destination

    init(post: Post, destination: @escaping () -> Destination) {
        self.post = post
        self.destination = destination
    }

    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            ZStack(alignment: .topLeading) {
                if let coverImage = post.coverImage, coverImage != "" {
                    KFImage(URL(string: coverImage))
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(.black)
                        .opacity(0.3))
                } else {
                    Assets.Default.profileBackground.image
                        .resizable()
                        .scaledToFill()
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                        .foregroundColor(.black)
                        .opacity(0.3))
                }

                VStack(alignment: .leading) {
                    HStack { Spacer() }

                    HStack (alignment: .center) {
                        Assets.Symbol.white.image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 12, height: 12)
                        Text("\(post.boardId)")
                            .font(.system(size: 14))
                    }
                    let location = LocalizedString.location
                    if location == "ko" {
                        Text(post.title)
                            .font(.system(size: 20, weight: .bold))
                    } else {
                        Text(post.translatedTitles[location] ?? post.title)
                            .font(.system(size: 20, weight: .bold))
                    }
                }
                    .foregroundColor(.white)
                    .padding(.vertical, 5)
                    .padding(.horizontal, 15)
            }
        }
    }
}

public struct SFOMHeader: View {
    var title: String
    var mainTitle: String
    var subTitle: String

    init(title: String, mainTitle: String, subTitle: String) {
        self.title = title
        self.mainTitle = mainTitle
        self.subTitle = subTitle
    }

    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.SFOMTitleFont)
            Text(mainTitle)
                .font(.SFOMLargeTitleFont)
            Text(subTitle)
                .font(.SFOMSmallFont)

        }
    }
}

public struct SFOMMarkdownText: View {
    var content: AttributedString

    init(_ content: String) {
        let attributedString = try! AttributedString(markdown: content, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace))
        self.content = attributedString
    }

    public var body: some View {
        return Text(content)
    }
}

public struct SFOMTextField: View {
    var content: String
    @Binding var text: String
    var secure: Bool

    init(content: String, text: Binding<String>, secure: Bool = false) {
        self.content = content
        self._text = text
        self.secure = secure
    }

    public var body: some View {
        if secure {
            SecureField(content, text: $text)
                .autocapitalization(.none)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.lightGray), lineWidth: 1))
        } else {
            TextField(content, text: $text)
                .autocapitalization(.none)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.lightGray), lineWidth: 1))
        }
    }
}

public struct SFOMSearchBar: View {
    private let cornerRadius: CGFloat = 24

    private var placeholder: String
    @Binding private var text: String
    @Binding private var state: Bool
    private var submitAction: () -> Void

    init(placeholder: String, text: Binding<String>, state: Binding<Bool>, submitAction: @escaping () -> Void) {
        self.placeholder = placeholder
        self._text = text
        self._state = state
        self.submitAction = submitAction
    }

    public var body: some View {
        HStack (alignment: .center) {
            if state {
                Button {
                    state = false
                } label: {
                    Assets.SystemIcon.back.image
                        .font(.SFOMMediumFont)
                        .padding(.leading)
                }
            }
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .padding()
                .onSubmit {
                if text != "" {
                    state = true
                    submitAction()
                }
            }
        }
            .background(Color.searchBarColor)
            .cornerRadius(cornerRadius)
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(.black, lineWidth: 1))
            .foregroundColor(.black)
    }
}
