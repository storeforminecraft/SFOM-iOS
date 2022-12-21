//
//  Localized.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import Foundation

public struct Localized {
    private init() { }
    static let location: String = "location".localized
    static let app: String = "APP".localized
    static let homeTitle: String = "HomeTitle".localized
    static let signIn: String = "SignIn".localized

    static let back = "Back".localized

    public struct Category {
        private init() { }
        static let map = "Map".localized
        static let skin = "Skin".localized
        static let script = "Script".localized
        static let seed = "Seed".localized
        static let texturepack = "Texturepack".localized
        static let mod = "Mod".localized
        static let addon = "Addon".localized
        static let downloads = "Downloads".localized
        static let unknown = "Unknown".localized
    }

    public struct AuthView {
        private init() { }
        static let authTitle = "AuthTitle".localized
        static let authMainTitle = "AuthMainTitle".localized
        static let authSubTitle = "AuthSubTitle".localized

        static let authSignInButtonTitle = "AuthSignInButtonTitle".localized
        static let authSignUpButtonTitle = "AuthSignUpButtonTitle".localized
    }
    
    public struct PolicyView {
        private init() { }
        static let policyMainTitle = "PolicyMainTitle".localized
        static let policySubTitle = "PolicySubTitle".localized

        static let require = "Require".localized
        static let agreeAll = "AgreeAll".localized
        static let privacyPolicy = "PrivacyPolicy".localized
        static let termsOfService = "TermsOfService".localized
        static let ageCheck = "AgeCheck".localized
        static let internationalTransferOfPersonalInformation = "InternationalTransferOfPersonalInformation".localized
        
        static let nextStep = "NextStep".localized
    }

    public struct SignUpView {
        private init() { }
        static let signUpTitle = "SignUpTitle".localized
        static let signUpMainTitle = "SignUpMainTitle".localized
        static let signUpSubTitle = "SignUpSubTitle".localized

        static let signUpButtonTitle = "SignUpButtonTitle".localized
    }

    public struct SignInView {
        private init() { }
        static let signInTitle = "SignInTitle".localized
        static let signInMainTitle = "SignInMainTitle".localized
        static let signInSubTitle = "SignInSubTitle".localized

        static let signInButonTitle = "SignInButonTitle".localized

        static let resetEmailButtonTitle = "ResetEmailButtonTitle".localized
    }

    public struct Policy {
        private init() { }
        static let signInPolicy = "SignInPolicy".localized
        
        static let privacyPolicyUrl = "PrivacyPolicyUrl".localized
        static let termsOfServiceUrl = "TermsOfServiceUrl".localized
        static let internationalTransferOfPersonalInformationUrl = "InternationalTransferOfPersonalInformationUrl".localized
    }

    public struct Auth {
        private init() { }
        static let email = "Email".localized
        static let password = "Password".localized
        static let passwordConfirm = "PasswordConfrim".localized
        static let userName = "UserName".localized
    }

    public struct SearchView {
        private init() { }
        static let searchTitle = "SearchTitle".localized
        static let searchPlaceholder = "SearchPlaceholder".localized
    }

    public struct DetailCategory {
        private init() { }
        static let selectCategory = "SelectCategory".localized

        static let all = "All".localized

        static let building = "Building".localized
        static let content = "Content".localized
        static let escape = "Escape".localized
        static let land = "Land".localized
        static let pvp = "Pvp".localized
        static let adventure = "Adventure".localized

        static let boys = "Boys".localized
        static let girls = "Girls".localized
        static let characters = "Characters".localized
        static let games = "Games".localized
        static let animal = "Animal".localized

        static let mountain = "Mountain".localized
        static let cave = "Cave".localized
        static let island = "Island".localized
        static let plain = "Plain".localized

        static let kind16x16 = "16x16".localized
        static let kind32x32 = "32x32".localized
        static let kind64x64 = "64x64".localized
        static let kind128x128 = "128x128".localized
        static let shaders = "Shaders".localized
    }
    
    public struct Time {
        private init() { }
        static let ago = "Ago".localized
        static let minutes = "Minutes".localized
        static let hours = "Hours".localized
        static let days = "Days".localized
        static let aMinute = "AMinute".localized
        static let anHour = "AnHour".localized
        static let aDay = "ADay".localized
    }
    
    public struct MoreMenu {
        private init() { }
        static let download = "Download".localized
        static let notice = "Notice".localized
        static let settings = "Settings".localized
        static let myComments = "MyComments".localized
        static let signOut = "SignOut".localized
    }
    
    public struct ETC {
        private init() { }
        static let leftAComment = "LeftAComment".localized
        static let signOutMessage = "SignOutMessage".localized
        static let count = "Count".localized
    }
    
    public struct ContentStudio {
        private init() { }
        static let contentStudio = "ContentStudio".localized
        static let upload = "Upload".localized
        static let todayDownloads = "TodayDownloads".localized
        static let todayLikes = "TodayLikes".localized
        static let todayComments = "TodayComments".localized
    }
}
