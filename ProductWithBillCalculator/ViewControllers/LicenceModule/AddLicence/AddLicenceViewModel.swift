//
//  AddLicenceViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 08/09/21.
//

import UIKit
import SBPickerSelector
import Floaty
class AddLicenceViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrItemList = [ItemList]()
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var tblDisplayData:UITableView?
    var objLicenceDetailsQuery = LicenceDetailsQuery()
    var licenceid:Int = -1
    var imageData = Data()
    let objImagePickerViewModel = ImagePickerViewModel()
    var isLicenceNameExist:Bool = false
    var isFromBack:Bool = true
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
//        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    func setHeaderView(headerView:UIView,isFromAdd:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
         headerView.frame = headerViewXib!.bounds
        if isFromAdd {
            headerViewXib!.lblTitle.text = "Add".localized() + " " + "License".localized()
        } else {
            headerViewXib!.lblTitle.text = "Edit".localized() + " " + "License".localized()
        }
           
            headerViewXib!.btnBack.isHidden = false
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib!.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(AddLicenceViewController(), action: #selector(AddLicenceViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
        self.setUpCustomDelegate()
        self.fetchId()
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func setUpData(objLicenceList:LicenceList,isfromAdd:Bool) -> Bool  {
        arrItemList.removeAll()
        var isEditable:Bool = false
        var isReciptAttached:Bool = false
        if isfromAdd {
            isEditable = true
        }
        arrItemList.append(ItemList(strTitle: "License".localized() + " " + "Name".localized(), strDescription: objLicenceList.licenceName,isPicker:false,isEditable: isEditable))
        arrItemList.append(ItemList(strTitle: "License".localized() + " " + "Number".localized(), strDescription: objLicenceList.licenceNumber,isPicker:false,isEditable: true))
        arrItemList.append(ItemList(strTitle: "Payment".localized() + " " + "Date".localized(), strDescription: objLicenceList.paymentDate,isPicker:true,isEditable: isEditable))
        arrItemList.append(ItemList(strTitle: "Register".localized() + " " + "Date".localized(), strDescription: objLicenceList.registerDate,isPicker:true,isEditable: isEditable))
        arrItemList.append(ItemList(strTitle: "Last".localized() + " " + "Date".localized(), strDescription: objLicenceList.lastDate,isPicker:true,isEditable: isEditable))
        arrItemList.append(ItemList(strTitle: "Price".localized(), strDescription: objLicenceList.price, isPicker: false, isEditable: true))
        if let recipts = objLicenceList.licenceImage {
            self.imageData = recipts
            let bcf = ByteCountFormatter()
                  bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
                  bcf.countStyle = .file
            let string = bcf.string(fromByteCount: Int64(self.imageData.count))
            if string == "Zero KB" {
                isReciptAttached = false
            }
            else {
                isReciptAttached = true
            }
        }
        tblDisplayData?.reloadData()
        return isReciptAttached
    }
    func setUpCell(index:Int,cell:LoanTextFieldTableViewCell) {
        let data:ItemList = arrItemList[index]
        cell.lblTitle.text = data.strTitle
        cell.txtDescription.delegate = self
        cell.txtDescription.text = data.strDescription
        cell.txtDescription.tag = index
        cell.btnSelection.tag = index
        if data.isPicker {
            cell.txtDescription.isEnabled = false
            cell.btnSelection.isEnabled = true
            cell.imgDown.isHidden = false
            if cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption.localized()
            }
        }  else {
            cell.txtDescription.isEnabled = true
            cell.btnSelection.isEnabled = false
            cell.imgDown.isHidden = true
        }
        if data.isEditable {
            cell.txtDescription.isEnabled = true
        }
        else {
            cell.txtDescription.isEnabled = false
        }
        cell.selectedIndex = {[weak self] index in
            self?.datePicker(index: index)
        }
    }
    func datePicker(index:Int) {
        let date = Date()
        if index == 4 {
            SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear).cancel {
                print("cancel, will be autodismissed")
            }.set { values in
                if let values = values as? [Date] {
                    self.arrItemList[index].strDescription = self.dateFormatter.string(from: values[0])
                    self.tblDisplayData!.reloadData()
                }
            }.present(into: viewController!)
        } else {
            SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
                print("cancel, will be autodismissed")
            }.set { values in
                if let values = values as? [Date] {
                    self.arrItemList[index].strDescription = self.dateFormatter.string(from: values[0])
                    self.tblDisplayData!.reloadData()
                }
            }.present(into: viewController!)
        }
    }
    func fetchId() {
        objLicenceDetailsQuery.getRecordsCount { (id) in
            self.licenceid = id + 1
        }
    }
    
    func saveDataInDatabase(saveData save:@escaping(Bool) -> Void) {
        if self.isLicenceNameExist {
            Alert().showAlert(message: "This licence already exist".localized(), viewController: viewController!)
            return
        }
        let value = Double(arrItemList[5].strDescription.convertedDigitsToLocale(Locale(identifier: "EN")))
        arrItemList[5].strDescription = "\(value ?? 0)"
        if value == nil {
            let message:String = "please select".localized() + " " + "Price".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard"
            Alert().showAlert(message: message, viewController: viewController!)
            return
        }
        let saved = objLicenceDetailsQuery.saveinDataBase(licenceid: self.licenceid, licenceName: arrItemList[0].strDescription.capitalizingFirstLetter(), licenceNumber: arrItemList[1].strDescription, registerDate: arrItemList[2].strDescription, paymentDate: arrItemList[3].strDescription, lastDate: arrItemList[4].strDescription, licenceImage: imageData, price: arrItemList[5].strDescription)
            save(saved)
    }
    
    func updateInDatabase(updateData update:@escaping(Bool) -> Void,objLicenceData:LicenceList) {
        let value = Double(arrItemList[5].strDescription.convertedDigitsToLocale(Locale(identifier: "EN")))
        arrItemList[5].strDescription = "\(value ?? 0.0)"
        if value == nil {
            let message:String = "please select".localized() + " " + "Price".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard"
            Alert().showAlert(message: message, viewController: viewController!)
            return
        }
        
        let updateValue = objLicenceDetailsQuery.update(licenceid: objLicenceData.licenceid, licenceNumber: arrItemList[1].strDescription, registerDate: arrItemList[2].strDescription, paymentDate: arrItemList[3].strDescription, lastDate: arrItemList[4].strDescription, price: arrItemList[5].strDescription, licenceImage: imageData)
        update(updateValue)
    }
    
    func deleteFromDatabase(licenceid:Int,deleteData delete:@escaping(Bool) -> Void) {
        let deleteData = objLicenceDetailsQuery.delete(licenceid: licenceid)
        delete(deleteData)
    }
    
    func checkLicenceNameExist(licenceName:String) {
        objLicenceDetailsQuery.fetchAllDataByName(name: licenceName.capitalizingFirstLetter()) { (result) in
            if result.count > 0 {
                self.isLicenceNameExist = true
            }
        } failure: { (isFailed) in
            self.isLicenceNameExist = false
        }

    }
    
    func takeImageFromCamera() {
        self.objImagePickerViewModel.openCamera(viewController: viewController!)
        self.objImagePickerViewModel.selectImageFromCamera = { [weak self] value in
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            if success.0 == true {
                self!.imageData = success.1
            } else {
                Alert().showAlert(message: "your Image is not saved please try again".localized(), viewController: self!.viewController!)
            }
        }
    }
    func takeImageFromGallery() {
        self.objImagePickerViewModel.openGallery(viewController: viewController!)
        self.objImagePickerViewModel.selectedImageFromGalary = { [weak self] value in
            // self?.imgProfile.image = value
            let success = saveImage(image: value)
            DispatchQueue.main.async {
                if success.0 == true {
                    self!.imageData = success.1
                }else {
                    Alert().showAlert(message: "your Image is not saved please try again".localized(), viewController: self!.viewController!)
                }
            }
        }
    }
    
    func moveToImage(isFromAdd:Bool,isReciptAttached:Bool) {
        if isFromAdd || !isReciptAttached {
            let alertController = UIAlertController(title: kAppName, message: kSelectOption, preferredStyle: .alert)
            // Create the actions
            let cameraAction = UIAlertAction(title: "Camera".localized(), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.takeImageFromCamera()
            }
            let galleryAction = UIAlertAction(title: "Gallery".localized(), style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.takeImageFromGallery()
            }
            // Add the actions
            alertController.addAction(cameraAction)
            alertController.addAction(galleryAction)
            // Present the controller
            viewController!.present(alertController, animated: true, completion: nil)
        } else {
            let objShowImage:ImageDisplayViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "ImageDisplayViewController") as! ImageDisplayViewController
            objShowImage.modalPresentationStyle = .overFullScreen
            objShowImage.imageData = imageData
            objShowImage.updateClosure = {[weak self] in
                
            }
            viewController!.present(objShowImage, animated: true, completion: nil)
        }

    }
}
extension AddLicenceViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return self.arrItemList.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130.0
        } else {
            return 100.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrItemList[index] as! T
    }
}
extension AddLicenceViewModel:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "0.0" {
            textField.text = ""
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                let value = textField.text?.dropLast()
                self.arrItemList[textField.tag].strDescription =  String(value!)
                return true
            }
        }
        let data:String = textField.text! + string
        self.arrItemList[textField.tag].strDescription =  data.lowercased()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.checkLicenceNameExist(licenceName: textField.text!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension AddLicenceViewController: FloatyDelegate {
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
        let data = strCustomerName.lowercased().components(separatedBy: "Back".localized().lowercased())
        if data.count > 1 {
            if objAddLicenceViewModel.isFromBack {
                objAddLicenceViewModel.isFromBack = false
                DispatchQueue.main.async {
                    self.backClicked()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.objAddLicenceViewModel.isFromBack = true
                }
            }
           return
        }
    }
}
