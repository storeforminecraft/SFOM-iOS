//
//  CategoryView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI

final class CategoryViewModel: ViewModel {
    
}

struct CategoryView: View {
    @Environment(\.dismiss) var dismiss
    let category: SFOMCategory
    @State var selectedIndex: Int = 0
    
    var body: some View {
        VStack (alignment: .leading){
            HStack(alignment: .center) {
                SFOMSelectedButton("최신순", tag: 0, selectedIndex: $selectedIndex)
                SFOMSelectedButton("주간", tag: 1, selectedIndex: $selectedIndex)
                SFOMSelectedButton("월간", tag: 2, selectedIndex: $selectedIndex)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                } label: {
                    HStack(spacing: 2){
                        Group {
                            Image(systemName: "chevron.backward")
                                .font(.SFOMSmallFont.bold())
                            Text(self.category.localized)
                                .font(.SFOMMediumFont.bold())
                        }
                        .foregroundColor(.black)
                        
                    }
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    
                } label: {
                    Text("all")
                }
            }
        }
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .addon)
    }
}


public struct SFOMCategoryItemView: View{
    private let i: Int
    
    init(i: Int) {
        self.i = i
    }
    
    public var body: some View {
        NavigationLink {
            
        } label: {
            VStack(alignment: .leading) {
                SFOMImage(placeholder: Assets.Default.profileBackground.image,
                          urlString: nil)
                .aspectRatio(1.7, contentMode: .fit)
                .padding(.bottom,4)
                .frame(height: 100)
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("\(i)번째 데이터")
                        .font(.SFOMExtraSmallFont)
                        .foregroundColor(.black)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .frame(height: 30, alignment: .top)
                    
                    HStack (spacing: 0) {
                        Image(systemName: "hand.thumbsup.fill")
                            .font(.SFOMExtraSmallFont)
                            .foregroundColor(.accentColor)
                        Group {
                            Text("\(10)")
                                .padding(.trailing,4)
                            Text("\(20)\(StringCollection.ETC.count.localized)")
                        }
                        .font(.SFOMExtraSmallFont)
                        .foregroundColor(Color(.lightGray))
                        .lineLimit(1)
                    }
                }
                .padding(.horizontal, 6)
                .padding(.bottom,8)
            }
            .background(Color(.white))
            .cornerRadius(12)
            .shadow(color: Color(.lightGray),
                    radius: 2, x: 0, y: 2)
        }
    }
}
