//
//  ItemView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/03.
//

import SwiftUI

public struct SFOMPostItemView<Destination>: View where Destination: View {
    private let post: Post
    private let height: CGFloat
    private let aspectRatio: CGFloat
    @ViewBuilder private var destination:() -> Destination
    
    init(post: Post,
         height: CGFloat = 200,
         aspectRatio:CGFloat = 1.7,
         @ViewBuilder destination: @escaping () -> Destination) {
        self.post = post
        self.height = height
        self.aspectRatio = aspectRatio
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            ZStack(alignment: .topLeading) {
                if let coverImage = post.coverImage, coverImage != "" {
                    SFOMImage(urlString: coverImage)
                        .cornerRadius(14)
                        .overlay(RoundedRectangle(cornerRadius: 14)
                            .foregroundColor(.black)
                            .opacity(0.3))
                } else {
                    Assets.Default.profileBackground.image
                        .resizable()
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
                    Text(post.localizedTitle)
                        .font(.system(size: 20, weight: .bold))
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    
                }
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 15)
            }
            .frame(height: height)
            .aspectRatio(aspectRatio, contentMode: .fit)
        }
        
    }
}

public struct SFOMSearchItemView<Destination>: View where Destination: View {
    private var resource: Resource
    private var width: CGFloat
    @ViewBuilder private var destination: () -> Destination
    
    var imageHeight: CGFloat {
        return width * 0.6
    }
    
    init(resource: Resource, width: CGFloat, @ViewBuilder destination: @escaping () -> Destination) {
        self.resource = resource
        self.width = width
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink {
            destination()
        } label: {
            VStack (alignment: .leading) {
                SFOMSkinImage(defaultImage: Assets.Default.profileBackground.image,
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

public struct SFOMRecentCommentItemView<Destination>: View where Destination: View {
    private let recentComment: RecentComment
    @ViewBuilder private var destination: () -> Destination
    
    init(recentComment: RecentComment, @ViewBuilder destination: @escaping () -> Destination) {
        self.recentComment = recentComment
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink{
            destination()
        } label: {
            VStack(alignment: .leading){
                HStack{
                    Group {
                        if let thumbnail = recentComment.resource.thumbnail {
                            SFOMImage(urlString: thumbnail)
                        } else {
                            Assets.Default.profileBackground.image
                        }
                    }
                    .frame(width: 30, height: 30)
                    .cornerRadius(15)
                    
                    Text(recentComment.resource.localizedName)
                        .font(.SFOMSmallFont.bold())
                        .lineLimit(1)
                        .foregroundColor(.black)
                }
                
                HStack (spacing: 0) {
                    Group {
                        if let thumbnail = recentComment.user.thumbnail {
                            SFOMImage(urlString: thumbnail)
                        } else {
                            Assets.Default.profile.image
                                .resizable()
                        }
                    }
                    .frame(width: 15, height: 15)
                    .cornerRadius(12.5)
                    .padding(.horizontal,5)
                    
                    Group{
                        Text("\(recentComment.user.summary)")
                            .font(.SFOMExtraSmallFont.bold())
                        Text(Localized.ETC.leftAComment)
                            .font(.SFOMExtraSmallFont)
                    }
                    .lineLimit(1)
                    .foregroundColor(Color(.darkGray))
                    
                }
                
                Text("\"\(recentComment.comment.content)\"")
                    .font(.SFOMExtraSmallFont.bold())
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.black)
                
                VStack(alignment: .trailing){
                    Text(recentComment.createdTime.ago())
                        .font(.SFOMExtraSmallFont)
                        .lineLimit(1)
                        .foregroundColor(Color(.lightGray))
                        .padding(5)
                    HStack{ Spacer() }
                }
                Divider()
            }
            .padding(.bottom)
        }
    }
}

public struct SFOMListItemLinkView<Destination>: View where Destination: View  {
    private let moreMenu: SFOMMoreMenu
    @ViewBuilder private var destination: () -> Destination
    
    init(moreMenu: SFOMMoreMenu, @ViewBuilder destination: @escaping () -> Destination) {
        self.moreMenu = moreMenu
        self.destination = destination
    }
    
    public var body: some View {
        NavigationLink{
            destination()
        } label: {
            HStack {
                moreMenu.assets.image
                Text(moreMenu.localized)
                    .font(.SFOMSmallFont.bold())
            }
        }
    }
}

public struct SFOMListItemView: View {
    private let moreMenu: SFOMMoreMenu
    private let completion: () -> Void
    
    init(moreMenu: SFOMMoreMenu,completion: @escaping () -> Void) {
        self.moreMenu = moreMenu
        self.completion = completion
    }
    
    public var body: some View {
        Button {
            completion()
        } label: {
            HStack {
                moreMenu.assets.image
                Text(moreMenu.localized)
                    .font(.SFOMSmallFont.bold())
            }
        }
    }
}

public struct SFOMNoticeItemView: View {
    private let notice: String
    @State private var showingContent: Bool = false
    
    init(notice: String) {
        self.notice = notice
    }
    
    public var body: some View {
        Button {
            showingContent.toggle()
        } label: {
            HStack {
              
            }
        }
    }
}
