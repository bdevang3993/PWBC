//
//  LoginViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import LocalAuthentication
import CoreData

class LoginViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
           if headerView.subviews.count > 0 {
               headerViewXib?.removeFromSuperview()
           }
           headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
           headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Login".localized()
           headerView.frame = headerViewXib!.bounds
           headerViewXib!.imgBack.isHidden = true
           headerViewXib!.btnBack.isHidden = true
           headerViewXib?.btnBack.setTitle("", for: .normal)
           headerViewXib!.lblBack.isHidden = true
          // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerView.backgroundColor = .clear//hexStringToUIColor(hex: strTheamColor)
           headerView.addSubview(headerViewXib!)
       }
}
extension ViewController {
    func setUpCustomField() {
        lblDonotAccount.text = "Don't have an account".localized() + "?"
        lblOR.text = "OR".localized()
        lblSignUp.text = "Signup here".localized() + "."
        lblForgotPassword.text = "Forgot Password".localized() + "?"
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtEmail = setCustomTextField(self: txtEmail, placeHolder: LoginTitle.emailTitle.selectedString(), isBorder: false)
        txtPassword = setCustomTextField(self: txtPassword, placeHolder: LoginTitle.password.selectedString(), isBorder: false)
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        DispatchQueue.main.async {
            self.loginViewModel.setHeaderView(headerView: self.viewHeader)
            self.viewDown.roundCorners(corners: [.topLeft,.topRight], radius: 20.0)
            self.viewDown.backgroundColor = hexStringToUIColor(hex: strTheamColor)
           // self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
            self.btnLogin.setUpButton()
            self.btnLogin.setTitle("LOGIN".localized(using: "ButtonTitle"), for: .normal)
            self.lblEmailSeparator.backgroundColor = hexStringToUIColor(hex: CustomColor().labelSepratorColor)
            self.lblPasswordSeprator.backgroundColor = hexStringToUIColor(hex: CustomColor().labelSepratorColor)
        }
    }
    func moveToNextViewController() {
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.view.window?.rootViewController = initialViewController
    }
    func loginUsingBioMatrix() {
        password = KeychainService.loadPassword()
        email = KeychainService.loadEmail()
        if  password.count > 0 {
            let context = LAContext()
            var error: NSError?
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Identify yourself!"
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply: { (isvalied, error) in
                    if isvalied {
                        DispatchQueue.main.async { [unowned self] in
                            let userDefault = UserDefaults.standard
                            userDefault.setValue(email, forKey: kEmail)
                            userDefault.setValue(password, forKey: kPassword)
                            userDefault.synchronize()
                            self.moveToNextViewController()
                        }
                    }else {
                        DispatchQueue.main.async {
                        Alert().showAlert(message: "\(error.debugDescription)", viewController: self)
                        }
                    }
                })
            } else {
                Alert().showAlert(message: "please check allowcation of face recognization or thumbnail".localized(), viewController: self)
            }
        } else {
            Alert().showAlert(message: "please we don't have credential so first time login with email and password".localized(), viewController: self)
        }
    }
    
    func validation() -> (Bool,Bool) {
        var isMobileNumber:Bool = false
        if self.txtEmail.text!.isEmpty {
            Alert().showAlert(message:"please provide".localized() + " " + "Email id/Mobile Number".localized(), viewController: self)
            return (false,false)
        }
        if !isValidEmail(emailStr: self.txtEmail.text!){
            let value = validatePhoneNumber(value: self.txtEmail.text!)
            if value == true {
                isMobileNumber = true
            } else {
                Alert().showAlert(message:"please provide".localized() + " " + "Email id/Mobile Number".localized(), viewController: self)
                return (false,false)
            }
        }
        if txtPassword.text!.isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + "Password".localized(), viewController: self)
            return (false,false)
        }
        if txtPassword.text!.count < 5 {
            Alert().showAlert(message: "please provide".localized() + " " + "at least 6 digit password".localized(), viewController: self)
            return (false,false)
        }
        let userDefault = UserDefaults.standard
        if (userDefault.value(forKey: kPassword) != nil) {
            let password = userDefault.value(forKey: kPassword)
            if txtPassword.text != (password as! String) {
                Alert().showAlert(message: "please provide".localized() + " " + "Email id/Mobile Number".localized() + ".", viewController: self)
                return (false,false)
            }
        }
       
        return (true,isMobileNumber)
    }
}
extension ViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}

