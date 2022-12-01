//
//  Assets.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/18.
//

import SwiftUI

struct Assets {
    public enum Symbol: String {
        case `default`
        case white

        var image: Image { Image("sfom_symbol_\(self.rawValue)") }
    }

    public enum `Default`: String {
        case profile
        case profileBackground
        case gradientBackground

        var image: Image { Image("defaultImage_\(self.rawValue)") }
    }

    public enum Menu: String {
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

    public enum TabBar: String {
        case home
        case menu
        case search
        case chat

        var image: Image {
            Image("ic_tabbar_\(self.rawValue)")
        }
    }

    public enum MoreMenu: String {
        case downloads
        case preference
        case notice
        case signout
        case notificationActive
        case push

        var image: Image {
            Image("ic_moremenu_\(self.rawValue)")
        }

    }

    public enum SystemIcon: String {
        case backCircle = "arrow.backward.circle"
        case back = "chevron.backward"

        var image: Image { Image(systemName: self.rawValue) }
    }

}
