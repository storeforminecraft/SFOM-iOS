//
//  StringCollection.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/11/24.
//

import Foundation

protocol EnumeratedLocalized {
    var rawValue: String { get }
}

extension EnumeratedLocalized {
    var localized: String {
        NSLocalizedString(self.rawValue.capitalizingFirstLetter, comment: "")
    }
}

public struct StringCollection {
    private init() { }
    static let location = "Location".localizedString
    
    public enum `Default`: String, EnumeratedLocalized {
        case app
        case homeTitle
        case signIn
        case confirm
        case cancel
        case back
    }
    
    enum Category: String, EnumeratedLocalized {
        case map
        case skin
        case script
        case seed
        case texturepack
        case mod
        case addon
        case downloads
        case unknown
    }
    
    enum AuthView: String, EnumeratedLocalized {
        case authTitle
        case authMainTitle
        case authSubTitle
        
        case authSignInButtonTitle
        case authSignUpButtonTitle
    }
    
    enum PolicyView: String, EnumeratedLocalized {
        case policyMainTitle
        case policySubTitle
        
        case require
        case agreeAll
        case privacyPolicy
        case termsOfService
        case ageCheck
        case internationalTransferOfPersonalInformation
        
        case nextStep
    }
    
    enum SignUpView: String, EnumeratedLocalized {
        case signUp
        case signUpTitle
        case signUpMainTitle
        case signUpSubTitle
        
        case signUpButtonTitle
        
        case signUpSuccess
        case signUpFail
    }
    
    enum SignInView: String, EnumeratedLocalized {
        case signIn
        case signInTitle
        case signInMainTitle
        case signInSubTitle
        
        case signInButonTitle
        
        case resetEmailButtonTitle
        
        case signInSuccess
        case signInFail
    }
    
    enum PasswordResetView: String, EnumeratedLocalized {
        case resetPassword
        case resetPasswordSuccess
        case resetPasswordFail
    }
    
    enum ContentView: String, EnumeratedLocalized {
        case comments
        case more
        case leaveACommentAfterSignIn
        case download
        
        case pleaseLeaveAComments
        case leaveAComments
    }
    
    enum Policy: String, EnumeratedLocalized {
        case signInPolicy
        
        case privacyPolicyUrl
        case termsOfServiceUrl
        case internationalTransferOfPersonalInformationUrl
    }
    
    enum Auth: String, EnumeratedLocalized {
        case email
        case password
        case passwordConfirm
        case userName
    }
    
    enum SearchView: String, EnumeratedLocalized {
        case searchTitle
        case searchPlaceholder
    }
    
    enum DetailCategory: String, EnumeratedLocalized {
        case selectCategory
        
        case all
        
        case building
        case content
        case escape
        case land
        case pvp
        case adventure
        
        case boys
        case girls
        case characters
        case games
        case animal
        
        case mountain
        case cave
        case island
        case plain
        
        case kind16x16 = "16x16"
        case kind32x32 = "32x32"
        case kind64x64 = "64x64"
        case kind128x128 = "128x128"
        case shaders
    }
    
    enum Time: String, EnumeratedLocalized {
        case ago
        case minutes
        case hours
        case days
        case years
        case aMinute
        case anHour
        case aDay
        case aYear
    }
    
    enum MoreMenu: String, EnumeratedLocalized {
        case download
        case notice
        case settings
        case myComments
        case signOut
        
        case signOutSuccess
        case signOutFail
    }
    
    enum ETC: String, EnumeratedLocalized {
        case leftAComment
        case signOutMessage
        case count
        case userSuffix
    }
    
    enum Report: String, EnumeratedLocalized {
        case report
        case reportTitle
        case reportDescription
        case reportSubDescription
        
        case reportMessageDescription
        case reportA1
        case reportA2
        case reportA3
        case reportA4
        case reportA5
        case reportA6
        case reportA7
    }
    
    enum ContentStudio: String, EnumeratedLocalized {
        case contentStudio
        case upload
        case todayDownloads
        case todayLikes
        case todayComments
    }
    
    enum Order: String, EnumeratedLocalized {
        case newest
        case daily
        case monthly
    }
}
