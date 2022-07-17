//
//  UserLoginVM.swift
//  Zon.ae
//
//  Created by Sobhan Asim on 16/11/2021.
//

import UIKit

protocol UserLoginVMDelegate: AnyObject {
    func didLogin(withError error: String?, successMsg: String?)
}

final class UserLoginVM: NSObject{
    
    weak var delegate: UserLoginVMDelegate?
    
    let type: ViewControllerType = .LoginVC
    
    //    let modalString = DataManager.sharedInstance.getSaveLanguageString()
    
    override init() {
        super.init()
    }
    
    func loginUser(email: String, password: String){
        self.loginUser(email: email, password: password) { [weak self] errorStr, successMsg in
            self?.delegate?.didLogin(withError: errorStr, successMsg: successMsg)
        }
    }
    
    private func loginUser(email: String, password: String, with handler: @escaping (_ errorStr: String?, _ success: String?) -> Void){
        
        //        self.showloading()
        
        APIManager.sharedInstance.opertationWithRequest(withApi: .signin(password: password, email: email)) { [weak self] response in
            
            //            self?.hideloading()
            
            switch response {
                case .Success(let data):
                    if let data = data as? [String: Any]{
                        if let dataResponse = data["success"] as? [String: Any]{
                            
                            let loginMode = (dataResponse["is_login_mode"] as? Int ?? 0) == 1
                            
                            handler(nil, (data["message"] as? String))
                            
                        } else {
                            handler(nil, (data["message"] as? String))
                        }
                        
                    } else {
                        handler("We're unable to fetch records. Please try again later", nil)
                    }
                    
                case .Failure(let error):
                    handler(error, nil)
                    
            }
        }
    }
}

