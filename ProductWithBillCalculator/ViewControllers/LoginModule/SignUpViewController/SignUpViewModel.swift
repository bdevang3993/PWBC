//
//  SignUpViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 06/01/21.
//

import UIKit
import SBPickerSelector
import IQKeyboardManagerSwift
import Floaty

class SignUpViewModel: NSObject {
    
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView,isfromSignUp:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
         headerView.frame = headerViewXib!.bounds
        if isfromSignUp {
            headerViewXib!.lblTitle.text = "Sign Up".localized()
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib!.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(SignUpViewController(), action: #selector(SignUpViewController.backClicked), for: .touchUpInside)
          //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        }else {
            headerViewXib!.lblTitle.text = "Profile".localized()
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "drawer")
            headerViewXib!.lblBack.isHidden = true
           // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
            headerViewXib?.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(SignUpViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension SignUpViewController {
    
    func configureData() {
        txtAddress.delegate = self
        txtName.delegate = self
        txtEmail.delegate = self
        txtPassword.delegate = self
        txtContactNumber.delegate = self
        txtGSTPercentage.delegate = self
        txtGSTPercentage.keyboardType = .decimalPad
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCornerSetUp.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        txtName = setCustomSignUpTextField(self: txtName, placeHolder: "Business".localized() + " " + "Name".localized(), isBorder: false)
        txtAddress = setCustomSignUpTextField(self: txtAddress, placeHolder: "Business".localized() + " " + "Address".localized(), isBorder: false)
        txtGSTIN = setCustomSignUpTextField(self: txtGSTIN, placeHolder: "GST".localized() + " " + "Number".localized(), isBorder: false)
        txtBusinessType = setCustomSignUpTextField(self: txtBusinessType, placeHolder: "Business".localized() + " " + "Type".localized(), isBorder: false)
        txtContactNumber = setCustomSignUpTextField(self: txtContactNumber, placeHolder: "Contact".localized() + " " + "Number".localized(), isBorder: false)
        txtGSTPercentage = setCustomSignUpTextField(self: txtGSTPercentage, placeHolder: "GST".localized() + " " + "%" , isBorder: false)
        txtEmail = setCustomSignUpTextField(self: txtEmail, placeHolder: "Email".localized(), isBorder: false)
        txtPassword = setCustomSignUpTextField(self: txtPassword, placeHolder: "Password".localized(), isBorder: false)
        txtRepassword = setCustomSignUpTextField(self: txtRepassword, placeHolder: "Re-Enter".localized() + " " + "Password".localized(), isBorder: false)
        lblAgeChecking.text = "Please click here if you are more then 4 years".localized()
        lblTermsAndCondition.text = "I have  accept".localized() + " " + "Terms of Uses".localized() + ", " + "Privacy Policy".localized() + " " + "and".localized() + " " + "Stander Apple Terms of Use(EULA)".localized() + "."
        btnSubmit.setUpButton()
        self.setUpViewAsPerProfile()
        self.setUpViewAsperTheam()
        self.setupMultipleTapLabel()
    }
    func setupMultipleTapLabel() {
        let text = (lblTermsAndCondition.text)!
        let underlineAttriString = NSMutableAttributedString(string: text)
        let termsRange = (text as NSString).range(of: "Terms of Uses".localized())
        let privacyRange = (text as NSString).range(of: "Privacy policy".localized())
        let standerAppleRange = (text as NSString).range(of: "Stander Apple Terms of Use(EULA)".localized())
        underlineAttriString.addAttribute(.foregroundColor, value: hexStringToUIColor(hex: "597380"), range: termsRange)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        underlineAttriString.addAttribute(.foregroundColor, value:hexStringToUIColor(hex: "597380"), range: privacyRange)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)
        underlineAttriString.addAttribute(.foregroundColor, value: hexStringToUIColor(hex: "597380"), range: standerAppleRange)
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: standerAppleRange)
        lblTermsAndCondition.attributedText = underlineAttriString
        let tapAction = UITapGestureRecognizer(target: self, action: #selector(self.tapLabel(gesture:)))
        lblTermsAndCondition.isUserInteractionEnabled = true
        lblTermsAndCondition.addGestureRecognizer(tapAction)
    }
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if gesture.didTapAttributedTextInLabel(label: lblTermsAndCondition, targetText: "Terms of Uses".localized()) {
                self.moveToTermsAndCondition(isfromPrivacy: false, isfromBack: true, isFromEULA: false)
        } else if gesture.didTapAttributedTextInLabel(label: lblTermsAndCondition, targetText: "Privacy policy".localized()) {
                self.moveToTermsAndCondition(isfromPrivacy: true, isfromBack: true, isFromEULA: false)
            } else {
                self.moveToTermsAndCondition(isfromPrivacy: false, isfromBack: true, isFromEULA: true)
            }
    }
    func setUpDisplayData() {
      
            let allData = objBusinessDatabaseQuerySetUp.fetchData()
            if let name = allData["businessName"] {
                txtName.text = (name as! String)
            }
            if let address = allData[kAddress] {
                txtAddress.text = (address as! String)
            }
            if let emailId = allData["emailId"] {
                txtEmail.text = (emailId as! String)
            }
            if let gstNumber = allData["gstInNumber"] {
                txtGSTIN.text = (gstNumber as! String)
            }
            if let contactNumber = allData["contactNumber"] {
                txtContactNumber.text = (contactNumber as! String)
            }
            if let password = allData["password"] {
                txtPassword.text = (password as! String)
            }
            if let businessType = allData["businessType"] {
                txtBusinessType.text = (businessType as! String)
            }
            if let gst = allData[kGSTPercentage] {
                txtGSTPercentage.text = "\(gst)%"
            }
    }
    
    func setUpViewAsPerProfile() {
        if isFromSignUp {
            objBusinessDatabaseQuerySetUp.getRecordsCount { (isSuccess) in
                if isSuccess  {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
                        setAlertWithCustomAction(viewController: self, message: "You can register only one user per app".localized(), ok: { (isSuccess) in
                            self.dismiss(animated: true, completion: nil)
                        }, isCancel: false) { (isSuccess) in
                        }
                    }
                }
            }
            viewHeaderTbl.frame.size.height = 1060//847
            if UIDevice.current.userInterfaceIdiom == .pad {
                viewHeaderTbl.frame.size.height = 1200
                layoutConstraintAgeImageTop.constant = 20.0
            }
            layoutConstraintPasswordHeight.constant = 64.0
            layoutConstraintSubmitTop.constant = 60.0
            self.btnSubmit.setTitle("SUBMIT".localized(using: "ButtonTitle"), for: .normal)
            layOutConstriantTopTerms.constant = 30.0
            layoutConstraintheightTerms.constant = 100.0
            txtContactNumber.isEnabled = true
            lblTermsAndCondition.isHidden = false
            btnTermsAndCondition.isHidden = false
            
  
        } else {
            lblAgeChecking.text = ""
            txtName.isEnabled = false
            txtName.textColor = .lightGray
            txtBusinessType.isEnabled = false
            txtBusinessType.textColor = .lightGray
            btnBusinessType.isEnabled = false
            imgDownBusinessType.isHidden = true
            imgCheckeForAge.isHidden = true
            imgTermsAndCondition.isHidden = true
            txtGSTIN.attributedPlaceholder = NSAttributedString(string: txtGSTIN.placeholder!,
                                                                attributes: [NSAttributedString.Key.foregroundColor: hexStringToUIColor(hex: strTheamColor)])
            viewHeaderTbl.frame.size.height = 733
            if UIDevice.current.userInterfaceIdiom == .pad {
                viewHeaderTbl.frame.size.height = 1000//800
            }
            layoutConstraintPasswordHeight.constant = 0.0
            layoutConstraintHeightforAge.constant = 0.0
            layoutConstraintSubmitTop.constant = -60.0
            self.btnSubmit.setTitle("UPDATE".localized(using: "ButtonTitle"), for: .normal)
            layOutConstriantTopTerms.constant = 0.0
            layoutConstraintheightTerms.constant = 0.0
            lblTermsAndCondition.isHidden = true
            btnTermsAndCondition.isHidden = true
            self.layoutFAB()
        }
    }
    
