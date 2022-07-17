//
//  SceneDelegate.swift
//  Zon.ae
//
//  Created by Sobhan Asim on 18/09/2021.
//

import UIKit
import IQKeyboardManagerSwift

@available(iOS 13.0, *)
class SceneDelegate: BaseViewController, UIWindowSceneDelegate {
    
    var window: UIWindow?
    var scene: UIScene?
    
    var dataSharedInstance: DataManager = DataManager.sharedInstance
    
    private(set) static var shared: SceneDelegate?
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        self.scene = scene
        NotificationCenter.default.addObserver(self, selector: #selector(saveData), name: UIApplication.willTerminateNotification, object: nil)
        
        window?.overrideUserInterfaceStyle = .light
        
        // For Language Direction Control
//        if dataSharedInstance.getLanguageDirection() == "RTL" {
//            Localize.setCurrentLanguage(dataSharedInstance.getSlug())
//            Language.sharedInstance.isScreenFlippedOnce = true
//            AppDelegate.sharedDelegate().RTL()
//            self.view.layoutIfNeeded()
//
//        } else if dataSharedInstance.getLanguageDirection() == "LTR" {
//            Localize.setCurrentLanguage(dataSharedInstance.getSlug())
//            Language.sharedInstance.isScreenFlippedOnce = true
//            AppDelegate.sharedDelegate().LTR()
//            self.view.layoutIfNeeded()
//
//        } else {
//            Localize.setCurrentLanguage(dataSharedInstance.getSlug())
//            Language.sharedInstance.isScreenFlippedOnce = true
//            AppDelegate.sharedDelegate().LTR()
//            self.view.layoutIfNeeded()
//
//        }
        
    }
    
    
    // I have made a Global Class that will be used for APIs that are not dependent on any view or UseCase. Rather these apis are globally required...
    
//    @available(iOS 13.0, *)
//    func languageStringsData(){
//        GlobalAPICaller.shared.getLanguageStrings(forCountryId: String(DataManager.sharedInstance.getCountryID()), andLanguageId: String(DataManager.sharedInstance.getLanguageID())) { languageStringsData, errorString in
//            guard let languageStringsData = languageStringsData else {return}
//
//            DataManager.sharedInstance.saveLanguageStrings(languageStringsData)
//
//            NotificationCenter.default.post(name: .init(rawValue: "didFetchLanguage"), object: nil)
//
//
//
//        }
//    }
    
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
    
    @objc func saveData(notification:NSNotification) {
        // Save your data here
        //        DataManager.sharedInstance.resetDefaults()
        
    }
    
    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }
        
    }
    
    @available(iOS 13.0, *)
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        
    }
    
    @available(iOS 13.0, *)
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    @available(iOS 13.0, *)
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    @available(iOS 13.0, *)
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    @available(iOS 13.0, *)
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
}

