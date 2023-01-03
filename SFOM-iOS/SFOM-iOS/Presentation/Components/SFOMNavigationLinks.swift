//
//  SFOMNavigationLink.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import SwiftUI

public struct SFOMNavigationLink<Destination>: View where Destination: View {
    private let content: String
    private let accent: Bool
    private let spacer: Bool
    private let font: Font
    @ViewBuilder var destination:() -> Destination
    
    public init<S>(_ content: S,
                   accent: Bool = true,
                   spacer: Bool = true,
                   font: Font = .body.bold(),
                   @ViewBuilder destination: @escaping () -> Destination
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

public struct UserInfoLink<Destination>: View where Destination: View {
    private let user: User
    @ViewBuilder private let destination:() -> Destination
    init(user: User, destination: @escaping () -> Destination) {
        self.user = user
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack (alignment: .center, spacing: 10) {
                SFOMImage(placeholder: Assets.Default.profile.image,
                          urlString: user.thumbnail)
                .frame(width: 30, height: 30)
                .cornerRadius(30)
                
                VStack(alignment: .leading, spacing: 0){
                    Text(user.nickname.strip)
                        .font(.SFOMExtraSmallFont.bold())
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text(user.uid.prefix(6))
                        .font(.SFOMExtraSmallFont)
                        .foregroundColor(Color(.darkGray))
                        .lineLimit(1)
                    HStack { Spacer() }
                }
            }
        }
    }
}


public struct ResourceLinearLink<Destination>: View where Destination: View {
    private let userResource: UserResource
    @ViewBuilder private let destination:() -> Destination
    init(userResource: UserResource, destination: @escaping () -> Destination) {
        self.userResource = userResource
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            HStack (alignment: .center, spacing: 10) {
                SFOMImage(placeholder: Assets.Default.profileBackground.image,
                          urlString: userResource.resource.thumbnail,
                          searchSkin: userResource.resource.isSkin ? true  : nil)
                .frame(width: 40, height: 40)
                .cornerRadius(8)
                VStack(alignment: .leading){
                    Text(userResource.resource.localizedName.strip)
                        .font(.SFOMSmallFont)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                    Text(userResource.user.summary)
                        .font(.SFOMExtraSmallFont)
                        .foregroundColor(Color(.lightGray))
                        .multilineTextAlignment(.leading)
                        .lineLimit(1)
                }
                Spacer()
            }
        }
    }
}

public struct SFOMCategoryTapView<Destination>: View where Destination: View {
    let category: SFOMCategory
    let frame: CGFloat
    let imagePadding: CGFloat
    @ViewBuilder var destination:() -> Destination
    
    init(category: SFOMCategory,
         frame: CGFloat = 18,
         imagePadding: CGFloat? = nil,
         @ViewBuilder destination: @escaping () -> Destination) {
        self.category = category
        self.frame = frame
        if let imagePadding = imagePadding {
            self.imagePadding = imagePadding
        } else {
            self.imagePadding = frame / 10 * 8
        }
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            VStack (alignment: .center) {
                category.assets.image
                    .resizable()
                    .frame(width: self.frame, height: self.frame)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(category.assets.tintColor)
                    .padding(imagePadding)
                    .background(category.assets.backgroundColor)
                    .cornerRadius(self.frame + imagePadding)
                
                Text(category.localized)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}
