//
//  LanguageHandler.swift
//  Zon.ae
//
//  Created by Sobhan Asim on 19/11/2021.
//

import Foundation
import UIKit

private var kBundleKey: UInt8 = 0

enum LanguageType : String {
    case english = "en"
    case arabic  = "ar"
}

class BundleEx: Bundle {
    override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        if let bundle = objc_getAssociatedObject(self, &kBundleKey) {
            return (bundle as! Bundle).localizedString(forKey: key, value: value, table: tableName)
        }
        return super.localizedString(forKey: key, value: value, table: tableName)
    }
    
}

class Language {
    
    static var sharedInstance = Language()
    
    var selectedLanguage = LanguageType.english
    
    var isScreenFlippedOnce = false
    
    var wasRTL = false
    
}

extension Bundle {
    static let once: Void = {
        object_setClass(Bundle.main, type(of: BundleEx()))
    }()
    
    class func setLanguage(lang: String?) {
        Bundle.once
        let isLanguageRTL = Bundle.isLanguageRTL(lang)
        if (isLanguageRTL) {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        } else {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        UserDefaults.standard.set(isLanguageRTL, forKey: "AppleTextDirection")
        UserDefaults.standard.set(isLanguageRTL, forKey: "NSForceRightToLeftWritingDirection")
        UserDefaults.standard.synchronize()
        
        let value = (lang != nil ? Bundle.init(path: (Bundle.main.path(forResource: lang, ofType: "lproj"))!) : nil)
        objc_setAssociatedObject(Bundle.main, &kBundleKey, value, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    class func isLanguageRTL(_ languageCode: String?) -> Bool {
        return (languageCode != nil && Locale.characterDirection(forLanguage: languageCode!) == .rightToLeft)
    }
    
}

extension AppDelegate {
    func setCurrentLanguage(){
        
        let currentLang = Localize.currentLanguage()
        switch currentLang {
        case LanguageType.arabic.rawValue:
            Language.sharedInstance.isScreenFlippedOnce = false
            Language.sharedInstance.wasRTL = true
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        case LanguageType.english.rawValue:
            Language.sharedInstance.isScreenFlippedOnce = false
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        default:
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
    }
    
    func RTL() {
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        UIButton.appearance().semanticContentAttribute = .forceRightToLeft
        UITextView.appearance().semanticContentAttribute = .forceRightToLeft
        UITextField.appearance().semanticContentAttribute = .forceRightToLeft
        UILabel.appearance().semanticContentAttribute = .forceRightToLeft
        
        
    }
    
    func LTR() {
        UIView.appearance().semanticContentAttribute = .forceLeftToRight
        UIButton.appearance().semanticContentAttribute = .forceLeftToRight
        UITextView.appearance().semanticContentAttribute = .forceLeftToRight
        UITextField.appearance().semanticContentAttribute = .forceLeftToRight
        UILabel.appearance().semanticContentAttribute = .forceLeftToRight
    }
}
