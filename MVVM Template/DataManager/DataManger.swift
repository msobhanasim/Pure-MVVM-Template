//
//  DataManger.swift
//  Clout
//
//  Created by user on 10/12/2019.
//  Copyright © 2019 CP. All rights reserved.
//


import UIKit
import CoreLocation

// This file will contain all of your NSUserDefault Keys and their Getter/Setters...

struct UserDefaultsStrings {
    static let firebaseToken = "firebaseToken"
    static let loggedIn = "loggedIn"
    static let user = "user"
}

class DataManager: NSObject {
    
    var deviceToken: String = UIDevice.current.identifierForVendor!.uuidString
    
    private override init(){}
    
    static let sharedInstance = DataManager()
   
    var user: UserData? {
        set{
            if let user = newValue{
                self.saveUserPermanentally(user)
            }
        }
        get{
            self.getPermanentlySavedUser()
        }
    }
    
    var loggedIn: Bool{
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultsStrings.loggedIn)
        }
        get{
            return UserDefaults.standard.bool(forKey: UserDefaultsStrings.loggedIn)
        }
    }
    
    func saveUserPermanentally(_ item: UserData?) {
        if let user = item{
            let encodedData = try? JSONEncoder().encode(user)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultsStrings.user)
        } else {
            UserDefaults.standard.set(nil, forKey: UserDefaultsStrings.user)
        }
    }
    
    func getPermanentlySavedUser() -> UserData? {
        if let data = UserDefaults.standard.data(forKey: UserDefaultsStrings.user), let userData = try? JSONDecoder().decode(UserData.self, from: data) {
            return userData
        } else {
            return nil
        }
    }
    
   
    func setFirebaseToken(firebaseToken: String) {
        UserDefaults.standard.set(firebaseToken,
                                  forKey: UserDefaultsStrings.firebaseToken)
    }
    
    func getFirebaseToken() -> String {
        if let deviceToken = UserDefaults.standard.string(forKey: UserDefaultsStrings.firebaseToken) {
            return deviceToken
        }
        
        return "0"
    }
    
    
    func removeSession(forKey: String){
        UserDefaults.standard.set(nil, forKey: forKey)
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: forKey)
        UserDefaults.standard.set(nil, forKey: forKey)
        userDefaults.removeObject(forKey: forKey)
        
    }
    
    func resetDefaults() {
        
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        dictionary.keys.forEach { key in
            print(key)
            if !(key == UserDefaultsStrings.loggedIn ||
                 key == UserDefaultsStrings.user ||
                 key == UserDefaultsStrings.firebaseToken) {
                defaults.removeObject(forKey: key)
                
            }
            
        }
        
        self.saveUserPermanentally(nil)
        
    }
    
}
