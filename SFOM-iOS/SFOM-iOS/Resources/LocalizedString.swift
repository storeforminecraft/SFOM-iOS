//
//  LocalizedString.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import Foundation

public struct LocalizedString {
    static let location: String = "location".localized
    static let app: String = "APP".localized
    static let homeTitle: String = "HomeTitle".localized
    static let signIn: String = "SignIn".localized

    static let back = "Back".localized

    public struct menu {
        static let map = "Map".localized
        static let skin = "Skin".localized
        static let Script = "Script".localized
        static let Seed = "Seed".localized
        static let Texturepack = "Texturepack".localized
        static let Mod = "Mod".localized
        static let Addon = "Addon".localized
        static let Downloads = "Downloads".localized
    }

    public struct AuthView {
        static let AuthTitle = "AuthTitle".localized
        static let AuthMainTitle = "AuthMainTitle".localized
        static let AuthSubTitle = "AuthSubTitle".localized

        static let AuthSignInButtonTitle = "AuthSignInButtonTitle".localized
        static let AuthSignUpButtonTitle = "AuthSignUpButtonTitle".localized
    }

    public struct SignUpView {
        static let SignUpTitle = "SignUpTitle".localized
        static let SignUpMainTitle = "SignUpMainTitle".localized
        static let SignUpSubTitle = "SignUpSubTitle".localized

        static let SignUpButtonTitle = "SignUpButtonTitle".localized
    }

    public struct SignInView {
        static let SignInTitle = "SignInTitle".localized
        static let SignInMainTitle = "SignInMainTitle".localized
        static let SignInSubTitle = "SignInSubTitle".localized

        static let SignInButonTitle = "SignInButonTitle".localized

        static let ResetEmailButtonTitle = "ResetEmailButtonTitle".localized
    }

    public struct Policy {
        static let Policy1 = "Policy1".localized
        static let Policy2 = "Policy2".localized
    }

    public struct Auth {
        static let Email = "Email".localized
        static let Password = "Password".localized
        static let PasswordConfrim = "PasswordConfrim".localized
        static let UserName = "UserName".localized
    }

    public struct Category {
        static let SelectCategory = "SelectCategory".localized

        static let All = "All".localized

        static let Building = "Building".localized
        static let Content = "Content".localized
        static let Escape = "Escape".localized
        static let Land = "Land".localized
        static let Pvp = "Pvp".localized
        static let Adventure = "Adventure".localized

        static let Boys = "Boys".localized
        static let Girls = "Girls".localized
        static let Characters = "Characters".localized
        static let Games = "Games".localized
        static let Animal = "Animal".localized

        static let Mountain = "Mountain".localized
        static let Cave = "Cave".localized
        static let Island = "Island".localized
        static let Plain = "Plain".localized

        static let kind16x16 = "16x16".localized
        static let kind32x32 = "32x32".localized
        static let kind64x64 = "64x64".localized
        static let kind128x128 = "128x128".localized
        static let Shaders = "Shaders".localized
    }
}
