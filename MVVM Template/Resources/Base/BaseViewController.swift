//
//  BaseViewController.swift
//  Zon.ae
//
//  Created by Sobhan Asim on 16/10/2021.
//


// This is the Parent of all of the VCs... I am extending all of the VCs to this central class... this way I have to manage things only in this class which are being used globally...
// some of the example includes showing/hiding loading views, going back to parent views etc.


import UIKit
import Photos
//import BRYXBanner
//import Hero
//import GSImageViewerController
//import SkeletonView
import Nuke
import Loaf
//import ImagePicker


enum Storyboards: String{
    /// `Main Entry Point`
    case main = "Main"
    
    /// `Other StoryBorads`
    case home = "Home"
    
    func board() -> String {
        return self.rawValue
    }
}

enum ViewControllerType {
    case SocialLoginVC
    case LoginVC
    case PhoneNumberVC
    case OTPVC
    case ForgotPasswordVC
    case EnterNameVC
    case EnterEmailVC
    case PasswordVC
    case UpdatePasswordVC
    case SignUp
    
    case HomeVC
    case QuotationVC
    case DeliveryVC
    case ProductListVC
    case ProductDetailVC
}

enum AppColors: String {
    case Background_Color = "Background Color"
    case Banner_Color = "Banner Color"
    case Black_Color = "Black Color"
    case Button_Grey_Color = "Button Grey Color"
    case Gray_Color = "Gray Color"
    case Gree_Coor = "Green Coor"
    case Light_Green_Color = "Light-Green Color"
    case Navy_Blue_Color = "Navy-Blue Color"
    case Pink_Red_Color = "Pink-Red Color"
    case PrimaryBlue_Color = "PrimaryBlue Color"
    case Red_Color = "Red Color"
    case SubHeading_Color = "SubHeading Color"
    case Text_Color = "Text Color"
    case Yellow_Color = "Yellow Color"
}

enum ThemeMode: String {
    case light = "light"
    case dark = "dark"
    
}

var firstAlbumAssets : [PHAsset] = [PHAsset]()
var currentAlbum : PHAssetCollection = PHAssetCollection.init()
var allAlbums : [CustomAlbum] =  [CustomAlbum]()

class BaseViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //        if DataManager.sharedInstance.CurrentAppTheme == .dark {
        //            // Set According to Dark Mode
        //        } else {
        //            // Set According to Light Mode
        //        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func scape(Orientation : String){
        switch Orientation {
            case "landScape":
                let value = UIInterfaceOrientation.landscapeLeft.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                
            case "portrait":
                let value = UIInterfaceOrientation.portrait.rawValue
                UIDevice.current.setValue(value, forKey: "orientation")
                
            default:
                print("")
        }
    }
    
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if let subLayers = self.view.layer.sublayers {
            for (index, subLayer) in subLayers.enumerated() {
                if subLayer is CAGradientLayer {
                    self.view.layer.sublayers?.remove(at: index)
                }
            }
        }
        
        if #available(iOS 13.0, *) {
            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                if traitCollection.userInterfaceStyle == .dark {
                    // Set According to Dark Mode
                } else {
                    // Set According to Light Mode
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    var customWindow : UIWindow {
        return UIApplication.shared.windows.first!
    }
    
    var hasTopNotch: Bool {
        if #available(iOS 11.0, tvOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
        }
        return false
    }
    
    func presentImagePicker(){
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.allowsEditing = true
        vc.delegate = self
        vc.mediaTypes = ["public.image"]
        self.present(vc, animated: true)
    }
    
    func removeTabNotifications(forObserver observer: Any){
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.init(rawValue: "tab_0"), object: nil)
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.init(rawValue: "tab_1"), object: nil)
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.init(rawValue: "tab_2"), object: nil)
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name.init(rawValue: "tab_3"), object: nil)
    }
    
    //    func changeTheme(themeVal: ThemeMode, with window: UIWindow?) {
    //        if #available(iOS 13.0, *) {
    //            switch themeVal {
    //            case .dark:
    //                window?.overrideUserInterfaceStyle = .dark
    //                DataManager.sharedInstance.CurrentAppTheme = .dark
    //                break
    //            case .light:
    //                window?.overrideUserInterfaceStyle = .light
    //                DataManager.sharedInstance.CurrentAppTheme = .light
    //                break
    //            }
    //        }
    //    }
    
    func ShowPopup() {
        
    }
    
    func popToParentScreen(animated: Bool = true){
        if self.navigationController == nil {
            self.view.window?.rootViewController?.dismiss(animated: animated, completion: nil)
        } else {
            self.navigationController?.popToRootViewController(animated: animated)
        }
    }
    
    
    func resizeImage(image: UIImage) -> UIImage {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        
        let rect = CGRect(x:0.0, y:0.0, width:CGFloat(actualWidth),height: CGFloat(actualHeight))
        
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img!.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
    func fetchAlbums() {
        var albums = [CustomAlbum]()
        var result = PHAssetCollection.fetchAssetCollections(with: .album , subtype: .any, options: nil)
        result.enumerateObjects({ (collection, _, _) in
            if (collection.hasPhotosAssets()) {
                
                let album = CustomAlbum()
                album.album = collection
                album.coverimage = collection.getCoverImgWithSize(CGSize(width: 100, height: 100))
                albums.append(album)
            }
        })
        
        //
        result = PHAssetCollection.fetchAssetCollections(with: .smartAlbum , subtype: .any, options: nil)
        result.enumerateObjects({ (collection, _, _) in
            if (collection.hasPhotosAssets() ) {
                let album = CustomAlbum()
                album.album = collection
                album.coverimage = collection.getCoverImgWithSize(CGSize(width: 100, height: 100))
                albums.append(album)
            }
        })
        
        for i in 0..<albums.count {
            if albums[i].album.localizedTitle == "Recents" {
                let temp = albums[0]
                albums[0] = albums[i]
                albums[i] = temp
                break
            }
        }
        self.loadFirstAlbum(albums: albums) { (albums, curentCollection) in
            
            self.fetchImagesFromGalleryBase(collection: curentCollection) { (assets) in
                firstAlbumAssets = assets
                
                currentAlbum = curentCollection
                
                allAlbums = albums
                
                NotificationCenter.default.post(name: Notification.Name(rawValue: "setViewForFirstAlbum"), object: nil)
            }
        }
    }
    
    func fetchImagesFromGallery(collection: PHAssetCollection? , completion : @escaping (([PHAsset])->Void)) {
        DispatchQueue.main.async {
            var assets : [PHAsset] = [PHAsset]()
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
            
            
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d || mediaType = %d",  PHAssetMediaType.image.rawValue)
            if let collection = collection {
                let assestsRec = PHAsset.fetchAssets(in: collection, options: fetchOptions)
                for index in 0..<assestsRec.count {
                    if  (assestsRec[index].mediaType == .image &&  assestsRec[index].sourceType == .typeUserLibrary ){
                        assets.append(assestsRec[index])
                    }
                    
                }
                
            } else {
                let assestsRec = PHAsset.fetchAssets(with: fetchOptions)
                for index in 0..<assestsRec.count {
                    assets.append(assestsRec[index])
                }
            }
            
            completion(assets)
            
        }
    }
    
    func fetchImagesFromGalleryBase(collection: PHAssetCollection? , complition : @escaping([PHAsset])-> Void) {
        var arrayOfPHAsset  = [PHAsset]()
        DispatchQueue.main.async {
            let fetchOptions = PHFetchOptions()
            fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate",ascending: false)]
            fetchOptions.predicate = NSPredicate(format: "mediaType = %d",  PHAssetMediaType.image.rawValue)
            if let collection = collection {
                let assestsRec = PHAsset.fetchAssets(in: collection, options: fetchOptions)
                for index in 0..<assestsRec.count {
                    
                    if (assestsRec[index].mediaType == .image &&  assestsRec[index].sourceType == .typeUserLibrary) {
                        arrayOfPHAsset.append(assestsRec[index])
                    }
                    //
                }
            } else {
                let assestsRec = PHAsset.fetchAssets(with: fetchOptions)
                for index in 0..<assestsRec.count {
                    arrayOfPHAsset.append(assestsRec[index])
                }
            }
            
            complition(arrayOfPHAsset)
        }
    }
    
    func loadFirstAlbum (albums : [CustomAlbum], complition : @escaping([CustomAlbum],PHAssetCollection)-> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            var settled = false
            
            for i in albums {
                if i.album.localizedTitle ?? "" == "Recents" {
                    settled = true
                    complition(albums,i.album)
                }
            }
            
            if !settled && albums.count > 0 {
                complition(albums,(albums.first?.album)!)
            }
        }
    }
    
    func openOtherAppLink(linkText : String) {
        var link = ""
        if linkText.hasPrefix("http"){
            link = linkText.lowercased()
        }
        else {
            link = "https://\(linkText)".lowercased()
        }
        
        
        if let url = URL(string: link ){
            
            
            if UIApplication.shared.canOpenURL(url) {
                
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                }
                else {
                    UIApplication.shared.openURL(url)
                }
            }
            
        }
        else {
            self.showCustomAlert(title: "Error", message: "Url is not correct", btnString: "Ok")
        }
    }
    
    func topMostController() -> UIViewController {
        var topController: UIViewController = UIApplication.shared.keyWindow!.rootViewController!
        
        while (topController.presentedViewController != nil) {
            topController = topController.presentedViewController!
            
        }
        
        return topController
    }
    
    func CollectionviewNoDataAvailabl(collection_view : UICollectionView , text : String , color:UIColor = UIColor.darkGray ) {
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: collection_view.bounds.size.width, height: collection_view.bounds.size.height))
        noDataLabel.font = UIFont(name: "SofiaProLight", size: 15)
        noDataLabel.text          = text + "   "
        noDataLabel.textColor     = color
        noDataLabel.textAlignment = .center
        noDataLabel.backgroundColor = .clear
        collection_view.backgroundView  = noDataLabel
    }
    
    func TableViewRemoveNoDataLable(tableview : UITableView ) {
        tableview.backgroundView  = nil
    }
    
    func CollectionViewRemoveNoDataLable(collection_view : UICollectionView ) {
        collection_view.backgroundView  = nil
    }
    
    func TableViewNoDataAvailabl(tableview : UITableView , text : String, textColor: UIColor = UIColor.darkGray) {
        
        let noDataLabel: UILabel     = UILabel(frame: CGRect(x: 0, y: 0, width: tableview.bounds.size.width, height: tableview.bounds.size.height))
        noDataLabel.font = UIFont(name: "SofiaProLight", size: 15)
        noDataLabel.text          = text + "   "
        noDataLabel.textColor     = textColor
        noDataLabel.textAlignment = .center
        tableview.backgroundView  = noDataLabel
        tableview.separatorStyle  = .none
    }
    
    //    func showLoading(isWhite : Bool = false) {
    //        DispatchQueue.main.async {
    //            Utility.shared.loader()
    //        }
    //    }
    //
    //    func hideLoading() {
    //        DispatchQueue.main.async {
    //            Utility.shared.removeLoader()
    //        }
    //    }
    
    //    func showSuccessAlert (title : String , message : String) {
    //        let banner = Banner(title: title, subtitle: message , image: nil, backgroundColor: UIColor.init(hexColor: "008B65") )
    //        banner.dismissesOnTap = true
    //        banner.show(duration: 2.0)
    //    }
    //
    //    func showErrorAlert  (title : String , message : String) {
    //        let banner = Banner(title: title, subtitle: message , image: UIImage(named: "Error"), backgroundColor: UIColor(hexColor: "DC3F5E"))
    //        banner.dismissesOnTap = true
    //        banner.show(duration: 2.0)
    //    }
    
    func shareToOtherApp(text : String , image : UIImage , isActualImage : Bool = false) {
        
        // set up activity view controller
        var list : [Any] = []
        if text != ""{
            list.append(text)
        }
        if isActualImage {
            list.append(image)
        }
        let activityViewController = UIActivityViewController(activityItems: list, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func hideCustomLoader(){
        //        Loaf.dismiss(sender: self)
    }
    
    func showCustomAlert(state: Loaf.State = .success, message:String){
        
        self.delay(0.3) {
            Loaf.dismiss(sender: self)
            
            let loaf = Loaf(message, state: state, sender: self)
            
            loaf.show(.short)
            
        }
    }
    
    //    func openVc (vc : UIViewController, animate: Bool = true) {
    //        if self.navigationController  != nil{
    //
    //            if DataManager.sharedInstance.getLanguageDirection().lowercased().contains("ltr") {
    //
    //                let transition = CATransition.init()
    //                transition.duration = 0.45
    //                transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
    //                transition.type = CATransitionType.push //Transition you want like Push, Reveal
    //                transition.subtype = CATransitionSubtype.fromRight // Direction like Left to Right, Right to Left
    //                view.window!.layer.add(transition, forKey: kCATransition)
    //                self.navigationController?.pushViewController(vc, animated: false)
    //            } else {
    //                let transition = CATransition.init()
    //                transition.duration = 0.45
    //                transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
    //                transition.type = CATransitionType.push //Transition you want like Push, Reveal
    //                transition.subtype = CATransitionSubtype.fromLeft // Direction like Left to Right, Right to Left
    //                view.window!.layer.add(transition, forKey: kCATransition)
    //                self.navigationController?.pushViewController(vc, animated: false)
    //            }
    //
    //        }
    //        else {
    //            self.modalTransitionStyle = .coverVertical
    //            self.modalPresentationStyle = .fullScreen
    //            self.present(vc, animated : animate)
    //        }
    //    }
    
    //    func showCustomAlertWithCancel(title:String, message:String, btnString: String = DataManager.sharedInstance.getSaveLanguageString()?.o_k ?? "Ok", handlers: ((UIAlertAction) -> Void)? = nil, cancelHandler: ((UIAlertAction) -> Void)? = nil){
    //        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: btnString, style: .default, handler: handlers))
    //        alertController.addAction(UIAlertAction(title: DataManager.sharedInstance.getSaveLanguageString()?.cancel ?? "Cancel", style: .cancel, handler: cancelHandler))
    //
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    //
    //    func showCustomAlertWithOk(title:String, message:String, btnString: String = DataManager.sharedInstance.getSaveLanguageString()?.o_k ?? "Ok", handlers: ((UIAlertAction) -> Void)? = nil){
    //        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //        alertController.addAction(UIAlertAction(title: btnString, style: .default, handler: handlers))
    //
    //        self.present(alertController, animated: true, completion: nil)
    //    }
    
    func animateLittle(seconds : Double = 0.2){
        UIView.animate(withDuration: seconds) {
            self.view.layoutIfNeeded()
        }
    }
    
    func animateLittle(completion : @escaping (()->Void)){
        UIView.animate(withDuration: 0.2) {
            self.view.layoutIfNeeded()
            self.delay(0.1) {
                completion()
            }
        }
    }
    
    //    func Goback(animate: Bool = true) {
    //        if let nev = self.navigationController{
    //            if animate {
    //                if DataManager.sharedInstance.getLanguageDirection().lowercased().contains("ltr") {
    //
    //                    let transition = CATransition.init()
    //                    transition.duration = 0.45
    //                    transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
    //                    transition.type = CATransitionType.push
    //                    transition.subtype = CATransitionSubtype.fromLeft
    //                    if let window = view.window {
    //                        window.layer.add(transition, forKey: kCATransition)
    //                    } else {
    //                        nev.popViewController(animated: false)
    //                    }
    //
    //
    //                } else {
    //                    let transition = CATransition.init()
    //                    transition.duration = 0.45
    //                    transition.timingFunction = CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.default)
    //                    transition.type = CATransitionType.push
    //                    transition.subtype = CATransitionSubtype.fromRight
    //                    if let window = view.window {
    //                        window.layer.add(transition, forKey: kCATransition)
    //                    } else {
    //                        nev.popViewController(animated: false)
    //                    }
    //
    //                }
    //
    //                nev.popViewController(animated: false)
    //
    //            } else {
    //                nev.popViewController(animated: animate)
    //
    //            }
    //
    //        } else {
    //            self.dismiss(animated: animate) { }
    //
    //        }
    //    }
    
    func createThumbnailOfVideoFromRemoteUrl(url: String) -> UIImage? {
        let asset = AVAsset(url: URL(string: url)!)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        //Can set this to improve performance if target size is known before hand
        //assetImgGenerate.maximumSize = CGSize(width,height)
        let time = CMTimeMakeWithSeconds(1.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            return thumbnail
        } catch {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    //    func goTohomeTabbarScreen(){
    //        let vc = self.getVC(storyboard: .main, vcIdentifier: IndicatorTabBarController.identifier) as! IndicatorTabBarController
    //        let nav = UINavigationController(rootViewController: vc)
    //        nav.navigationBar.isHidden = true
    //
    //
    //        nav.interactivePopGestureRecognizer?.isEnabled = false
    //
    //        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
    //           let sceneDelegate = windowScene.delegate as? SceneDelegate {
    //            sceneDelegate.window?.rootViewController = nav
    //            sceneDelegate.window?.makeKeyAndVisible()
    //
    //            if let window = sceneDelegate.window, let rootVC = window.rootViewController{
    //                nav.view.frame = rootVC.view.frame
    //                nav.view.layoutIfNeeded()
    //
    //                UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
    //                    window.rootViewController = nav
    //                })
    //            }
    //
    //
    //
    //        } else if let window = UIApplication.shared.delegate?.window {
    //            window?.rootViewController = nav
    //            window?.makeKeyAndVisible()
    //
    //            if let rootVC = window?.rootViewController{
    //                nav.view.frame = rootVC.view.frame
    //                nav.view.layoutIfNeeded()
    //
    //                UIView.transition(with: window ?? UIWindow(), duration: 0.3, options: .transitionCrossDissolve, animations: {
    //                    window?.rootViewController = nav
    //                })
    //            }
    //        }
    //
    //    }
    
    func goToTabbarScreen(onTab tab: Int = 0){
        NotificationCenter.default.post(name: Notification.Name.init(rawValue: "tab_\(tab)"), object: nil)
        //        let vc = self.getVC(storyboard: .main, vcIdentifier: IndicatorTabBarController.identifier) as! IndicatorTabBarController
        //        vc.selectedIndex = tab
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
        //
    }
    
    //    func goTohomeStartupScreen(){
    //        let vc = self.getVC(vcIdentifier: SocialLoginVC.identifier, inStoryBboard: .auth) as! SocialLoginVC
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
    //    }
    
    func showNoDataViewOnTableView(tableview: UITableView, forItemsCount count: Int, title: String, details: String = "", type: NoDataViewType = .standardType, backGroundColor: UIColor) {
        if count == 0 {
            let noDataView  = NoDataView(frame: CGRect(x: 0, y: 0, width: tableview.bounds.size.width, height: tableview.bounds.size.height))
            noDataView.setViewDetails(title, details, type, backGroundColor)
            tableview.backgroundView  = noDataView
            tableview.separatorStyle  = .none
        } else {
            tableview.backgroundView = nil
        }
    }
    
    func showNoDataViewOnCollectionView(collectionView: UICollectionView, forItemsCount count: Int, title: String, details: String = "", type: NoDataViewType = .standardType, backGroundColor: UIColor) {
        if count == 0 {
            let noDataView  = NoDataView(frame: CGRect(x: 0, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height))
            noDataView.setViewDetails(title, details, type, backGroundColor)
            collectionView.backgroundView  = noDataView
        } else {
            collectionView.backgroundView = nil
        }
    }
    
}

extension BaseViewController {
    
    //MARK: Delay
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
}

extension UIViewController {
    func getVC(storyboard : Storyboards, vcIdentifier : String) -> UIViewController {
        //String = kStoryBoardMain
        return UIStoryboard(name: storyboard.board(), bundle: nil).instantiateViewController(withIdentifier: vcIdentifier)
    }
    
}

extension DispatchQueue {
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}

extension BaseViewController {
    var isDarkMode: Bool {
        if #available(iOS 13.0, *) {
            return self.traitCollection.userInterfaceStyle == .dark
        }
        else {
            return false
        }
    }
    
}

extension UITableViewCell {
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

extension UIViewController {
    func isValidEmail(_ email: String) -> Bool {
        
        let emailPattern = #"^\S+@\S+\.\S+$"#
        
        var result = "test@test.com".range(
            of: emailPattern,
            options: .regularExpression
        )
        
        let validEmail = (result != nil)
        
        return validEmail
        
        //        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        //
        //        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        //        return emailPred.evaluate(with: email)
    }
}

struct PaypalPaymentDetail{
    var transactionNonce: String?
    var email: String?
    var firstName: String?
    var lastName: String?
    var phone: String?
    var billingAddress: String?
    var shippingAddress: String?
}

extension UIViewController{
    var screenWidth:CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    var screenHeight:CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
    
}

class CustomAlbum {
    var coverimage = UIImage()
    var album = PHAssetCollection()
}

class CustomSlide: UISlider {
    
    @IBInspectable var trackHeight: CGFloat = 2
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        //set your bounds here
        return CGRect(origin: bounds.origin, size: CGSize(width: bounds.width, height: trackHeight))
    }
}

extension Data {
    var html2AttributedString: NSAttributedString? {
        do {
            return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            print("error:", error)
            return  nil
        }
    }
    var html2String: String { html2AttributedString?.string ?? "" }
}

extension StringProtocol {
    var html2AttributedString: NSAttributedString? {
        Data(utf8).html2AttributedString
    }
    var html2String: String {
        html2AttributedString?.string ?? ""
    }
}

extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension BaseViewController {
    
    func showCustomAlertWithCancelAndTwoActions(title:String, message:String, btn1Title: String, btn1Style: UIAlertAction.Style = .default, btn2Title: String, btn2Style: UIAlertAction.Style = .default, handler1: ((UIAlertAction) -> Void)? = nil, handler2: ((UIAlertAction) -> Void)? = nil, presentationCompletion completion:(() -> Void)? = nil ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: btn1Title, style: .default, handler: handler1))
        alertController.addAction(UIAlertAction(title: btn2Title, style: .default, handler: handler2))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: completion)
    }
    
    func showCustomAlertWithDeleteActionAndCancel(title:String, message:String, deleteActionHandler: ((UIAlertAction) -> Void)? = nil, cancelActionHandler: ((UIAlertAction) -> Void)? = nil, presentationCompletion completion:(() -> Void)? = nil ){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: deleteActionHandler))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelActionHandler))
        self.present(alertController, animated: true, completion: completion)
    }
    
    func getThumbnailImageFromVideoUrl(forUrl url: String, atImageView imageView: UIImageView, havingPlaceholder placeholder: UIImage = #imageLiteral(resourceName: "man")) {
        DispatchQueue.global().async { //1
            var asset: AVAsset? = AVAsset(url: URL(string: url)!) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset ?? AVAsset()) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    imageView.image = thumbImage //9
                    asset = nil
                }
            } catch {
                print(error.localizedDescription) //10
                DispatchQueue.main.async { //8
                    imageView.image = placeholder //9
                }
            }
        }
    }
    
    func loadImage(forUrl url: String, atImageView imageView: UIImageView, havingPlaceholder placeholder: UIImage = #imageLiteral(resourceName: "Image Plac Holder"), imageContentmode:  UIView.ContentMode = .scaleAspectFit){
        if let url = URL(string: url) {
            let options = ImageLoadingOptions(
                placeholder: placeholder,
                transition: .fadeIn(duration: 0.5),
                contentModes: .some(.init(success: imageContentmode, failure: imageContentmode, placeholder: imageContentmode)
                                   )
            )
            
            let h: CGFloat = CGFloat(1) * (screenWidth/2 - 10)
            
            var pixelSize: CGFloat {
                return h * UIScreen.main.scale
            }
            
            // 2
            var resizedImageProcessors: [ImageProcessing] {
                let imageSize = CGSize(width: pixelSize, height: pixelSize)
                return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
            }
            
            Nuke.loadImage(with: ImageRequest(url: url, processors: resizedImageProcessors), options: options, into: imageView, completion: nil)
        }
    }
    
    func loadImage(forUrl url: String, atImageView imageView: UIImageView, havingPlaceholderImage placeholder: UIImage = UIImage(), completion: ((_ result: Result<ImageResponse, ImagePipeline.Error>) -> Void)? = nil){
        if let url = URL(string: url) {
            let options = ImageLoadingOptions(
                placeholder: placeholder,
                transition: .fadeIn(duration: 0.5)
            )
            
            let h: CGFloat = CGFloat(1) * (screenWidth/2 - 10)
            
            var pixelSize: CGFloat {
                return h * UIScreen.main.scale
            }
            
            // 2
            var resizedImageProcessors: [ImageProcessing] {
                let imageSize = CGSize(width: pixelSize, height: pixelSize)
                return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
            }
            
            Nuke.loadImage(with: ImageRequest(url: url, processors: resizedImageProcessors), options: options, into: imageView, completion: completion)
            
        }
    }
    
    func loadImage(forUrl url: String, atImageView imageView: UIImageView, havingPlaceholder placeholder: UIImage = #imageLiteral(resourceName: "Image Plac Holder"), imageContentmode:  UIView.ContentMode = .scaleAspectFit, completion: ((Result<ImageResponse, ImagePipeline.Error>) -> Void)? = nil){
        if let url = URL(string: url) {
            let options = ImageLoadingOptions(
                placeholder: placeholder,
                transition: .fadeIn(duration: 0.5),
                contentModes: .some(.init(success: imageContentmode, failure: imageContentmode,
                                          placeholder: imageContentmode)
                )
            )
            
            let h: CGFloat = CGFloat(1) * (screenWidth/2 - 10)
            
            var pixelSize: CGFloat {
                return h * UIScreen.main.scale
            }
            
            // 2
            var resizedImageProcessors: [ImageProcessing] {
                let imageSize = CGSize(width: pixelSize, height: pixelSize)
                return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
            }
            
            Nuke.loadImage(with: ImageRequest(url: url, processors: resizedImageProcessors), options: options, into: imageView, completion: completion)
            
        }
    }
}

