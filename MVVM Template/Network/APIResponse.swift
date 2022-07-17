
//
//  API.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
import SwiftyJSON
import ObjectMapper

extension API{
    func handleResponse(parameters : JSON?) -> AnyObject? {
        switch self {

        // MARK: Auth Module API Responses
        
        case .signin, .signup:
            
            if let data = parameters?.dictionary?["data"] {
                
                if let userData = data.dictionary?["success"]?.rawValue as? [String:Any] {
                    
                    if let token = userData["token"] as? String {
                        let user = UserData.initFrom(json: userData)
                        
                        if let loginMode = user.is_login_mode  {
                            if loginMode == 0 {
//                                DataManager.sharedInstance.saveAccessTokenPermanentally(token)
                                DataManager.sharedInstance.user = user
                                DataManager.sharedInstance.saveUserPermanentally(user)
                            }
                        } else {
//                            DataManager.sharedInstance.saveAccessTokenPermanentally(token)
                            DataManager.sharedInstance.user = user
                            DataManager.sharedInstance.saveUserPermanentally(user)
                        }
                        
                        return data.dictionaryObject as AnyObject?
                    } else {
                        return data.dictionaryObject as AnyObject?
                    }
                } else {
                    return data.dictionaryObject as AnyObject?
                }

            } else {
                return parameters?.dictionaryObject as AnyObject?
            }
            
        default:
            if let data = parameters?.dictionaryObject?["data"] as? [String: Any]{
                return data as AnyObject
                
            } else {
                return parameters?.dictionary?["success"]?.rawValue as AnyObject?
            }
            
        }
    }
}


enum APIValidation : String{
    case None
    case Success = "1"
    case ServerIssue = "500"
    case Failed = "0"
    case TokenInvalid = "401"
}

enum APIResponse {
    case Success(AnyObject?)
    case Failure(String?)
}

func decode<T: Decodable>(_ dataJS: JSON?) -> T? {
    if let data = dataJS?.rawString()?.data(using: .utf8){
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
        } catch {
            print(error as Any)
            return nil
        }
        
    } else {
        return nil
        
    }
}
