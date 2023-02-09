//
//  MBProgressHub.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 09/03/21.
//

import UIKit
import MBProgressHUD
final class MBProgressHub: NSObject {
    static var objShared = MBProgressHub()
     private override init() {
     }
    func showProgressHub(view:UIView) {
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    func hideProgressHub(view:UIView){
        MBProgressHUD.hide(for: view, animated: true)
    }
    
    public class func showLoadingSpinner(_ message: String? = "", sender: UIView) -> Void {
        let  HUD = MBProgressHUD.showAdded(to: sender, animated: true)
        HUD.label.text = message
        HUD.bezelView.color = UIColor.clear
        let imageViewAnimatedGif = UIImageView()
        imageViewAnimatedGif.image =  UIImage.gif(name: "loader")
        HUD.customView = UIImageView(image: imageViewAnimatedGif.image)
        HUD.mode = MBProgressHUDMode.customView
       // Change hud bezelview Color and blurr effect
        HUD.bezelView.color = UIColor.clear
        HUD.bezelView.tintColor = UIColor.clear
        HUD.bezelView.style = .solidColor
        HUD.bezelView.blurEffectStyle = .dark
        HUD.show(animated: true)

    }

    public class func dismissLoadingSpinner(_ sender: UIView) -> Void {
        MBProgressHUD.hide(for: sender, animated: true)
    }
}