extension UIView{
    
    var screenWidth:CGFloat {
        get {
            return UIScreen.main.bounds.width
        }
    }
    
    var screenHeight:CGFloat {
        get {
            return UIScreen.main.bounds.height
        }
    }
    
    func loadImage(forUrl url: String, atImageView imageView: UIImageView, havingPlaceholder placeholder: UIImage = #imageLiteral(resourceName: "Image Plac Holder"), imageContentmode:  UIView.ContentMode = .scaleAspectFit, completion: ((Result<ImageResponse, ImagePipeline.Error>) -> Void)? = nil){
        if let url = URL(string: url) {
            let options = ImageLoadingOptions(
                placeholder: placeholder,
                transition: .fadeIn(duration: 0.5),
                contentModes: .some(.init(success: imageContentmode, failure: imageContentmode,
                                          placeholder: imageContentmode)
                )
            )
            
            let h: CGFloat = CGFloat(1) * (screenWidth/2 - 10)
            
            var pixelSize: CGFloat {
                return h * UIScreen.main.scale
            }
            
            // 2
            var resizedImageProcessors: [ImageProcessing] {
                let imageSize = CGSize(width: pixelSize, height: pixelSize)
                return [ImageProcessors.Resize(size: imageSize, contentMode: .aspectFill)]
            }
            
            Nuke.loadImage(with: ImageRequest(url: url, processors: resizedImageProcessors), options: options, into: imageView, completion: completion)
            
        }
    }
}

