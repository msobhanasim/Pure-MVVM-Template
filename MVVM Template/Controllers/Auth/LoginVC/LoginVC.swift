//
//  LoginVC.swift
//  Zon.ae
//
//  Created by CodingPixelIOS on 08/11/2021.
//

import UIKit

class LoginVC: BaseViewController, UITextFieldDelegate {

    //MARK: - Identifiers
    
    static let identifier = "LoginVC"
    
    //MARK: - Outlets
    
    @IBOutlet weak var longBackView : UIView!
    @IBOutlet weak var shortBackView : UIView!
    
    @IBOutlet weak var usePhonetxt : UITextField!
    @IBOutlet weak var userPasswordtxt : UITextField!
    
    @IBOutlet weak var letsSignInLbl : UILabel!
    @IBOutlet weak var welcomeBackLbl : UILabel!
    @IBOutlet weak var havwAAccountLbl : UILabel!
    
    @IBOutlet weak var thumbBtn : UIButton!
    @IBOutlet weak var forgotPasswordBtn : UIButton!
    @IBOutlet weak var SignInBtn : UIButton!
    @IBOutlet weak var SignUpBtn : UIButton!
    @IBOutlet weak var backBtn : UIButton!
    
   
    //MARK: - Variables
    
//    let modalString  = DataManager.sharedInstance.getSaveLanguageString()
    
    var userLoginVM = UserLoginVM()
    
    //MARK: - Life Cycle
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    //MARK: - Buttons
 
    @IBAction func onClickBack(_ sender : Any){
//        self.Goback()
    }
    
    @IBAction func onClickPasswordShow(_ sender : Any){
       
    }
    
    @IBAction func onClickForgotPassword(_ sender : Any){
//        let vc = self.getVC(storyboard: .auth, vcIdentifier: ForgotPasswordVC.identifier) as! ForgotPasswordVC
//        self.openVc(vc: vc)
    }
    
    @IBAction func onClickSignIn(_ sender : Any){
        userLoginVM.loginUser(email: usePhonetxt.text ?? "", password: userPasswordtxt.text ?? "")
    }
    
    @IBAction func onClickSignUp(_ sender : Any){
//        let vc = self.getVC(storyboard: .auth, vcIdentifier: GetStartedVC.identifier) as! GetStartedVC
//        self.openVc(vc: vc)
    }

}


//MARK: - Functions

extension LoginVC {
    
    func setView(){
        usePhonetxt.delegate = self
        userPasswordtxt.delegate = self
        
        usePhonetxt.setLeftPaddingPoints(15)
        usePhonetxt.setRightPaddingPoints(15)
        userPasswordtxt.setLeftPaddingPoints(15)
        userPasswordtxt.setRightPaddingPoints(50)
        
        usePhonetxt.setLocalized()
        userPasswordtxt.setLocalized()
        
        userLoginVM.delegate = self
        
        configureView()
        
    }
    
    func configureView(){
        backBtn.setLocalized()
        
        usePhonetxt.setLocalized()
        userPasswordtxt.setLocalized()
//        userPasswordtxt.placeholder = modalString?.password ?? "Password"
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        longBackView.isHidden = false
        shortBackView.isHidden = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        longBackView.isHidden = true
        shortBackView.isHidden = false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == usePhonetxt {
            let maxLength = 9
            let currentString: NSString = (textField.text ?? "") as NSString
            let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
            
        } else {
            return true
            
        }
        
    }
    
}


extension LoginVC: UserLoginVMDelegate {
    func didLogin(withError error: String?, successMsg: String?) {
        if let errorStr = error {
            // Do Something ...
            print(errorStr)
        } else if let successMsg = successMsg {
            // Do Something ...
            print(successMsg)
        }
    }
    
}
