
//
//  APIManager.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
import SwiftyJSON

typealias APICompletion = (APIResponse) -> ()

class APIManager: BaseViewController {
    
    static let sharedInstance = APIManager()
    private lazy var httpClient : HTTPClient = HTTPClient()
    
//    let modalString = DataManager.sharedInstance.getSaveLanguageString()
    
    func opertationWithRequest ( withApi api : API , completion : @escaping APICompletion) {
        httpClient.postRequest(withApi: api, success: { (data) in
            guard let response = data else {
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            
            let json = JSON(response)
            
            print("Json,API : \(json),\(api.url())")
            
            if let jsonResponse = json.dictionaryValue["data"]{
                if let errorCode = jsonResponse.dictionaryValue["code"]?.int {
                    if errorCode >= 400 {
                        
                        if let errorType = jsonResponse.dictionaryValue["error_type"]?.stringValue {
                            if errorType == "not_authenticated" {
                                //Logout functionality
                                self.forceLogout()
                                return
                            }
                        }
                        
                        if let user_message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            if api.route == APIPaths.login {
                                if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                                    
                                    completion(APIResponse.Failure("\(user_message)|\(message)"))
                                    return
                                    
                                }
                            } else {
                                completion(APIResponse.Failure(user_message))
                                return
                            }
                        } else if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                            
                            completion(APIResponse.Failure(message))
                            return
                        }
                        
                        completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                    } else if errorCode == 401 {
                        
                        //Logout functionality
                        self.forceLogout()
                        return
                        
                    }
                }
                
                if let _ = jsonResponse.dictionaryValue["error_type"]?.string{
                    if let error_message = jsonResponse.dictionaryValue["message"]?.string{
                        completion(APIResponse.Failure(error_message))
                    }
                    return
                }
                
                
                if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                    if message.lowercased() == "sign up this user" {
                        if let message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            completion(APIResponse.Failure(message))
                            return
                        }
                    }
                }
            } else if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            
            completion(.Success(api.handleResponse(parameters: json)))
            
        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    func jsonDecoder<T : Decodable>(structure: T.Type,jsonData: APIResponse) -> Any{
        let responseData = try? JSONSerialization.data(withJSONObject: jsonData, options: [])
        print(jsonData)
        let jsonDecoder = JSONDecoder()
        let data = try? jsonDecoder.decode(structure.self, from: responseData!)
        return data!
    }
    
    func opertationWithRequestWithFileUploading(withApi api: API, image: UIImage, videoURL: String = "", completion: @escaping APICompletion) {
        
        httpClient.UploadFiles(withApi: api,image:image, videoURL: videoURL, success: { (data) in
            guard let response = data else {
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            let json = JSON(response)
            
            print("Json,API : \(json),\(api.url())")
            
            if let jsonResponse = json.dictionaryValue["data"]{
                if let errorCode = jsonResponse.dictionaryValue["code"]?.int {
                    if errorCode >= 400 {
                        
                        if let errorType = jsonResponse.dictionaryValue["error_type"]?.stringValue {
                            if errorType == "not_authenticated" {
                                //Logout functionality
                                self.forceLogout()
                                return
                            }
                        }
                        
                        if let message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            completion(APIResponse.Failure(message))
                            return
                        } else if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                            
                            completion(APIResponse.Failure(message))
                            return
                        }
                        
                        
                        
                        completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                    } else if errorCode == 401 {
                        //Logout functionality
                        self.forceLogout()
                        return
                        
                    }
                }
                
                if let _ = jsonResponse.dictionaryValue["error_type"]?.string{
                    if let error_message = jsonResponse.dictionaryValue["message"]?.string{
                        completion(APIResponse.Failure(error_message))
                    }
                    return
                }
                
                
                if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                    if message.lowercased() == "sign up this user" {
                        if let message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            completion(APIResponse.Failure(message))
                            return
                        }
                    }
                }
            } else if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            
            completion(.Success(api.handleResponse(parameters: json)))
            
        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    
    //    Video Uploading Func Implementation
    
    
    func opertationWithRequestWithVideoUploading ( withApi api : API, videoURL: String = "", completion : @escaping APICompletion ) {
        
        httpClient.UploadFiles(withApi: api, image: UIImage(), videoURL: videoURL, success: { (data) in
            guard let response = data else {
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            let json = JSON(response)
            print("Json,API : \(json),\(api.url())")
            
            if let jsonResponse = json.dictionaryValue["data"]{
                if let errorCode = jsonResponse.dictionaryValue["code"]?.int {
                    if errorCode >= 400 {
                        
                        if let errorType = jsonResponse.dictionaryValue["error_type"]?.stringValue {
                            if errorType == "not_authenticated" {
                                //Logout functionality
                                self.forceLogout()
                                return
                            }
                        }
                        
                        if let message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            completion(APIResponse.Failure(message))
                            return
                        } else if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                            
                            completion(APIResponse.Failure(message))
                            return
                        }
                        
                        
                        completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                    } else if errorCode == 401 {
                        
                        //Logout functionality
                        self.forceLogout()
                        return
                        
                    }
                }
                
                if let _ = jsonResponse.dictionaryValue["error_type"]?.string{
                    if let error_message = jsonResponse.dictionaryValue["message"]?.string{
                        completion(APIResponse.Failure(error_message))
                    }
                    return
                }
                
                
                if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                    if message.lowercased() == "sign up this user" {
                        if let message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            completion(APIResponse.Failure(message))
                            return
                        }
                    }
                }
            } else if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            
            completion(.Success(api.handleResponse(parameters: json)))
            
        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
    }
    
    func opertationWithRequestWithMultipleImagesFileUploading(withApi api : API, image:[UIImage] , or dict: [String: UIImage] = [:],  completion : @escaping APICompletion )  {
        dump(image)
        httpClient.UploadMultipleImages(withApi: api, images: image, or: dict, success: { (data) in
            guard let response = data else {
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            let json = JSON(response)
            print("Json,API : \(json),\(api.url())")
            
            if let jsonResponse = json.dictionaryValue["data"]{
                if let errorCode = jsonResponse.dictionaryValue["code"]?.int {
                    if errorCode >= 400 {
                        
                        if let errorType = jsonResponse.dictionaryValue["error_type"]?.stringValue {
                            if errorType == "not_authenticated" {
                                //Logout functionality
                                self.forceLogout()
                                return
                            }
                        }
                        
                        if let message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            completion(APIResponse.Failure(message))
                            return
                        } else if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                            
                            
                            completion(APIResponse.Failure(message))
                            return
                        }
                        
                        
                        
                        completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                    } else if errorCode == 401 {
                        
                        //Logout functionality
                        self.forceLogout()
                        return
                        
                    }
                }
                
                if let _ = jsonResponse.dictionaryValue["error_type"]?.string{
                    if let error_message = jsonResponse.dictionaryValue["message"]?.string{
                        completion(APIResponse.Failure(error_message))
                    }
                    return
                }
                
                
                if let message = jsonResponse.dictionaryValue["message"]?.stringValue {
                    if message.lowercased() == "sign up this user" {
                        if let message = jsonResponse.dictionaryValue["user_message"]?.stringValue {
                            completion(APIResponse.Failure(message))
                            return
                        }
                    }
                }
            } else if json.stringValue.contains("\"status\":\"error\""){
                completion(APIResponse.Failure("We're not able to fetch records, please try again"))
                return
            }
            
            completion(.Success(api.handleResponse(parameters: json)))
            
        }) { (error) in
            print(error)
            completion(APIResponse.Failure(error.localizedDescription))
        }
        
        
    }
    
    func forceLogout(){
        
//        DataManager.sharedInstance.resetDefaults()
//
//        let vc = self.getVC(vcIdentifier: SocialLoginVC.identifier, inStoryBboard: .auth) as! SocialLoginVC
//
//        let nav = UINavigationController(rootViewController: vc)
//        nav.navigationBar.isHidden = true
//
//        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//           let sceneDelegate = windowScene.delegate as? SceneDelegate {
//            sceneDelegate.window?.rootViewController = nav
//            sceneDelegate.window?.makeKeyAndVisible()
//
//        } else if let window = UIApplication.shared.delegate?.window {
//            window?.rootViewController = nav
//            window?.makeKeyAndVisible()
//
//        }
    }
}






