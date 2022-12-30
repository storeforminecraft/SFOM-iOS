//
//  SFOM_iOSApp.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/18.
//

import SwiftUI

@main
struct SFOM_iOSApp: App {
    let appContainer = AppContainer.shared.authRepository
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
