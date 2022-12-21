//
//  SFOMTexts.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI

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
    private let placeholder: String
    private let secure: Bool
    
    @Binding private var text: String

    init(_ placeholder: String,
         text: Binding<String>,
         secure: Bool = false) {
        self.placeholder = placeholder
        self._text = text
        self.secure = secure
    }

    public var body: some View {
        if secure {
            SecureField(placeholder, text: $text)
                .autocapitalization(.none)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.lightGray), lineWidth: 1))
        } else {
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color(.lightGray), lineWidth: 1))
        }
    }
}
