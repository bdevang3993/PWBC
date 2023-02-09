//
//  ChangePasswordViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 17/03/21.
//

import UIKit
import Floaty

class ChangePasswordViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Change Password".localized()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
      //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(ChangePasswordViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
       // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension ChangePasswordViewController {
    func validation() -> Bool {
      
        if  txtoldPassword.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "Old".localized()  + "Password".localized(), viewController: self)
            return false
        }
        let userdefault = UserDefaults.standard
        var password:String = ""
        if userdefault.value(forKey: kPassword) != nil {
            password = userdefault.value(forKey: kPassword) as! String
        }
        if txtoldPassword.text != password {
            Alert().showAlert(message: "old password does not match please provide valied password".localized(), viewController: self)
            return false
        }
        if txtPassword.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "New".localized() + " "  + "Password".localized(), viewController: self)
            return false
        }
         if txtPassword.text!.count < 6 {
            Alert().showAlert(message: "please provide".localized() + " " + "at least 6 digit password".localized(), viewController: self)
            return false
        }
        if txtReEnterPassword.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "Re-Enter".localized() + " " + "Password".localized(), viewController: self)
            return false
        }
        if txtReEnterPassword.text!.count < 6 {
           Alert().showAlert(message: "please provide".localized() + " " + "at least 6 digit password".localized(), viewController: self)
           return false
       }
        if txtPassword.text != txtReEnterPassword.text {
            Alert().showAlert(message: "password does not match please provide new password and re-enter password both are same".localized(), viewController: self)
            return false
        }
        return true
    }
    
    func scheduleNotification() {
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Change Password"
        content.sound = UNNotificationSound.default
        content.body = "Your password is updated".localized()
        content.badge = 1
        content.categoryIdentifier = categoryIdentifire
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: categoryIdentifire,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
            appDelegate.notificationCenter.setNotificationCategories([category])
    }
}
extension ChangePasswordViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        
        floaty.addItem(SideMenuTitle.speak.selectedString(), icon: UIImage(named: "mic")) {item in
            SpeachListner.objShared.viewController = self
            self.setUpSpeechData()
        }
        self.view.addSubview(floaty)
    }
    func setUpSpeechData() {
        DispatchQueue.main.async {
            SpeachListner.objShared.selectedString = { [weak self] result in
                let split = result.split(separator: " ")
                let lastTwo = String(split.suffix(2).joined(separator: [" "]))
                print("Last String = \(lastTwo)")
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
}
