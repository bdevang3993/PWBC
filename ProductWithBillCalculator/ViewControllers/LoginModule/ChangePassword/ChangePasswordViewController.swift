//
//  ChangePasswordViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 17/03/21.
//

import UIKit
import Floaty

class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtoldPassword: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtReEnterPassword: UITextField!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var lblSepratorOldPassword: UILabel!
    @IBOutlet weak var lblSepratorReEnterPassword: UILabel!
    @IBOutlet weak var lblSepratorPassword: UILabel!
    var objChangePassword = ChangePasswordViewModel()
    var floaty = Floaty()
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Moved".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        objChangePassword.setHeaderView(headerView: self.viewHeader)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        txtoldPassword = setCustomSignUpTextField(self: txtoldPassword, placeHolder: "Old".localized() + " " + "Password".localized(), isBorder: false)
        txtPassword = setCustomSignUpTextField(self: txtPassword, placeHolder: "New".localized() + " " + "Password".localized(), isBorder: false)
        txtReEnterPassword = setCustomSignUpTextField(self: txtReEnterPassword, placeHolder: "Re-Enter".localized() + " " + "Password".localized(), isBorder: false)
        lblSepratorOldPassword.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorPassword.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorReEnterPassword.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        btnSubmit.setUpButton()
        self.btnSubmit.setTitle("SUBMIT".localized(using: "ButtonTitle"), for: .normal)
        self.layoutFAB()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    @IBAction func btnSubmitClicked(_ sender: Any) {
        let validation = self.validation()
        if validation {
            let userDefualt = UserDefaults.standard
            userDefualt.setValue(txtPassword.text, forKey: kPassword)
            userDefualt.synchronize()
            KeychainService.savePassword(token: txtPassword.text! as NSString)
            setAlertWithCustomAction(viewController: self, message: "Your password is updated".localized(), ok: { (isSuccess) in
                self.scheduleNotification()
                let objViewController:ViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ViewController") as! ViewController
                self.view.window?.rootViewController = objViewController
            }, isCancel: false) { (isSuccess) in
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
