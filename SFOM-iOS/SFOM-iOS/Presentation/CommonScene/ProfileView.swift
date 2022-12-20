//
//  ProfileView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import SwiftUI

struct ProfileView: View {
    let uid: String

    var body: some View {
        Text("\(uid) profile View")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(uid: "11111")
    }
}
