//
//  CategoryView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI

// FIXME: - 
struct CategoryView: View {
    let category: SFOMCategory
    
    var body: some View {
        Text("\(category.localized) categoryView")
    }
}

struct CategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryView(category: .addon)
    }
}
