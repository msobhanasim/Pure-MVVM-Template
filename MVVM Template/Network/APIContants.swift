
//
//  APIConstants.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation

internal struct APIConstants {
    
    // MARK: - Live Credentials
    
     static let BasePath = "https://<<YOUR-BASE-PATH>>/api/"
     
    // MARK: - Test Credentials
//    static let BasePath = "https://beta.<<YOUR-BASE-PATH>>/api/"
    
    // MARK: - Google Credentials
    
    static let GOOGLE_SENDER_ID = "<<GOOGLE_SENDER_ID>>"
    static let GOOGLE_APP_ID = "<<GOOGLE_APP_ID>>"
    static let GOOGLE_API_KEY = "<<GOOGLE_API_KEY>>"
    static let BUNDLE_ID = "<<BUNDLE_ID>>"
    static let PROJECT_ID = "<<PROJECT_ID>>"
    static let GOOGLE_CLIENT_ID = "<<GOOGLE_CLIENT_ID>>"
    
}

enum SocialAccountType: String {
    case AccountLogin = "n"
    case Facebook = "f"
    case Goole = "g"
}

internal struct APIPaths {
    
    // MARK: Auth Module API Paths
    
    static let login  = "login"
    static let signUp = "signupCustomer"
    static let logout = "logout"
    
    //...
}
