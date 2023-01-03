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

        var image: Image { Image("sfom_symbol_\(self.rawValue)").resizable() }
    }

    public enum `Default`: String {
        case profile
        case profileBackground
        case gradientBackground

        var image: Image { Image("defaultImage_\(self.rawValue)").resizable() }
    }

    public enum Category: String {
        case addon
        case downloads
        case map
        case mod
        case script
        case seed
        case skin
        case texturepack
        case unknown

        var tintColor: Color {
            switch self {
            case .downloads:
                return Color(red: 96 / 255, green: 125 / 255, blue: 139 / 255)
            default:
                return .white
            }
        }

        var image: Image {
            Image("ic_mainbutton_\(self.rawValue)").resizable()
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
            Image("ic_tabbar_\(self.rawValue)").resizable()
        }
    }

    public enum MoreMenu: String {
        case download
        case notice
        case settings
        case myComments
        case signOut
        case push

        var image: Image {
            switch self {
            case .settings,.myComments: return Image("ic_moremenu_preference")
            default: return Image("ic_moremenu_\(self.rawValue.lowercased())")
            }
        }

    }

    public enum SystemIcon: String {
        case backCircle = "arrow.backward.circle"
        case back = "chevron.backward"

        var image: Image { Image(systemName: self.rawValue) }
    }

}
