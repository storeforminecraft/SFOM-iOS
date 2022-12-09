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
    var width: CGFloat
    var destination: () -> Destination

    var imageHeight: CGFloat {
        return width * 0.6
    }

    init(resource: Resource, width: CGFloat, destination: @escaping () -> Destination) {
        self.resource = resource
        self.width = width
        self.destination = destination
    }

    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            VStack (alignment: .leading) {
                SFOMImage(defaultImage: Assets.Default.profileBackground.image,
                          category: resource.category,
                          urlStr: resource.thumbnail,
                          search: true)
                    .frame(width: width, height: imageHeight)
                    .scaledToFill()
                    .cornerRadius(16)

                VStack(alignment: .leading) {
                    Text(resource.name)
                        .lineLimit(2)
                        .font(.SFOMSmallFont)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.black)
                        .frame(height: 45)

                    HStack(spacing: 10) {
                        Group {
                            HStack (spacing: 2) {
                                Image(systemName: "hand.thumbsup.fill")
                                    .foregroundColor(Color.accentColor)
                                Text("\(resource.likeCount)")
                            }
                            Text("\(resource.downloadCount) hits")
                        }
                            .font(.SFOMExtraSmallFont)
                            .foregroundColor(.gray)
                            .frame(height: 20)
                    }
                }
                    .padding(.horizontal)
            }
        }
    }
}
