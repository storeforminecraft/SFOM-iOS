//
//  CommentsView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/26.
//

import SwiftUI

struct CommentsView: View {
    let resource: Resource
    let userComments: [UserComment]
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CommentsView_Previews: PreviewProvider {
    static var previews: some View {
        CommentsView(resource: TestResource.resource, userComments: [])
    }
}
