//
//  LogoAndNameViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/03/21.
//

import UIKit
import Floaty
class LogoAndNameViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Logo".localized()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(LogoAndNameViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension LogoAndNameViewController {
    func setConfigureData() {
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        if UIDevice.current.userInterfaceIdiom == .pad {
            btnSave.frame.size.height = 100.0
            btnSave.layoutIfNeeded()
        }
        lblCompanyLogo.text = "Company".localized() + " " + "Logo".localized()
        txtCompanyName.placeholder = "Upi id".localized()
        txtNumber.placeholder = "Contact".localized() + " " + "Number".localized()
        txtDiscount.placeholder = "Discount".localized()
        txtCompanyName.setLeftPaddingPoints(10.0)
        txtCompanyName.layer.borderWidth = 1.0
        txtCompanyName.layer.borderColor = UIColor.white.cgColor
        txtNumber.setLeftPaddingPoints(10.0)
        txtNumber.layer.borderWidth = 1.0
        txtNumber.layer.borderColor = UIColor.white.cgColor
        txtNumber.setLeftPaddingPoints(10.0)
        txtDiscount.layer.borderWidth = 1.0
        txtDiscount.layer.borderColor = UIColor.white.cgColor
        txtCompanyName.delegate = self
        txtNumber.delegate = self
        txtDiscount.delegate = self
        txtDiscount.keyboardType = .numberPad
        objLogoViewModel.setHeaderView(headerView: self.viewHeader)
        txtCompanyName.textColor = hexStringToUIColor(hex: strTheamColor)
        txtDiscount.textColor = hexStringToUIColor(hex: strTheamColor)
        lblCompanyLogo.textColor = hexStringToUIColor(hex: strTheamColor)
        txtNumber.textColor = hexStringToUIColor(hex: strTheamColor)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        btnSave.setUpButton()
        self.layoutFAB()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        let userDefault = UserDefaults.standard
        if userDefault.value(forKey: kUpiId) != nil{
            self.txtCompanyName.text = (userDefault.value(forKey: kUpiId) as! String)
        }
        if userDefault.value(forKey: kContactNumber) != nil{
            self.txtNumber.text = (userDefault.value(forKey: kContactNumber) as! String)
        }
        if userDefault.value(forKey:kDiscount) != nil {
            self.txtDiscount.text = (userDefault.value(forKey: kDiscount) as! String)
        }
        if  userDefault.value(forKey: kLogo) != nil {
            self.imgView.image = getSavedImage(named: kLogo)
        } else {
            self.imgView.image = UIImage(named: "Logo")
        }
    }
    func pickImage() {
        objImagePickerViewModel.openGallery(viewController: self)
        objImagePickerViewModel.selectedImageFromGalary = {[weak self] selectedImage in
            self?.imgView.image = selectedImage
        }
    }
    func saveImage(image: UIImage,name:String) -> Bool {
        guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("\(name).png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
}
extension LogoAndNameViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if txtDiscount.text == "0%" {
            txtDiscount.text = ""
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    return true
                }
            }
        
        if textField == txtNumber {
            if textField.text!.count > 9 {
                txtNumber.resignFirstResponder()
                Alert().showAlert(message: kMobileDigitAlert.localized(), viewController: self)
                return false
            }
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtDiscount == textField {
            let check = txtDiscount.text?.contains("%")
            if  txtDiscount.text == "%" || txtDiscount.text == "" {
                txtDiscount.text = "0%"
            }else if !check! {
                txtDiscount.text = txtDiscount.text! +  "%"
            }
        }
    }
}
extension LogoAndNameViewController: FloatyDelegate {
    func layoutFAB() {
        let floaty = Floaty()
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
