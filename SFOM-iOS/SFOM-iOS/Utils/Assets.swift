//
//  Assets.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/18.
//

import SwiftUI

struct Assets {
    public enum `default`: String {
        case profile
        case profileBackground
        case gradientBackground

        var image: Image { Image("defaultImage_\(self.rawValue)") }
    }

    public enum menu: String {
        case addon
        case downloads
        case map
        case mod
        case script
        case seed
        case skin
        case texturepack

        var tintColor: Color {
            switch self {
            case .downloads:
                return Color(red: 96 / 255, green: 125 / 255, blue: 139 / 255)
            default:
                return .white
            }
        }

        var image: Image {
            Image("ic_mainbutton_\(self.rawValue)")
        }

        var backgroundColor: Color {
            return Color("ic_mainbutton_\(self.rawValue)_color")
        }
    }

    public enum tabBar: String {
        case home
        case menu
        case search
        case chat

        var image: Image {
            Image("ic_tabbar_\(self.rawValue)")
        }
    }

}
