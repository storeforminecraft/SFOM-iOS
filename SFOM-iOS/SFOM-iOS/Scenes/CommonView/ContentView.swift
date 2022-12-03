//
//  ContentView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/02.
//

import SwiftUI

struct ContentView: View {
    let resource: Resource

    var body: some View {
        VStack {
            Text(resource.category)
            Text(resource.thumb ?? "nil")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(resource: Resource(authorUid: "", basedLanguage: "", category: "", chidCommentsCount: 0, createdTimestamp: Date(), desc: "", downloadCount: 0, fileExt: "", fileHash: "", id: "", images: [], likeCount: 0, name: "", modifiedTimestamp: Date(), state: "", tags: [], translatedDescs: [:], translatedNames: [:], translationSource: "", version: 0))
    }
}
