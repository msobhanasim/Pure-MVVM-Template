//
//  UserData.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
//import GoogleSignIn
import UIKit

struct UserData : Codable {
	var token : String?
	var is_profile : String?
	var flag : Int?
	var is_verify : String?
	var name : String?
	var email : String?
	var status : String?
	var phone_no : String?
    var have_address : Int?
    var socialId : String?
    var password : String?
    var gender: String?
    var image: String?
    var imageFileName: String?
    var is_login_mode: Int?
    
    var socialLoginType: SocialAccountType = .AccountLogin
    
	enum CodingKeys: String, CodingKey {

		case token = "token"
		case is_profile = "is_profile"
		case flag = "flag"
		case is_verify = "is_verify"
		case name = "name"
		case email = "email"
		case status = "status"
		case phone_no = "phone_no"
        case have_address = "have_address"
        case gender = "gender"
        case image = "image"
        case imageFileName = "imageFileName"
        case is_login_mode = "is_login_mode"
	}
    
    init(){}
    
    static func initFrom(json:[String:Any]) -> UserData{
        var obj = UserData()
        obj.token = json[CodingKeys.token.rawValue] as? String
        obj.is_profile = json[CodingKeys.is_profile.rawValue] as? String
        obj.flag = json[CodingKeys.flag.rawValue] as? Int
        obj.is_verify = json[CodingKeys.is_verify.rawValue] as? String
        obj.name = json[CodingKeys.name.rawValue] as? String
        obj.email = json[CodingKeys.email.rawValue] as? String
        obj.status = json[CodingKeys.status.rawValue] as? String
        obj.phone_no = json[CodingKeys.phone_no.rawValue] as? String
        obj.have_address = json[CodingKeys.have_address.rawValue] as? Int
        obj.gender = json[CodingKeys.gender.rawValue] as? String
        obj.image = json[CodingKeys.image.rawValue] as? String
        obj.is_login_mode = json[CodingKeys.is_login_mode.rawValue] as? Int
        return obj
    }

	init(from decoder: Decoder) throws {
		let values = try decoder.container(keyedBy: CodingKeys.self)
		token = try values.decodeIfPresent(String.self, forKey: .token)
		is_profile = try values.decodeIfPresent(String.self, forKey: .is_profile)
		flag = try values.decodeIfPresent(Int.self, forKey: .flag)
		is_verify = try values.decodeIfPresent(String.self, forKey: .is_verify)
		name = try values.decodeIfPresent(String.self, forKey: .name)
		email = try values.decodeIfPresent(String.self, forKey: .email)
		status = try values.decodeIfPresent(String.self, forKey: .status)
		phone_no = try values.decodeIfPresent(String.self, forKey: .phone_no)
        have_address = try values.decodeIfPresent(Int.self, forKey: .have_address)
        gender = try values.decodeIfPresent(String.self, forKey: .gender)
        image = try values.decodeIfPresent(String.self, forKey: .image)
        is_login_mode = try values.decodeIfPresent(Int.self, forKey: .is_login_mode)
        
//        imageFileName = try values.decodeIfPresent(String.self, forKey: .imageFileName)
	}
    
//    func genrateUserFromGoogle(googleUser:  GIDGoogleUser?) -> UserData {
//        var userObj = UserData()
//        userObj.socialId =  googleUser?.userID ?? ""
//        userObj.name = googleUser?.profile.name ?? ""
//        userObj.email = googleUser?.profile.email ?? ""
//        userObj.socialLoginType = .Goole
//        return userObj
//    }

}

extension UIView {
    var currentUser: UserData? {
        get{
            return DataManager.sharedInstance.getPermanentlySavedUser() ?? UserData()
        }
        
        set {
            DataManager.sharedInstance.saveUserPermanentally(newValue)
        }
    }
}

extension UIViewController {
    var currentUser: UserData? {
        get{
            return DataManager.sharedInstance.getPermanentlySavedUser() ?? UserData()
        }
        set {

            if newValue?.token ?? "" != ""{

            } else {
                var user = newValue
//                user?.token = DataManager.sharedInstance.getAccessTokenPermanentally()
                DataManager.sharedInstance.saveUserPermanentally(user)
            }

            DataManager.sharedInstance.saveUserPermanentally(newValue)

        }
    }

    var didPassedWalkthrough: Bool  {
        set{
            UserDefaults.standard.set(newValue , forKey: "didGotCompleteProfileOnHomeVC")
        }
        get{
           return UserDefaults.standard.bool(forKey: "didGotCompleteProfileOnHomeVC")
        }
    }

}

