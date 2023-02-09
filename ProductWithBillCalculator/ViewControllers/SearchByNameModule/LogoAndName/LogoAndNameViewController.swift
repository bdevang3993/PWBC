//
//  LogoAndNameViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 16/03/21.
//

import UIKit
import Floaty

class LogoAndNameViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var btnImagePick: UIButton!
    @IBOutlet weak var txtCompanyName: UITextField!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtNumber: UITextField!
    @IBOutlet weak var lblCompanyLogo: UILabel!
    @IBOutlet weak var txtDiscount: UITextField!
    
    var objLogoViewModel = LogoAndNameViewModel()
    var  objImagePickerViewModel = ImagePickerViewModel()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.setConfigureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Moved".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
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

    @IBAction func btnImagePickClicked(_ sender: Any) {
        self.pickImage()
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        
        let userDefault = UserDefaults.standard
       
        if self.txtNumber.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "Contact".localized() + " " + "Number".localized(), viewController: self)
        }
        else {
            let number = Double(self.txtNumber.text!.convertedDigitsToLocale(Locale(identifier: "EN")))
            self.txtNumber.text = self.txtNumber.text!.convertedDigitsToLocale(Locale(identifier: "EN"))
            if number == nil {
                let strMessage = "please select".localized() + " " + "Contact".localized() + " " + "Number".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard"
                Alert().showAlert(message:strMessage , viewController: self)
                return
            }
            if self.txtCompanyName.text!.count > 0 {
                userDefault.set(self.txtCompanyName.text, forKey: kUpiId)
            }
            userDefault.set(self.txtNumber.text, forKey: kContactNumber)
            let value = self.txtDiscount.text?.split(separator: "%")
            if value!.count > 0 {
                let selectedvalue = Double(String(value![0]).convertedDigitsToLocale(Locale(identifier: "EN")))
                self.txtDiscount.text = String(value![0]).convertedDigitsToLocale(Locale(identifier: "EN")) + "%"
                if selectedvalue == nil {
                    let strMessage = "please select".localized() + " " + "Discount".localized() + " "  + "using".localized() + " " + "English" + " " + "Keyboard"
                    Alert().showAlert(message:strMessage , viewController: self)
                    return
                }
            }
            if self.txtDiscount.text!.count > 0 {
                userDefault.set(self.txtDiscount.text, forKey: kDiscount)
            }
            userDefault.synchronize()
        }
        if imgView.image != nil {
            let success = self.saveImage(image: self.imgView.image!,name:kLogo)
            if success {
                userDefault.set(kLogo, forKey: kLogo)
                userDefault.synchronize()
                setAlertWithCustomAction(viewController: self, message: kDataSaveSuccess.localized(), ok: { (isSuccess) in
                    self.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isSuccess) in
                }
            }
            else {
                Alert().showAlert(message: "Please save logo another time".localized(), viewController: self)
            }
        } else {
            Alert().showAlert(message: "please select".localized() + " " + "logo".localized(), viewController: self)
        }
    }
    
    @IBAction func btnAddQRCodeClicked(_ sender: Any) {
        objImagePickerViewModel.openGallery(viewController: self)
        objImagePickerViewModel.selectedImageFromGalary = {[weak self] selectedImage in
            DispatchQueue.main.async {
                let data = selectedImage.parseQR()
                let userDefault = UserDefaults.standard
                userDefault.set(data[0], forKey: kQRCode)
                userDefault.synchronize()
            }
        }
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
}
