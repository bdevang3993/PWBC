//
//  AddProductViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit
import SBPickerSelector
import IQKeyboardManagerSwift
import Floaty

class ProductViewModel: NSObject {
    var headerViewXib:CommanView?
    var isFromAddDetails:Bool = false
    var objCustomTableView = CustomTableView()
    var arrdisplayData = [ItemList]()
    var objProductQuery = ProductQuery()
    var objProductDetailsQuery = ProductDetailsQuery()
    var arrAllItems = [Items]()
    var selectedItem:Items?
    var isPriceEditing:Bool = false
    var isFromMedical:Bool = false
    var tableView:UITableView?
    var viewController:UIViewController?
    var strSelctedType:String = "Unit".localized()
    var isAddFirstTime:Bool = true
    var isIteamAddFirstTime:Bool = false
    var isBackClicked:Bool = true
    var isSpeackFirstTime:Bool = true
    var strSelectedStringFilter:TaSelectedValueSuccess?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromAddDetails {
            headerViewXib!.lblTitle.text = "Add".localized() + " " + "Product".localized()
        }else {
            headerViewXib!.lblTitle.text = "Edit".localized() + " " + "Product".localized()
        }
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AddProductViewController(), action: #selector(AddProductViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func configureData(isFromAdd:Bool,headerView:UIView,objDisplayData:Items) {
        self.isFromAddDetails = isFromAdd
        self.setHeaderView(headerView: headerView)
        self.setUpDisplayData(objDisplayData: objDisplayData)
        self.setUpCustomDelegate()
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }

    func setUpDisplayData(objDisplayData:Items) {
        arrdisplayData.removeAll()
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.itemName.strSelectedTitle(), strDescription: objDisplayData.strItemsName , isPicker:true,isEditable:isFromAddDetails == true ? true:false))
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.quantity.strSelectedTitle(), strDescription: "\(objDisplayData.quantity)" ,isPicker:false,isEditable:true))
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.quality.strSelectedTitle(), strDescription: "\(objDisplayData.numberOfPice)" ,isPicker:false,isEditable:true))
        var price:String = ""
        if objDisplayData.totalPrice != nil {
            price = "\(objDisplayData.totalPrice)"
        }
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.totalPrice.strSelectedTitle(), strDescription: price, isPicker:false,isEditable:false))
        selectedItem = objDisplayData
    }
    
    func setUpItemList(index:Int,viewController:UIViewController)  {
        IQKeyboardManager.shared.resignFirstResponder()
        if arrdisplayData.count > 0 {
            arrdisplayData[1].strDescription = "0.0"
            arrdisplayData[2].strDescription = "1"
            arrdisplayData[3].strDescription = "0.0"
        }
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.strTypeOfSearch = TypeOfSearch.productName.selectedType()
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.backFromProduct = {[weak self] index in
            //SpeachListner.objShared.setUpData(viewController: viewController)
            self!.strSelectedStringFilter!("Reset")
        }
        objSearchProduct.updateProductData = {[weak self] (result,index) in
           
            self!.selectedItem = result
            self!.arrdisplayData[0].strDescription = self!.selectedItem!.strItemsName
            let strProductName = "Product".localized() + " " + "Name".localized() + " " + self!.arrdisplayData[0].strDescription
            if self!.isSpeackFirstTime {
                self?.isSpeackFirstTime = false
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Added".localized())
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strProductName)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self?.isSpeackFirstTime = true
            }
            self!.tableView!.reloadData()
            if isSpeackSpeechOn {
                SpeachListner.objShared.setUpData(viewController: viewController)
            }
                SpeachListner.objShared.selectedString = { [weak self] result in
                    let split = result.split(separator: " ")
                    let lastTwo = String(split.suffix(2).joined(separator: [" "]))
                    print("result in produt = \(lastTwo)")
                    self!.strSelectedStringFilter!(lastTwo)
                    self!.isIteamAddFirstTime = false
            }
            if self?.selectedItem?.strQuantityType == kTablet {
                self!.isFromMedical = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                    self?.showAlertForChooseOption()
                }
            }
        }
        viewController.present(objSearchProduct, animated: true, completion: nil)
    }
    
    func showAlertForChooseOption() {
        let refreshAlert = UIAlertController(title: kAppName, message: "please select".localized()  + " " +  "Unit".localized(), preferredStyle: UIAlertController.Style.alert)

        refreshAlert.addAction(UIAlertAction(title: "1" + " " + "Pice".localized(), style: .default, handler: { (action: UIAlertAction!) in
            self.strSelctedType = "Pice".localized()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "1" + " " + "Unit".localized(), style: .cancel, handler: { (action: UIAlertAction!) in
            self.strSelctedType = "Unit".localized()
        }))

        viewController!.present(refreshAlert, animated: true, completion: nil)
    }
    
    func moveToAddIteam(viewController:UIViewController) {
        let objAddItem:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objAddItem.modalPresentationStyle = .overFullScreen
        objAddItem.isFromProduct = false
        objAddItem.isFromAddItem = true
        viewController.present(objAddItem, animated: true, completion: nil)
    }
    
    func setUpCellData(cell:LoanTextFieldTableViewCell,index:Int,viewController:UIViewController) {
        cell.txtDescription.delegate = self
        let data:ItemList = numberOfItemAtIndex(index: index)
        cell.lblTitle.text = data.strTitle
        cell.txtDescription.text = data.strDescription
        cell.txtDescription.keyboardType = .decimalPad
        if data.isPicker == true {
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
            cell.btnSelection.tag = index
            if data.strDescription.count <= 0 {
                cell.txtDescription.text = kSelectOption.localized() 
            }
        } else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
        }
        
        cell.selectedIndex = {[weak self] index in
            let data:ItemList =  self!.numberOfItemAtIndex(index: index)
            if data.strTitle == ItemDisplayTItle.itemName.strSelectedTitle() {
                self?.setUpItemList(index: index, viewController: viewController)
            }
        }
    }
    
    func calculateData() {
        self.selectedItem!.numberOfPice = Int(self.arrdisplayData[2].strDescription)!
        if self.arrdisplayData[0].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "first".localized() + " " + "Iteam".localized(), viewController: viewController!)
            return
        }
        var totalPrice:Double = 0.0
        let unitPrice:Double = self.selectedItem!.price
        let units:Double = Double(self.selectedItem!.quantityPerUnit)
        if self.strSelctedType == "Unit".localized() {
            if Double(self.arrdisplayData[1].strDescription)! > 0.0 && !isPriceEditing {
                var totalUnits = Double(self.arrdisplayData[1].strDescription)! / units
                if self.selectedItem?.strQuantityType == "Kg".localized() || self.selectedItem?.strQuantityType == "Lt".localized() {
                       totalUnits = totalUnits * 1000
                }
                totalPrice = totalUnits * unitPrice * Double(self.selectedItem!.numberOfPice)
                self.arrdisplayData[3].strDescription = "\(totalPrice.rounded(toPlaces: 1))"
                self.selectedItem?.totalPrice = totalPrice
                self.selectedItem?.quantity = Double(self.arrdisplayData[1].strDescription)!.rounded(toPlaces: 1)
            } else if Double(self.arrdisplayData[3].strDescription)! > 0.0 {
                if self.selectedItem?.strQuantityType == kTablet {
                    if ((Int(self.arrdisplayData[3].strDescription)! % Int(self.selectedItem!.price)) != 0) {
                        Alert().showAlert(message: "Please provide multiplier by \(self.selectedItem!.price)", viewController: viewController!)
                        return
                    }
                }
                var totalUnits:Double = (Double(self.arrdisplayData[3].strDescription)!/unitPrice) * units
                if self.selectedItem?.strQuantityType == "Kg".localized() || self.selectedItem?.strQuantityType == "Lt".localized() {
                    totalUnits = totalUnits / 1000
                }
                self.selectedItem?.quantity = totalUnits.rounded(toPlaces:1)
                self.selectedItem?.totalPrice = Double(self.arrdisplayData[3].strDescription)!.rounded(toPlaces: 1)
                self.arrdisplayData[1].strDescription = "\(String(describing: self.selectedItem!.quantity))"
            }
        } else {
            if Double(self.arrdisplayData[1].strDescription)! > 0.0 && !isPriceEditing {
                let totalUnits = Double(self.arrdisplayData[1].strDescription)! / (units * Double(self.selectedItem!.numberOfPice))
                totalPrice = totalUnits * unitPrice
                self.arrdisplayData[3].strDescription = "\(totalPrice.rounded(toPlaces: 1))"
                self.selectedItem?.totalPrice = totalPrice
                self.selectedItem?.quantity = Double(self.arrdisplayData[1].strDescription)!.rounded(toPlaces: 1)
            } else if Double(self.arrdisplayData[3].strDescription)! > 0.0 {
                var totalUnits:Double = ((Double(self.arrdisplayData[3].strDescription)!/unitPrice) * units)
                 totalUnits = (Double(self.selectedItem!.numberOfPice) * totalUnits) / 10
                self.selectedItem?.quantity = totalUnits.rounded(toPlaces:1)
                self.selectedItem?.totalPrice = Double(self.arrdisplayData[3].strDescription)!.rounded(toPlaces: 1)
                self.arrdisplayData[1].strDescription = "\(String(describing: self.selectedItem!.quantity))"
            }
        }
        self.tableView?.reloadData()
    }
    
    func updateProductDataInDataBase(objProductDetialWithCustomer:ProductDetialWithCustomer,update updateBlock: @escaping ((Bool) -> Void)) {
        let strSelectedQuentity = "\(self.selectedItem?.quantity ?? 0.0)" + " " + self.selectedItem!.strQuantityType.lowercased()
        let updatedData = objProductDetailsQuery.update(price: self.selectedItem!.totalPrice, quantity: strSelectedQuentity, productDetailId: objProductDetialWithCustomer.productDetailId, status: objProductDetialWithCustomer.status, numberOfPice: objProductDetialWithCustomer.numberOfPice)
        if updatedData {
            updateBlock(true)
        } else {
            updateBlock(false)
        }
    }
    func showPriceAlert(index:Int) {
        if index == 1 {
            Alert().showAlert(message: "please select".localized() + " " + "Product".localized() + " " + "Quantity".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard", viewController: viewController!)
        }
        if index == 2 {
            Alert().showAlert(message: "please select".localized() + " " + "Product".localized() + " " + "Quality".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard", viewController: viewController!)
        }
        if index == 3 {
            Alert().showAlert(message: "please select".localized() + " " + "Product".localized() + " " + "Price".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard", viewController: viewController!)
        }

    }
}
extension ProductViewModel:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 || textField.tag == 2 {
            isPriceEditing = false
        } else {
            isPriceEditing = true
        }
        if textField.text == "0.0" {
            textField.text = ""
        }
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            textField.text = "0.0"
        }
        if self.selectedItem?.strItemsName != "Other" {
            let value = Double(textField.text!.convertedDigitsToLocale(Locale(identifier: "EN")))
            textField.text = "\(value)"
            if value == nil {
                self.showPriceAlert(index: textField.tag)
            } else {
                self.calculateData()
            }
            
        } else {
            let value = Double(textField.text!.convertedDigitsToLocale(Locale(identifier: "EN")))
            self.arrdisplayData[3].strDescription = "\(value)"
            textField.text = "\(value)"
            if value == nil {
                self.showPriceAlert(index: textField.tag)
            } else {
                self.selectedItem!.totalPrice = value!
            }
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    self.arrdisplayData[textField.tag].strDescription = String(value!).convertedDigitsToLocale(Locale(identifier: "EN"))
                    return true
                }
            }
            self.arrdisplayData[textField.tag].strDescription = textField.text! + string
        self.arrdisplayData[textField.tag].strDescription = self.arrdisplayData[textField.tag].strDescription.convertedDigitsToLocale(Locale(identifier: "EN"))
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tableView!.reloadData()
        return true
    }
    
}
extension ProductViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrdisplayData.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130.0
        } else {
            return 100.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrdisplayData[index] as! T
    }
}
extension AddProductViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        
        floaty.addItem(SideMenuTitle.speak.selectedString(), icon: UIImage(named: "mic")) {item in
            SpeachListner.objShared.viewController = self
            self.setUpSpeachButton()
        }
        
        self.view.addSubview(floaty)
    }
    func setUpSpeachButton() {
        DispatchQueue.main.async {
           // SpeachListner.objShared.setUpStopData()
            SpeachListner.objShared.selectedString = { [weak self] result in
                let split = result.split(separator: " ")
                let lastTwo = String(split.suffix(2).joined(separator: [" "]))
                print("Last String = \(lastTwo)")
                self?.setUpSpeakValue(result: result)
                // SpeachListner.objShared.setUpStopData()
                //Alert().showAlert(message: result, viewController: self!)
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
    func setUpSpeakValue(result:String) {
        if result.contains("Start Recording".localized()) || result.contains("please check the internet connection".localized()){
            Alert().showAlert(message: "please check the internet connection".localized() + "or" + "" + "Start Recording".localized(), viewController: self)
            return
        }
        let newData = result.split(separator: " ")
        let split = newData
        let lastTwo = String(split.suffix(2).joined(separator: [" "]))
        print("result in produt = \(lastTwo)")
        
        let backData = lastTwo.lowercased().components(separatedBy:"Back".localized().lowercased())
        if backData.count > 1  {
            if objProductViewModel.isBackClicked {
                objProductViewModel.isBackClicked = false
                DispatchQueue.main.async {
                    self.backClicked()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.objProductViewModel.isBackClicked = true
                }
            }
            return
        }
        
        if newData.count > 1  && lastTwo.lowercased().contains("Price".localized().lowercased()){
            let value:String = String(newData[1])
            if value.isNumeric {
              //  SpeachListner.objShared.setUpStopData()
                print("Given number is = \(newData[1])")
                self.objProductViewModel.isPriceEditing = true
                self.objProductViewModel.arrdisplayData[3].strDescription = String(newData[1])
                self.objProductViewModel.selectedItem!.totalPrice = Double(newData[1])!
                if self.objProductViewModel.selectedItem?.strItemsName != "Other" {
                    self.objProductViewModel.calculateData()
                }
            }
            print("selected Price = \(newData[1])")
            
        }
        if newData.count > 1 && lastTwo.lowercased().contains("Quality".localized().lowercased()) {
            //  let value:String = String(newData[1])
            let data = lastTwo.lowercased().components(separatedBy: "Quality".localized().lowercased())
            if let range = lastTwo.lowercased().range(of: "Quality ".localized().lowercased()) {
                let value:String = String(lastTwo[range.upperBound...])
                if !data.last!.isEmpty && value.count > 0 {
                    let lastValue:String = removeWhiteSpace(strData: data.last!)
                    let number = lastValue.spelled
                    print(number) // prints "123.456.7891"
                    if number > 0 {
                        // SpeachListner.objShared.setUpStopData()
                        print("Given number is = \(number)")
                        if objProductViewModel.isSpeackFirstTime {
                            self.objProductViewModel.isSpeackFirstTime = false
                            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Added".localized())
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.objProductViewModel.isSpeackFirstTime = true
                        }
                        self.objProductViewModel.arrdisplayData[2].strDescription = String(number)
                        //self.objProductViewModel.selectedItem!.quantityPerUnit = Double(number)
                        if self.objProductViewModel.selectedItem?.strItemsName != "Other" {
                            self.objProductViewModel.calculateData()
                        }
                    }
                }
            }
            //print(phone)
        }
        if newData.count > 1  && lastTwo.lowercased().contains("Quantity".localized().lowercased()) {
            let data = lastTwo.lowercased().components(separatedBy: "Quantity".localized().lowercased())
            if let range = lastTwo.lowercased().range(of: "Quantity".localized().lowercased()) {
                let value:String = String(lastTwo[range.upperBound...])
                if !data.last!.isEmpty && value.count > 0 {
                    var lastValue:String = removeWhiteSpace(strData: data.last!)
                    if  !lastValue.isNumeric {
                        lastValue =  String(split.suffix(1).joined(separator: [" "]))
                        var number:Int = 0
                        if strSelectedLocal == "en" {
                             number = lastValue.spelled
                        } else {
                             number = lastValue.spelledHind
                        }
                       
                        lastValue = String(number)
                        }
                    if objProductViewModel.isSpeackFirstTime {
                        self.objProductViewModel.isSpeackFirstTime = false
                        SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Added".localized())
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.objProductViewModel.isSpeackFirstTime = true
                    }
                    self.objProductViewModel.isPriceEditing = false
                    self.objProductViewModel.arrdisplayData[1].strDescription = String(lastValue)
                    self.objProductViewModel.selectedItem!.quantity = Double(lastValue)!
                    if self.objProductViewModel.selectedItem?.strItemsName != "Other" {
                        self.objProductViewModel.calculateData()
                    }
                }
            }
            
        }
        if lastTwo.lowercased().contains("Add".localized().lowercased()) && objProductViewModel.isAddFirstTime {
            objProductViewModel.isAddFirstTime = false
            self.btnSaveClicked(AnyClass.self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.objProductViewModel.isAddFirstTime = true
            }
        }
        if lastTwo.lowercased().contains("Name".localized().lowercased()) && objProductViewModel.isIteamAddFirstTime == false {
            objProductViewModel.isIteamAddFirstTime = true
            DispatchQueue.main.async {
                self.objProductViewModel.setUpItemList(index: 0, viewController: self)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.objProductViewModel.isIteamAddFirstTime = false
            }
        }
    }
}
