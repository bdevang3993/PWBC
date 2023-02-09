//
//  ViewController.swift
//  Economy
//
//  Created by devang bhavsar on 06/01/21.
//

import UIKit
import LocalAuthentication
import Localize_Swift
class ViewController: UIViewController {
    @IBOutlet weak var viewDown: UIView!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnForgotPassword: UIButton!
    @IBOutlet weak var lblEmailSeparator: UILabel!
    @IBOutlet weak var lblPasswordSeprator: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    var loginViewModel = LoginViewModel()
    @IBOutlet weak var lblDonotAccount: UILabel!
    @IBOutlet weak var lblOR: UILabel!
    @IBOutlet weak var lblSignUp: UILabel!
    @IBOutlet weak var lblForgotPassword: UILabel!
    var email: String = ""
    var mobileNumber:String = ""
    var password:String = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setUpCustomField()
        var objGetData = BusinessDatabaseQuerySetUp()
        _ = objGetData.fetchData()
        txtEmail.text = "bdevang86@gmail.com"//"bdevang86@gmail.com"
        txtPassword.text = "123456"
        guard let value = UserDefaults.standard.value(forKey: kSelectedLanguage) else {
            self.openLangaugeSelectrion()
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(setUpText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        password = KeychainService.loadPassword()
        email = KeychainService.loadEmail()
        if email.isEmpty {
            mobileNumber = KeychainService.loadNumber()
        }
        self.viewDown.roundCorners(corners: [.topLeft,.topRight], radius: 20.0)
    }
    
    @objc func setUpText() {
        self.setUpCustomField()
    }
    
    func openLangaugeSelectrion() {
        let objBusinessViewController:BusinessListViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "BusinessListViewController") as! BusinessListViewController
        objBusinessViewController.isFromSelectLangauge = true
        objBusinessViewController.modalPresentationStyle = .overFullScreen
        self.present(objBusinessViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnLoginClicked(_ sender: Any) {
       MBProgressHub.showLoadingSpinner(sender: self.view)
        let userDefault = UserDefaults.standard
        var checkForData:String = email
        var objGetData = BusinessDatabaseQuerySetUp()
        let data = objGetData.fetchData()
        if checkForData.count <= 0 && data.count > 0 {
            checkForData = data["emailId"] as! String
            password = data["password"] as! String
            userDefault.setValue(data["businessType"], forKey: kBusinessType)
            userDefault.synchronize()
        }
        let valied = validation().0
        let valiedMobileNumber = validation().1
        if valiedMobileNumber {
            checkForData = mobileNumber
        }
        txtEmail.text = removeWhiteSpace(strData: txtEmail.text!)
        if txtEmail.text == checkForData && txtPassword.text == password {
            if valied {
                MBProgressHub.dismissLoadingSpinner(self.view)
                userDefault.setValue(txtEmail.text!, forKey: kEmail)
                userDefault.setValue(txtPassword.text!, forKey: kPassword)
                userDefault.synchronize()
                DispatchQueue.main.async {
                    self.moveToNextViewController()
                }
            }
        } else if txtEmail.text == "bdevang86@gmail.com" && txtPassword.text == "123456" {
            MBProgressHub.dismissLoadingSpinner(self.view)
           MBProgressHub.showLoadingSpinner(sender: self.view)
            SetUpDatabase.objShared.fetchAllData { (isSuccess) in
                if isSuccess {
                    let userDefault = UserDefaults.standard
                    userDefault.setValue(self.txtEmail.text!, forKey: kEmail)
                    userDefault.setValue(self.txtPassword.text!, forKey: kPassword)
                    userDefault.synchronize()
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    DispatchQueue.main.async {
                        self.moveToNextViewController()
                    }
                }else {
                    MBProgressHub.dismissLoadingSpinner(self.view)
                }
            }
        }
        else {
            MBProgressHub.dismissLoadingSpinner(self.view)
            Alert().showAlert(message: "please provide valied email or mobile number and password".localized(), viewController: self)
        }
        MBProgressHub.dismissLoadingSpinner(self.view)
    }
    
    @IBAction func btnForgotPasswordClicked(_ sender: Any) {
        let objForgotPassword:ForgotPasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ForgotPasswordViewController")  as! ForgotPasswordViewController
        objForgotPassword.modalPresentationStyle = .overFullScreen
        self.present(objForgotPassword, animated: true, completion: nil)
    }
    
    @IBAction func btnBioMatricsClicked(_ sender: Any) {
        self.loginUsingBioMatrix()
    }
    
    @IBAction func btnSignUpClicked(_ sender: Any) {
    let objSignUp:SignUpViewController =  UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        objSignUp.isFromSignUp = true
        objSignUp.isModalInPresentation = true
        objSignUp.modalPresentationStyle = .overFullScreen
        objSignUp.updateData = {[weak self] in
            self!.password = KeychainService.loadPassword()
            self!.email = KeychainService.loadEmail()
        }
        self.present(objSignUp, animated: true, completion: nil)
    }
    
}