extension UITableViewCell{
    func animateLittle(seconds : Double = 0.2){
        UIView.animate(withDuration: seconds) { [weak self] in
            self?.contentView.layoutIfNeeded()
        }
    }
    
    func animateLittle(completion : @escaping (()->Void)){
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.contentView.layoutIfNeeded()
            self?.delay(0.1) {
                completion()
            }
        }
    }
    
    func delay(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
    
    func showCustomAlert(title:String, message:String){
        
        self.delay(0.3) { [weak self] in
            Loaf.dismiss(sender: self?.parentContainerViewController() ?? UIViewController())
            
            if title.lowercased().contains("error"){
                Loaf(message, state: .error, sender: self?.parentContainerViewController() ?? UIViewController()).show(.short)
            }else if title.lowercased().contains("success"){
                Loaf(message, state: .success, sender: self?.parentContainerViewController() ?? UIViewController()).show(.short)
            }else if title.lowercased().contains("delete"){
                Loaf(message, state: .custom(.init(backgroundColor: .red, icon: UIImage(named: "deleteLogo")?.blendedByColor(.white))), sender: self?.parentContainerViewController() ?? UIViewController()).show(.short)
            }else if title.lowercased().contains("warning"){
                Loaf(message, state: .warning, sender: self?.parentContainerViewController() ?? UIViewController()).show(.short)
            }else{
                
                self?.delay(0.5) { [weak self] in
                    Loaf(message, state: .custom(.init(backgroundColor: UIColor(hexColor: "009885"), textColor: .white,font : UIFont(name: "Roboto-Medium", size: 17)!, icon: nil, textAlignment: .center, width: .screenPercentage(0.7))), location: .bottom, presentingDirection: .vertical, dismissingDirection: .vertical, sender: self?.parentContainerViewController() ?? UIViewController()).show(.custom(2))
                }
            }
        }
    }
    
}
