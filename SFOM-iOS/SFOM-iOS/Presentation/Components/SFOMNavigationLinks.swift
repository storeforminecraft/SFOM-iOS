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
                          isSkin: userResource.resource.isSkin)
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
    private let category: SFOMCategory
    private let imageFrame: CGFloat
    private let frame: CGFloat
    private let imagePadding: CGFloat
    @ViewBuilder private var destination:() -> Destination
    
    init(category: SFOMCategory,
         imageFrame: CGFloat = 18,
         frame: CGFloat = 48,
         imagePadding: CGFloat? = 15,
         @ViewBuilder destination: @escaping () -> Destination) {
        self.category = category
        self.imageFrame = imageFrame
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
            VStack (alignment: .center, spacing: 10) {
                category.assets.image
                    .resizable()
                    .frame(width: self.imageFrame, height: self.imageFrame)
                    .aspectRatio(contentMode: .fit)
                    .colorMultiply(category.assets.tintColor)
                    .padding(imagePadding)
                    .background(category.assets.backgroundColor)
                    .frame(width: self.frame, height: self.frame)
                    .cornerRadius(self.frame)
                Text(category.localized)
                    .font(.SFOMFont12)
                    .foregroundColor(.gray)
            }
        }
    }
}

public struct SFOMSignInLink<Destination, SubDestination>: View
where Destination: View, SubDestination: View {
    @Binding private var user: User?
    private let circle: CGFloat
    private let showNickname: Bool
    @ViewBuilder private var authDestination: () -> Destination
    @ViewBuilder private var noAuthDestination:() -> SubDestination
    
    init(user: Binding<User?>,
         circle: CGFloat = 32,
         showNickname: Bool = false,
         @ViewBuilder auth authDestination: @escaping () -> Destination,
         @ViewBuilder noAuth noAuthDestination: @escaping () -> SubDestination) {
        self._user = user
        self.circle = circle
        self.showNickname = showNickname
        self.authDestination = authDestination
        self.noAuthDestination = noAuthDestination
    }
    
    public var body: some View {
        HStack (alignment: .center){
            if let user = user {
                NavigationLink {
                    authDestination()
                } label: {
                    Assets.Default.profile.image
                        .resizable()
                        .frame(width: circle, height: circle)
                        .cornerRadius(circle / 2)
                    if showNickname {
                        Text(user.nickname)
                            .font(.SFOMFont18.bold())
                            .foregroundColor(.textPrimaryColor)
                            .padding(.leading, 8)
                        if StringCollection.location == "ko" {
                            Text("님")
                                .font(.SFOMFont18)
                                .foregroundColor(.textPrimaryColor)
                                .padding(.leading, 3)
                        }
                    }
                }
            } else {
                NavigationLink {
                    noAuthDestination()
                } label: {
                    Text(StringCollection.Default.signIn.localized)
                        .font(.SFOMFont10.bold())
                        .padding(.vertical, 5)
                        .padding(.horizontal, 12)
                        .frame(width: 52, height: 24)
                        .foregroundColor(.white)
                        .background(Color.accentColor)
                        .cornerRadius(12)
                }
            }
        }
        .frame(height: 32)
    }
}
