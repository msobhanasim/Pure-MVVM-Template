//
//  HTTPClient.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
import Alamofire
import SwiftyJSON

typealias HttpClientSuccess = (AnyObject?) -> ()
typealias HttpClientFailure = (NSError) -> ()

class HTTPClient {
    
    func postRequestWithJsonString(withEndPoint url : String  , withBody body : [String:Any] , apiMethod : HTTPMethod , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure )  {
        let token = UserDefaults.standard.string(forKey: "user")
        print(token!)
        var headers: HTTPHeaders{
            if(DataManager.sharedInstance.user != nil){
                
                return ["Authorization": "bearer \(DataManager.sharedInstance.getPermanentlySavedUser()?.token ?? "")",
                        "Accept": "application/json"]
            }else{
                return ["Accept": "application/json"]
            }
        }
        print(headers)
        print(body)
        let apiURL = APIConstants.BasePath + url
        print(apiURL)
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(apiURL, method: apiMethod, parameters: body, encoding: URLEncoding.default , headers: headers).responseString { (response:DataResponse<String>) in
                DispatchQueue.main.async {
                    switch(response.result) {
                        case .success(_):
                            if let data = response.result.value{
                                success(data.parseJSONString as AnyObject?)
                            }
                        case .failure(_):
                            failure(response.result.error! as NSError)
                            
                    }
                }
            }
        }
    }
    
    func postRequest(withApi api: API  , success: @escaping HttpClientSuccess , failure: @escaping HttpClientFailure ) {
        //let token = UserDefaults.standard.string(forKey: "user")
        //print(token!)
        let params = api.parameters
        let method = api.method
        
        var headers: HTTPHeaders{
            
            if(DataManager.sharedInstance.user != nil){
                return ["Authorization": "Bearer \(DataManager.sharedInstance.getPermanentlySavedUser()?.token ?? "")",
                        "Accept": "application/json"]
                
            }else{
                return ["Accept": "application/json"]
            }
        }
        
        print(headers)
        print(api.url())
        print(params ?? "")
        
        
        DispatchQueue.global(qos: .background).async {
            Alamofire.request(api.url(), method: method,parameters: method == .get ? [:] : params, encoding: URLEncoding.default , headers: headers).responseString { (response:DataResponse<String>) in
                DispatchQueue.main.async {
                    switch(response.result) {
                        case .success(_):
                            if let data = response.result.value{
                                success(data.parseJSONString as AnyObject?)
                            }
                        case .failure(_):
                            failure(response.result.error! as NSError)
                            
                    }
                }
                
            }
        }
        
    }
    
    func UploadFiles(withApi api:API,image:UIImage, videoURL: String = "" ,success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        
        var headers: HTTPHeaders{
            if(DataManager.sharedInstance.user != nil){
                
                return ["Authorization": "Bearer \(DataManager.sharedInstance.getPermanentlySavedUser()?.token ?? "")",
                        "Accept": "application/json"]
            }else{
                return ["Accept": "application/json"]
            }
        }
        
        print(api.url())
        print(api.parameters as Any)
        print(headers)
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if videoURL == ""{
                if let dt = image.compressedData() {
                    multipartFormData.append(dt, withName: "media", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                    
                }
                
            } else {
                if let video = URL(string: videoURL) {
                    multipartFormData.append(video, withName: "file", fileName: String(Date().timeIntervalSince1970) + "." + video.pathExtension, mimeType:  "video/mp4")
                }
                
            }
            
            if api.parameters != nil {
                for (key, value) in api.parameters!{
                    let stringValue = value as? String ?? ""
                    multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
        }, usingThreshold: UInt64.init(), to: api.url(), method: .post, headers: headers) { (result) in
            switch result{
                case .success(let upload, _,_ ):
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UploadProgress"), object: nil, userInfo: ["progress": Progress.fractionCompleted])
                        
                    })
                    upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                        switch(response.result) {
                            case .success(_):
                                if let data = response.result.value{
                                    success(data.parseJSONString as AnyObject?)
                                }
                            case .failure(_):
                                failure(response.result.error! as NSError)
                        }
                    })
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    failure(error as NSError)
            }
        }
    }
    
    func UploadMultipleImages(withApi api:API, images:[UIImage], or dict: [String: UIImage] = [:] , success : @escaping HttpClientSuccess, failure: @escaping HttpClientFailure) {
        
        var headers: HTTPHeaders{
            return ["Authorization": "Bearer \(DataManager.sharedInstance.getPermanentlySavedUser()?.token ?? "")",
                    "Accept": "application/json", "Content-type": "multipart/form-data", "Connection": "Keep-Alive"]
        }
        
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            if images.count > 0 {
                for image in images {
                    let imageData = image.compressedData()
                    multipartFormData.append(imageData ?? Data(), withName: "images[]", fileName: "\(Date().timeIntervalSince1970).jpeg", mimeType: "image/jpeg")
                    
                }
            }else{
                if api.url().contains("add_professional_detail"){
                    
                    for (name, img) in dict {
                        print(name, " ", img)
                        let innerImageData = img.compressedData()
                        
                        if name.contains("photo_1"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "photo_id", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        } else if name.contains("photo_2"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "photo_license", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        }else if name.contains("photo_3"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "photo_license_board", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        }
                    }
                    
                }else if api.url().contains("add_update_service"){
                    
                    for (name, img) in dict {
                        print(name, " ", img)
                        let innerImageData = img.compressedData()
                        
                        if name.contains("service_other_1"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "service_other_1", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        } else if name.contains("service_other_2"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "service_other_2", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        }else if name.contains("service_other_3"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "service_other_3", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        }else if name.contains("service_other_4"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "service_other_4", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        } else if name.contains("service_other_5"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "service_other_5", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        }else if name.contains("service_other_6"){
                            multipartFormData.append(innerImageData ?? Data(), withName: "service_other_6", fileName: String(Date().timeIntervalSince1970) + ".png", mimeType: "image/png")
                        }
                    }
                }
                
            }
            
            
            if api.parameters != nil {
                var stringValue = ""
                for (key, value) in api.parameters!{
                    if let intValue = value as? Int {
                        stringValue = String(intValue)
                    } else {
                        stringValue = value as? String ?? ""
                    }
                    multipartFormData.append(stringValue.data(using: String.Encoding.utf8)!, withName: key)
                }
            }
            
        }, to: api.url(), headers: headers,
                         
                         encodingCompletion: { encodingResult in
            
            switch encodingResult{
                case .success(let upload, _, _ ):
                    
                    print(upload)
                    print(encodingResult)
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UploadProgress"), object: nil, userInfo: ["progress": Progress.fractionCompleted])
                        
                    })
                    upload.responseString(completionHandler: { (response:DataResponse<String>)  in
                        switch(response.result) {
                            case .success(_):
                                if let data = response.result.value{
                                    success(data.parseJSONString as AnyObject?)
                                }
                            case .failure(_):
                                failure(response.result.error! as NSError)
                        }
                    })
                case .failure(let error):
                    print("Error in upload: \(error.localizedDescription)")
                    failure(error as NSError)
            }
            
        })
        
        
    }
    
}
