//
//  AddPayerDetailViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/10/21.
//

import UIKit
import Floaty
class AddPayerDetailViewModel: NSObject {
    var headerViewXib:CommanView?
    var payerDetailsQuery = PayerDetailsQuery()
    var objPayerData = PayerData(strName: "", strURL: "", id: 0)
    var strURlLink:String = ""
    var isFirstTimeClicked:Bool = true
    var newId:Int = -1
    
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Payer".localized() + " " + "Details".localized()
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AddPayerDetailViewController(), action: #selector(AddPayerDetailViewController.backClicked), for: .touchUpInside)
        //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnHeader.isHidden = false
        headerViewXib?.btnHeader.setImage(UIImage(systemName:"trash"), for: .normal)
        headerViewXib?.btnHeader.tintColor = UIColor.white
        headerViewXib?.btnHeader.addTarget(AddPayerDetailViewController(), action: #selector(AddPayerDetailViewController.deleteClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
      
    }
    
}
extension AddPayerDetailViewController {
    
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            DispatchQueue.main.async {
                //self?.setUpQRAPI(qrImage: value)
                let data = value.parseQR()
                if data.count > 0 {
                    self!.objAddPayerDetailViewModel.strURlLink = data[0]
                    self!.qrImage.image = value
                } else {
                    Alert().showAlert(message: "Didn't get image with QrCode please try again".localized(), viewController: self!)
                }
              //  self!.strUpiLink = data[0]
            }
        }
    }
    
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: self)
        MBProgressHub.dismissLoadingSpinner(self.view)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            DispatchQueue.main.async {
                let data = value.parseQR()
                if data.count > 0 {
                    self!.objAddPayerDetailViewModel.strURlLink = data[0]
                    self!.qrImage.image = value
                } else {
                    Alert().showAlert(message: "Didn't get image with QrCode please try again".localized(), viewController: self!)
                }
                //self!.strUpiLink = data[0]
            }
        }
    }
    func alertForImage() {
        let alertController = UIAlertController(title: "Image Selection".localized(), message: kSelectOption.localized(), preferredStyle: .alert)
        // Create the actions
        let cameraAction = UIAlertAction(title: "Camera".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
          MBProgressHub.showLoadingSpinner(sender: self.view)
           self.takeImageFromCamera()
        }
        let galleryAction = UIAlertAction(title: "Gallery".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
           MBProgressHub.showLoadingSpinner(sender: self.view)
            self.takeImageFromGallery()
        }
        // Add the actions
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func fetchId() {
        objAddPayerDetailViewModel.payerDetailsQuery.getRecordsCount { (id) in
            self.objAddPayerDetailViewModel.newId = id + 1
        }
    }
    
    func saveInDatabase() {
        MBProgressHub.dismissLoadingSpinner(self.view)
        let name = txtBusinessName.text?.capitalizingFirstLetter()
        _ = objAddPayerDetailViewModel.payerDetailsQuery.fetchAllDataByName(name: name!) { (arrAllData) in
            if arrAllData.count > 0 {
//                self.objAddPayerDetailViewModel.objPayerValue = arrAllData[0]
                Alert().showAlert(message: "Business name already exist please update or give another name".localized(), viewController: self)
            } else {
                self.saveQuery(name: name!)
            }
        } failure: { (isFailed) in
            self.saveQuery(name: name!)
        }
    }
    
    func saveQuery(name:String) {
        _ = self.payerDetailsQuery.saveinDataBase(id: self.objAddPayerDetailViewModel.newId, strName: name, strURL: self.objAddPayerDetailViewModel.strURlLink)
        DispatchQueue.main.async {
            MBProgressHub.dismissLoadingSpinner(self.view)
            self.updateAllData!()
            self.dismiss(animated: true, completion: nil)
        }
    }
}
extension AddPayerDetailViewController:UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtAmount {
            textField.text = textField.text!.convertedDigitsToLocale(Locale(identifier: "EN"))
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddPayerDetailViewController: FloatyDelegate {
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
                self?.filterSearchWithString(strCustomerName: result)
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
    func filterSearchWithString(strCustomerName:String) {

        let newData = strCustomerName.lowercased().components(separatedBy: "Back".lowercased())
        if newData.count > 1 && objAddPayerDetailViewModel.isFirstTimeClicked  {
            objAddPayerDetailViewModel.isFirstTimeClicked = false
            self.backClicked()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.objAddPayerDetailViewModel.isFirstTimeClicked = true
            }
        }
    }
}