    func setUpViewAsperTheam() {
        lblnameSeprator.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorGSTIN.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorNumber.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorEmail.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSeparatorPassword.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSeparatorRePassword.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorBusinessType.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorGST.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblSepratorAddress.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        imgDownBusinessType.tintColor = hexStringToUIColor(hex: strTheamColor)
    }
    
    //MARK:- Picker View
    func validatation() -> Bool {

        if txtName.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "Business".localized() + " " + "Name".localized(), viewController: self)
            return false
        }
        else if txtAddress.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "Business".localized() + " " + "Address".localized(), viewController: self)
            return false
        }
        else if txtBusinessType.text!.count <= 0 {
            Alert().showAlert(message: "please select".localized() + " " + "Business".localized() + " " + "Type".localized(), viewController: self)
            return false
        }
        else if txtContactNumber.text!.count > 0  && txtContactNumber.text!.count < 10 {
            Alert().showAlert(message: "please provide".localized() + " " + "Valied".localized() + " " + "Number", viewController: self)
            return false
        }
        else if self.txtEmail.text!.count > 0 && !isValidEmail(emailStr: txtEmail.text!) {
            Alert().showAlert(message: "please provide".localized() + " " + "Valied".localized() + " " + "Email".localized(), viewController: self)
            return false
        }
        else if txtGSTPercentage.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "GST".localized() + " " + "Charge".localized(), viewController: self)
            return false
        }
        else if txtPassword.text!.count <= 0{
            Alert().showAlert(message: "please provide".localized() + " " + "Password".localized(), viewController: self)
            return false
        }
        else if txtPassword.text!.count < 6 {
            Alert().showAlert(message: "please provide".localized() + " " + "at least 6 digit password".localized(), viewController: self)
            return false
        }
        let data = txtGSTPercentage.text?.split(separator: "%")
        let totalCount = Double(String(data![0]).convertedDigitsToLocale(Locale(identifier: "EN")))
        txtGSTPercentage.text = "\(totalCount ?? 0)" + "%"
        if totalCount! > 100.0 {
            Alert().showAlert(message: "please provide".localized() + " " + "less then 100%".localized(), viewController: self)
            return false
        }
        if isFromSignUp {
            if txtRepassword.text!.count <= 0 {
                Alert().showAlert(message: "please provide".localized() + " " + "Password".localized() + " " + "again".localized(), viewController: self)
                return false
            }
            else if txtRepassword.text != txtPassword.text {
                Alert().showAlert(message: "password does not match please re-enter".localized(), viewController:self)
                return false
            }
            let image = UIImage(named: "unChecked")
            let compare = imgCheckeForAge.image?.isEqualToImage(image: image!)
            if compare! {
                Alert().showAlert(message: "If you are more then 4 years then please click on check box on your age is more then 4 years".localized(), viewController: self)
                return false
            }
            let compareCondition = imgTermsAndCondition.image?.isEqualToImage(image: image!)
            if compareCondition! {
                Alert().showAlert(message: "please check it out for the user aggrememt and terms of use and privacy policy".localized(), viewController: self)
                return false
            }
        }
        let number = txtContactNumber.text?.convertedDigitsToLocale(Locale(identifier: "EN"))
        txtContactNumber.text = number!
        return true
    }
    
    func moveToTermsAndCondition(isfromPrivacy:Bool,isfromBack:Bool,isFromEULA:Bool) {
        IQKeyboardManager.shared.resignFirstResponder()
        let objTerms:TermsAndConditionViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        objTerms.isfromPrivacy = isfromPrivacy
        objTerms.isfromBack = isfromBack
        objTerms.isFromEULA = isFromEULA
        objTerms.modalPresentationStyle = .overFullScreen
        self.present(objTerms, animated: true, completion: nil)
    }
}
extension SignUpViewController: UITextFieldDelegate{
  
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == txtGSTPercentage {
            if txtGSTPercentage.text!.count > 0 {
                txtGSTPercentage.text?.removeLast()
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }
            }
        
        if textField == txtContactNumber {
            if textField.text!.count > 11 {
                Alert().showAlert(message: kMobileDigitAlert.localized(), viewController: self)
                return false
            }
        }
        if textField == txtGSTIN {
            if textField.text!.count > 15 {
                Alert().showAlert(message: kGSTINAleart.localized(), viewController: self)
                return false
            }
        }
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtGSTPercentage == textField {
            txtGSTPercentage.text = txtGSTPercentage.text! +  "%"
        }
    }
    
}
extension SignUpViewController: FloatyDelegate {
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
