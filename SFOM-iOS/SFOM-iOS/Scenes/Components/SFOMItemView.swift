//
//  ItemView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/03.
//

import Kingfisher
import SwiftUI

public struct SFOMPostItemView<Destination>: View where Destination: View {
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

public struct SFOMSearchItemView<Destination>: View where Destination: View {
    var resource: Resource
    var destination: () -> Destination

    init(resource: Resource, destination: @escaping () -> Destination) {
        self.resource = resource
        self.destination = destination
    }

    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            VStack (alignment: .leading) {
                Group {
                    if let thumbnail = resource.thumb, thumbnail != "" {
                        KFImage(URL(string: thumbnail))
                            .resizable()
                    } else {
                        Assets.Default.profileBackground.image
                            .resizable()
                    }
                }
                    .scaledToFit()
                    .cornerRadius(16)

                Text(resource.name)
                    .lineLimit(2)
                    .font(.SFOMSmallFont)
                    .foregroundColor(.borderColor)
                Text("\(resource.likeCount) hits")
            }
        }
    }
}
