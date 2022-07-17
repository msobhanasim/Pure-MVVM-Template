
//
//  APIRoutes.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias OptionalDictionary = [String : Any]?
typealias OptionalSwiftJSONParameters = [String : JSON]?

infix operator =>
infix operator =|
infix operator =<
    infix operator =/

func =>(key : String, json : OptionalSwiftJSONParameters) -> String?{
    return json?[key]?.stringValue
}

func =<(key : String, json : OptionalSwiftJSONParameters) -> Double?{
    return json?[key]?.double
}

func =|(key : String, json : OptionalSwiftJSONParameters) -> [JSON]?{
    return json?[key]?.arrayValue
}

func =/(key : String, json : OptionalSwiftJSONParameters) -> Int?{
    return json?[key]?.intValue
}

prefix operator ¿
prefix func ¿(value : String?) -> String {
    return value.unwrap()
}


protocol Router {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
}



enum API {
    static func mapKeysAndValues(keys : [String]?,values : [String]?) -> [String : String]?{
        guard let tempValues = values,let tempKeys = keys else { return nil}
        var params = [String : String]()
        for (key,value) in zip(tempKeys,tempValues) {
            params[key] = ¿value
        }
        return params
    }
    
    
    
    // MARK: Auth Module API Routes
    
    case signin(password: String,
                email: String)
    
    case signup(email: String,
                password: String,
                phone_no: String,
                name: String)
    
    case logout
    
}


extension API : Router{
    var baseURL : String {  return APIConstants.BasePath }
    
    var parameters : OptionalDictionary {
        let pm = formatParameters()
        return pm
    }
    
    func url() -> String {
        // MARK: - Making custom Params fo APIs
        if self.method == .get {
            var url = baseURL + route
            
            if let params = self.parameters {
                for (key,value) in params {
                    if url.contains("?") {
                        url += "&" + key + "=" + (value as? String ?? "")
                    } else {
                        url += "?" + key + "=" + (value as? String ?? "")
                    }
                }
            }
            
            return url
            
        } else if self.method == .post {
            return baseURL + route
            
        } else {
            return baseURL + route
        }
        
    }
    
    var route : String {
        switch self {
                // MARK: Auth Module API Routes
                
            case .signin:
                return APIPaths.login
                
            case .signup:
                return APIPaths.signUp
                
            case .logout:
                return APIPaths.logout
                
        }
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
                
            case .signin:
                return .post
                
            case .signup:
                return .post
                
            case .logout:
                return .post
                
                
        }
    }
}

extension API {
    func formatParameters() -> OptionalDictionary {
        switch self {
                
                // MARK: Auth Module API Routes
                
            case .signin(let password,
                         let email):
                
                return ["password" : password,
                        "email": email
                ]
                
            case .signup(let email,
                         let password,
                         let phone_no,
                         let name):
                
                return ["email" : email,
                        "password" : password,
                        "phone_no" : phone_no,
                        "name" : name
                ]
                
            case .logout:
                return nil
                
                
        }
    }
}
