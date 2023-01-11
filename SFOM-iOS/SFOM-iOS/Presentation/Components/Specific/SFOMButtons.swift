//
//  SFOMComponents.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/21.
//

import SwiftUI

public struct SFOMButton: View {
    private let content: String
    private let foregroundColor: Color
    private let backgroundColor: Color
    private let spacer: Bool
    private let font: Font
    private let action: () -> Void
    

    
    public init<S>(_ content: S,
                   foregroundColor: Color = Color.white,
                   backgroundColor: Color = Color.accentColor,
                   spacer: Bool = true,
                   font: Font = .body.bold(),
                   action: @escaping () -> Void
    ) where S: StringProtocol {
        self.content = content as? String ?? ""
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
        self.spacer = spacer
        self.font = font
        self.action = action
    }
    
    
    public init<S>(_ content: S,
                   accent: Bool = true,
                   spacer: Bool = true,
                   font: Font = .body.bold(),
                   action: @escaping () -> Void
    ) where S: StringProtocol {
        self.content = content as? String ?? ""
        self.foregroundColor = accent ? Color.white : Color.accentColor
        self.backgroundColor = accent ? Color.accentColor : Color.accentColor.opacity(0.2)
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
                .padding(.vertical, 10)
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(24)
            } else {
                Text(content)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 22)
                    .font(font)
                    .foregroundColor(foregroundColor)
                    .background(backgroundColor)
                    .cornerRadius(24)
            }
        }
    }
}


public struct SFOMAuthButton: View {
    private let content: String
    private let foregroundColor: Color
    private let backgroundColor: Color
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
        self.foregroundColor = accent ? Color.white : Color.accentColor
        self.backgroundColor = accent ? Color.accentColor : Color.accentColor.opacity(0.2)
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
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .cornerRadius(12)
            } else {
                Text(content)
                    .padding(.vertical, 4)
                    .padding(.horizontal)
                    .font(font)
                    .foregroundColor(foregroundColor)
                    .background(backgroundColor)
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

public struct SFOMSelectedButton: View {
    @Binding var selectedIndex: Int
    private let content: String
    private let tag: Int
    
    public init<S>(_ content: S, tag: Int, selectedIndex: Binding<Int>) where S: StringProtocol {
        self.content = content as? String ?? ""
        self.tag = tag
        self._selectedIndex = selectedIndex
    }
    
    public var body: some View {
        Button {
            selectedIndex = tag
        } label: {
            Text(content)
                .font(.SFOMFont10.bold())
                .foregroundColor(selectedIndex == tag ? .white : .textPrimaryColor)
                .padding(.vertical, 6)
                .padding(.horizontal, 6)
                .background(selectedIndex == tag ? Color.textPrimaryColor : Color.clear)
                .cornerRadius(12)
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
                    .resizable()
                    .frame(width: 18, height: 18)
                Text(StringCollection.Default.back.localized)
                    .font(.SFOMSmallFont)
            }
        }
    }
}

public struct SFOMCheckButton: View {
    @Environment(\.openURL) var openURL
    
    private let kind: String?
    private let content: String
    private let urlString: String?
    @Binding private var check: Bool
    
    init(content: String, kind: String? = nil, urlString: String? = nil, check: Binding<Bool>) {
        self.kind = kind
        self.content = content
        self.urlString = urlString
        self._check = check
    }
    
    public var body: some View {
        Button {
            check.toggle()
        } label: {
            HStack {
                if let kind = kind {
                    Text(kind)
                        .font(.SFOMSmallFont.bold())
                        .foregroundColor(.red)
                }
                
                HStack (spacing: 2){
                    Text(content)
                        .font(.SFOMExtraSmallFont.bold())
                        .foregroundColor(.black)
                    
                    if let urlString = urlString, let url = URL(string: urlString) {
                        Button {
                            openURL(url)
                        } label: {
                            Image(systemName: "chevron.right")
                                .font(.SFOMExtraSmallFont.bold())
                                .foregroundColor(Color(.lightGray))
                        }
                    }
                }
                
                Spacer()
                
                if check {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.SFOMSmallFont)
                        .foregroundColor(.accentColor)
                } else {
                    Image(systemName: "checkmark.circle")
                        .font(.SFOMSmallFont)
                        .foregroundColor(Color(.darkGray))
                }
            }
        }
        .padding()
        .cornerRadius(18)
        .background {
            if check {
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(.white)
                    .shadow(color: Color(.lightGray), radius: 2, x: 0, y: 2)
            }
        }
        .overlay {
            if !check {
                RoundedRectangle(cornerRadius: 18)
                    .stroke(lineWidth: 1)
                    .foregroundColor(Color(.lightGray))
            }
        }
        
    }
}

public struct SFOMDownloadButton: View {
    private let content: String
    private let font: Font
    private let action: () -> Void
    
    public init<S>(_ content: S,
                   font: Font = .body.bold(),
                   action: @escaping () -> Void)
    where S: StringProtocol {
        self.content = content as? String ?? ""
        self.font = font
        self.action = action
    }
    
    public var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 5) {
                Spacer()
                Group {
                    Assets.MoreMenu.download.image
                        .blendMode(.hardLight)
                    Text(content)
                }
                .foregroundColor(.white)
                .font(font.bold())
                
                Spacer()
            }
            .padding()
            .foregroundColor(Color.white)
            .background(Color.accentColor)
            .cornerRadius(24)
        }
    }
}
