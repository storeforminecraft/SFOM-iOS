//
//  RadioBox.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/11.
//

import SwiftUI

struct RadioBox: View {
    @Binding private var selectedIndex: Int
    private let contentList: [String]
    
    init(_ selected: Binding<Int>, contentList: [String]) {
        self._selectedIndex = selected
        self.contentList = contentList
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach((0..<self.contentList.count), id: \.self) { tag in
                Button {
                    selectedIndex = tag
                } label: {
                    HStack {
                        if selectedIndex != tag {
                            Image(systemName: "circle")
                                .foregroundStyle(.black)
                                .font(.SFOMFont14)
                        } else {
                            Image(systemName: "circle.inset.filled")
                                .font(.SFOMFont14)
                                .foregroundStyle(Color.accentColor, .black)
                        }
                        Text(contentList[tag])
                            .font(.SFOMFont14)
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct RadioBox_Previews: PreviewProvider {
    static var previews: some View {
        RadioBox(.constant(0), contentList: SFOMReports.list.map { $0.description })
    }
}
