//
//  AdvanceOrderViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 30/09/21.
//

import UIKit
import IQKeyboardManagerSwift
import SBPickerSelector
import Floaty

class AdvanceOrderViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrdisplayData = [ItemList]()
    var objCustomTableView = CustomTableView()
    var isFromAddDetails:Bool = false
    var selectedItem:Items?
    var tableView:UITableView?
    var objCustomer:CustomerList?
    var isFromMedical:Bool = false
    var strSelctedType:String = "Unit"
    var viewController:UIViewController?
    var isPriceEditing:Bool = false
    var isFromBack:Bool = true
    var isFromCall:Bool = true
    var isDataMatch:Bool = true
    var objProductDetailsQuery = ProductDetailsQuery()
    var objOrderDetailsQuery = OrderDetailsQuery()
    var objProductQuery = ProductQuery()
    var productDetailId:Int = -1
    var arrProductDetialWithCustomer = [ProductDetialWithCustomer]()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
  var objAdvanceDetail = AdvanceAllData(productDetailId: -1, date: "", time: "", advance: 0.0, remains: 0.0, pickupNumber: "", customerId: -1, productId: -1, customerName: "",customerNumber:"", iteamName: "", paiedDate: "", price: 0.0, quantity: "0.0", status: kBorrowStatus, billNumber: "")
    
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromAddDetails {
            headerViewXib!.lblTitle.text = "Add".localized() + " " + "Order".localized()
        }else {
            headerViewXib!.lblTitle.text = "Edit".localized() + " " + "Order".localized()
            if objAdvanceDetail.remains > 0.0 {
                headerViewXib!.btnHeader.isHidden = false
                headerViewXib!.btnHeader.setTitle("Paied".localized(), for: .normal)
            } else {
                headerViewXib!.btnHeader.isHidden = true
            }
           
        }
        headerViewXib!.btnHeader.addTarget(AdvanceOrderViewController(), action: #selector(AdvanceOrderViewController.paiedClicked), for: .touchUpInside)
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AdvanceOrderViewController(), action: #selector(AdvanceOrderViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func fetchItemData(strItemName:String) {
        objProductQuery.fetchDataByItemName(itemName: strItemName) { (result) in
            self.selectedItem = result[0]
        } failure: { (isfailed) in
        }
    }
    
    func setUpDisplayData() {
        arrdisplayData.removeAll()
        if isFromAddDetails == false {
            productDetailId = objAdvanceDetail.productDetailId
            self.fetchItemData(strItemName: objAdvanceDetail.iteamName)
        }
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.itemName.strSelectedTitle(), strDescription: objAdvanceDetail.iteamName , isPicker:isFromAddDetails == true ? true:false,isEditable:isFromAddDetails == true ? true:false))
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.quantity.strSelectedTitle(), strDescription: "\(objAdvanceDetail.quantity)" ,isPicker:false,isEditable:true))
        var price:String = ""
        if objAdvanceDetail.price != nil {
            price = "\(objAdvanceDetail.price)"
        }
        
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.totalPrice.strSelectedTitle(), strDescription: price, isPicker:false,isEditable:false))
        
        arrdisplayData.append(ItemList(strTitle: AdvanceTitle.advance.strSelectedTitle(), strDescription: "\(objAdvanceDetail.advance)", isPicker:false,isEditable:true))
        
        arrdisplayData.append(ItemList(strTitle: AdvanceTitle.remains.strSelectedTitle(), strDescription: "\(objAdvanceDetail.remains)", isPicker:false,isEditable:false))
        
        arrdisplayData.append(ItemList(strTitle: AdvanceTitle.customerName.strSelectedTitle(), strDescription: objAdvanceDetail.customerName, isPicker: isFromAddDetails == true ? true:false, isEditable: isFromAddDetails == true ? true:false))
        
        arrdisplayData.append(ItemList(strTitle: AdvanceTitle.customerNumber.strSelectedTitle(), strDescription: objAdvanceDetail.customerNumber, isPicker: false, isEditable: false))
        
        arrdisplayData.append(ItemList(strTitle: AdvanceTitle.pickUpPersonNumber.strSelectedTitle(), strDescription: objAdvanceDetail.pickupNumber, isPicker: false, isEditable: true))
        
        arrdisplayData.append(ItemList(strTitle: AdvanceTitle.date.strSelectedTitle(), strDescription: objAdvanceDetail.date, isPicker: true, isEditable: true))
        
        arrdisplayData.append(ItemList(strTitle: AdvanceTitle.time.strSelectedTitle(), strDescription: objAdvanceDetail.time, isPicker: true, isEditable: true))
        
        // selectedItem = objDisplayData
    }
    
    func getRecordId()  {
        objProductDetailsQuery.getRecordsCount { (value) in
            self.productDetailId = value + 1
        }
    }
    
    func setUpItemList(index:Int,viewController:UIViewController)  {
        IQKeyboardManager.shared.resignFirstResponder()
        arrdisplayData[1].strDescription = "0.0"
        arrdisplayData[2].strDescription = "0.0"
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.modalPresentationStyle = .overFullScreen
        objSearchProduct.strTypeOfSearch = TypeOfSearch.productName.selectedType()
        objSearchProduct.updateProductData = {[weak self] (result,index) in
            self!.selectedItem = result
            self!.arrdisplayData[0].strDescription = self!.selectedItem!.strItemsName
            self!.objAdvanceDetail.iteamName = self!.selectedItem!.strItemsName
            self!.tableView!.reloadData()
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
        let refreshAlert = UIAlertController(title: kAppName, message: "Please select".localized() + " " + "Unit".localized(), preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "1" + " " + "Pice".localized() , style: .default, handler: { (action: UIAlertAction!) in
            self.strSelctedType = "Pice".localized()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "1" + " " + "Unit".localized() , style: .cancel, handler: { (action: UIAlertAction!) in
            self.strSelctedType = "Unit".localized()
        }))
        
        viewController!.present(refreshAlert, animated: true, completion: nil)
    }
    
    func setUpCellData(cell:LoanTextFieldTableViewCell,index:Int,viewController:UIViewController) {
        cell.txtDescription.delegate = self
        cell.txtDescription.tag = index
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
        
        if data.isEditable == true {
            cell.txtDescription.isEnabled = true
        } else {
            cell.txtDescription.isEnabled = false
        }
        if (index == 6 || index == 7) && !isFromAddDetails {
            cell.btnCall.isHidden = false
        } else {
            cell.btnCall.isHidden = true
        }
        
        if index == 1 || index == 3 || index == 4 {
            cell.txtDescription.keyboardType = .numberPad
        } else {
            cell.txtDescription.keyboardType = .default
        }
        
        cell.selectedIndex = {[weak self] index in
            if index == 0 {
                let data:ItemList =  self!.numberOfItemAtIndex(index: index)
                if data.strTitle == ItemDisplayTItle.itemName.strSelectedTitle() {
                    self?.setUpItemList(index: index, viewController: viewController)
                }
            } else if index == 5 {
                self?.setUpName(viewController: viewController)
            } else if index == 8 {
                self?.setupPickerDate()
            } else {
                self?.setupPickerTime()
            }
        }
        cell.callclicked = {[weak self] index in
            self?.callPerson(index: index)
        }
    }
    func callPerson(index:Int) {
        self.arrdisplayData[index].strDescription.makeACall()
    }
    
    func setUpName(viewController:UIViewController) {
        let objSearchCustomer:SearchProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchCustomer.modalPresentationStyle = .overFullScreen
        objSearchCustomer.strTypeOfSearch = TypeOfSearch.customerName.selectedType()
        objSearchCustomer.updateSearchCustomer = {[weak self] result in
            self!.objAdvanceDetail.customerName = result.strCustomerName
            self!.arrdisplayData[5].strDescription = result.strCustomerName
            self!.objAdvanceDetail.customerNumber = result.strMobileNumber
            self!.arrdisplayData[6].strDescription = result.strMobileNumber
            self!.objCustomer = result
            self!.tableView?.reloadData()
        }
        viewController.present(objSearchCustomer, animated: true, completion: nil)
    }
    func setupPickerDate() {
        IQKeyboardManager.shared.resignFirstResponder()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear).cancel {
            print("cancel, will be autodismissed")
        }.set { values in
            if let values = values as? [Date] {
                self.arrdisplayData[8].strDescription = self.dateFormatter.string(from: values[0])
                self.objAdvanceDetail.date = self.dateFormatter.string(from: values[0])
                self.tableView?.reloadData()
            }
        }.present(into: viewController!)
    }
    func setupPickerTime() {
        IQKeyboardManager.shared.resignFirstResponder()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateHour).cancel {
            print("cancel, will be autodismissed")
        }.set { values in
            if let values = values as? [Date] {
                self.arrdisplayData[9].strDescription = converttimeFromDate(date: values[0])
                self.objAdvanceDetail.time = self.arrdisplayData[9].strDescription
                self.tableView?.reloadData()
            }
        }.present(into: viewController!)
    }
    
    func calculateData() {
        if self.arrdisplayData[0].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "first".localized() + " " + "Iteam".localized(), viewController: viewController!)
            return
        }
        var totalPrice:Double = 0.0
        let unitPrice:Double = self.selectedItem!.price
        let units:Double = Double(self.selectedItem!.quantityPerUnit)
        if self.strSelctedType == "Unit" {
            self.arrdisplayData[1].strDescription = self.arrdisplayData[1].strDescription.convertedDigitsToLocale(Locale(identifier: "EN"))
            if Double(self.arrdisplayData[1].strDescription)! > 0.0 && !isPriceEditing {
                var totalUnits = Double(self.arrdisplayData[1].strDescription)! / units
                if self.selectedItem?.strQuantityType == "Kg".localized() || self.selectedItem?.strQuantityType == "Lt".localized() {
                    totalUnits = totalUnits * 1000
                }
                totalPrice = totalUnits * unitPrice
                self.arrdisplayData[2].strDescription = "\(totalPrice.rounded(toPlaces: 1))"
                self.selectedItem?.totalPrice = totalPrice
                self.selectedItem?.quantity = Double(self.arrdisplayData[1].strDescription)!.rounded(toPlaces: 1)
            } else if Double(self.arrdisplayData[2].strDescription)! > 0.0 {
                
                if self.selectedItem?.strQuantityType == kTablet {
                    if ((Int(self.arrdisplayData[2].strDescription)! % Int(self.selectedItem!.price)) != 0) {
                        Alert().showAlert(message: "Please provide multiplier by \(self.selectedItem!.price)", viewController: viewController!)
                        return
                    }
                }
                var totalUnits:Double = (Double(self.arrdisplayData[2].strDescription)!/unitPrice) * units
                if self.selectedItem?.strQuantityType == "Kg".localized() || self.selectedItem?.strQuantityType == "Lt".localized() {
                    totalUnits = totalUnits / 1000
                }
                self.selectedItem?.quantity = totalUnits.rounded(toPlaces:1)
                self.selectedItem?.totalPrice = Double(self.arrdisplayData[2].strDescription)!.rounded(toPlaces: 1)
                self.arrdisplayData[1].strDescription = "\(String(describing: self.selectedItem!.quantity))"
            }
        } else {
            if Double(self.arrdisplayData[1].strDescription)! > 0.0 && !isPriceEditing {
                let totalUnits = Double(self.arrdisplayData[1].strDescription)! / (units * Double(self.selectedItem!.numberOfPice))
                totalPrice = totalUnits * unitPrice
                self.arrdisplayData[2].strDescription = "\(totalPrice.rounded(toPlaces: 1))"
                self.selectedItem?.totalPrice = totalPrice
                self.selectedItem?.quantity = Double(self.arrdisplayData[1].strDescription)!.rounded(toPlaces: 1)
            } else if Double(self.arrdisplayData[2].strDescription)! > 0.0 {
                var totalUnits:Double = ((Double(self.arrdisplayData[2].strDescription)!/unitPrice) * units)
                totalUnits = (Double(self.selectedItem!.numberOfPice) * totalUnits) / 10
                self.selectedItem?.quantity = totalUnits.rounded(toPlaces:1)
                self.selectedItem?.totalPrice = Double(self.arrdisplayData[2].strDescription)!.rounded(toPlaces: 1)
                self.arrdisplayData[1].strDescription = "\(String(describing: self.selectedItem!.quantity))"
            }
        }
        objAdvanceDetail.quantity = self.arrdisplayData[1].strDescription
        objAdvanceDetail.price = Double(self.arrdisplayData[2].strDescription) ?? 0.0
        if isFromAddDetails == false {
            self.setUpAdvance(strValue: self.arrdisplayData[3].strDescription)
        }
        self.tableView?.reloadData()
    }
    
    func validation() -> Bool {
        if self.arrdisplayData[0].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Iteam".localized(), viewController: viewController!)
            return false
        }
        if self.arrdisplayData[1].strDescription.isEmpty  || self.arrdisplayData[1].strDescription == "0.0" {
            Alert().showAlert(message: "please select".localized() + " " + "Quantity".localized(), viewController: viewController!)
            return false
        }
        if self.arrdisplayData[2].strDescription.isEmpty  || self.arrdisplayData[2].strDescription == "0.0" {
            Alert().showAlert(message: "please select".localized() + " " + "Price".localized(), viewController: viewController!)
            return false
        }
        if self.arrdisplayData[3].strDescription.isEmpty  || self.arrdisplayData[3].strDescription == "0.0" {
            Alert().showAlert(message: "please provide".localized() + " " + "Advance".localized(), viewController: viewController!)
            return false
        }
//        if self.arrdisplayData[4].strDescription.isEmpty  || self.arrdisplayData[4].strDescription == "0.0" {
//            Alert().showAlert(message: "Please provide remains", viewController: viewController!)
//            return false
//        }
        if self.arrdisplayData[5].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Customer".localized(), viewController: viewController!)
            return false
        }
        if self.arrdisplayData[6].strDescription.isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + "Customer".localized() + " " + "Number".localized(), viewController: viewController!)
            return false
        }
        if self.arrdisplayData[8].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Date".localized(), viewController: viewController!)
            return false
        }
        if self.arrdisplayData[9].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Time".localized(), viewController: viewController!)
            return false
        }
        return true
    }
    
    func setUpAdvance(strValue:String) {
        self.arrdisplayData[2].strDescription = self.arrdisplayData[2].strDescription.convertedDigitsToLocale(Locale(identifier: "EN"))
        let newprice = Double(self.arrdisplayData[2].strDescription)
        guard let price = newprice else {
            Alert().showAlert(message: "Please select".localized() + " " + "Price".localized(), viewController: viewController!)
            return
        }
        guard let advance = Double(strValue) else {
            Alert().showAlert(message: "Please select".localized() + " " + "Price".localized(), viewController: viewController!)
            return
        }
        if price <= 0 {
            Alert().showAlert(message: "Please select".localized() + " " + "Total Price".localized(), viewController: viewController!)
            return
        }
        let remains = price - advance
        self.arrdisplayData[4].strDescription = "\(remains)"
        self.tableView?.reloadData()
    }
    
    func saveInDatabase(saveData save:@escaping(Bool) -> Void) {
        let remainsValue = Double(self.arrdisplayData[4].strDescription)!
        var stastus:String = objAdvanceDetail.status
        var paiedDate:String = objAdvanceDetail.paiedDate
        if remainsValue > 0 {
        } else {
            stastus = kPaiedStatus
            paiedDate = dateFormatter.string(from: Date())
        }
        let saveData = objProductDetailsQuery.saveinDataBase(productDetailId: productDetailId, customerId: objCustomer!.customerId, productId: objAdvanceDetail.productId, customerName: self.arrdisplayData[5].strDescription, date: objAdvanceDetail.date, iteamName: objAdvanceDetail.iteamName, paiedDate: paiedDate, price: objAdvanceDetail.price, quantity: objAdvanceDetail.quantity + " " + self.selectedItem!.strQuantityType, status: stastus, numberOfPice: 1)
        if saveData {
            let allData = objOrderDetailsQuery.saveinDataBase(productDetailId: productDetailId, date: self.objAdvanceDetail.date, time:  self.objAdvanceDetail.time, advance: Double(self.arrdisplayData[3].strDescription)!, remains: Double(self.arrdisplayData[4].strDescription)!, pickupNumber: self.arrdisplayData[7].strDescription, customerNumber: objCustomer!.strMobileNumber)
            if allData {
                save(true)
            } else {
                save(false)
            }
        } else {
            save(false)
        }
    }
    func fetchProductData() {
         objProductDetailsQuery.fetchAllDataByProductId(productDetailId: "\(objAdvanceDetail.productDetailId)") { (result) in
            self.arrProductDetialWithCustomer = result
            print("result product Data = \( self.arrProductDetialWithCustomer)")
        } failure: { (isFailed) in
        }
    }
    
    func updateInDatabase(updateData update:@escaping(Bool) -> Void) {
        let updated = objProductDetailsQuery.update(price: objAdvanceDetail.price, quantity: objAdvanceDetail.quantity, productDetailId: productDetailId, status: objAdvanceDetail.status, numberOfPice: 1)
        if updated {
            let updateOrder = objOrderDetailsQuery.update(productDetailId: productDetailId, date: self.objAdvanceDetail.date, time: self.objAdvanceDetail.time, advance: Double(self.arrdisplayData[3].strDescription)!, remains: Double(self.arrdisplayData[4].strDescription)!, pickupNumber: self.arrdisplayData[7].strDescription)
            if updateOrder {
                update(true)
            } else {
                update(false)
            }
        } else {
            update(false)
        }
    }
    
    func updatePaiedData(updatePaiedData paiedData:@escaping(Bool) -> Void) {
        let strSelectedDate = dateFormatter.string(from: Date())
        let updateData = objProductDetailsQuery.updateWithDate(productDetailId: objAdvanceDetail.productDetailId, status: kPaiedStatus, date: strSelectedDate, billNumber: "", customerName: objAdvanceDetail.customerName)
        if updateData {
            let updateOrder = objOrderDetailsQuery.update(productDetailId:  objAdvanceDetail.productDetailId, date: self.objAdvanceDetail.date, time: self.objAdvanceDetail.time, advance: self.objAdvanceDetail.price, remains: Double("0.0")!, pickupNumber: self.arrdisplayData[7].strDescription)
            if updateOrder {
                paiedData(true)
            } else {
                paiedData(false)
            }
        }else {
            paiedData(false)
        }
    }
    
    func deleteFromDatabase(deleteData deleted:@escaping(Bool) -> Void) {
        let deletedData =  objOrderDetailsQuery.delete(productDetailId: productDetailId)
        if deletedData {
            let deleteProduct = objProductDetailsQuery.delete(productDetailId: productDetailId)
            if deleteProduct {
                deleted(true)
            } else {
                deleted(false)
            }
        }else {
            deleted(false)
        }
    }
    
}
extension AdvanceOrderViewModel:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            isPriceEditing = false
        } else {
            isPriceEditing = true
        }
        textField.text = ""
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            textField.text = textField.text!.convertedDigitsToLocale(Locale(identifier: "EN"))
        }
        if textField.tag == 3  && textField.text != "" {
            textField.text = textField.text!.convertedDigitsToLocale(Locale(identifier: "EN"))
            if let data = Double(textField.text!) {
                textField.text = "\(data)"
                self.arrdisplayData[textField.tag].strDescription = "\(data)"
            }
            self.setUpAdvance(strValue: textField.text!)
        }
        if textField.text == "" {
            textField.text = "0.0"
        }
        if self.selectedItem?.strItemsName != "Other" && textField.tag == 1 {
            self.calculateData()
        } else if textField.tag == 2 {
            self.arrdisplayData[2].strDescription = textField.text!
            self.selectedItem!.totalPrice = Double(textField.text!)!
            self.calculateData()
        }
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                let value = textField.text?.dropLast()
                self.arrdisplayData[textField.tag].strDescription = String(value!)
                return true
            }
        }
        if textField.tag == 6 || textField.tag == 7 {
            if textField.text!.count > 11 {
                Alert().showAlert(message: kMobileDigitAlert.localized(), viewController: viewController!)
                return false
            }
        }
        self.arrdisplayData[textField.tag].strDescription = textField.text! + string
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tableView!.reloadData()
        return true
    }
}

extension AdvanceOrderViewModel:CustomTableDelegate,CustomTableDataSource {
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
extension AdvanceOrderViewController: FloatyDelegate {

    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        
        floaty.addItem("Share Bill".localized(), icon: UIImage(named: "share")) { item in
            self.objAdvanceOrderViewModel.fetchProductData()
            DispatchQueue.main.async {
                if self.objAdvanceOrderViewModel.arrProductDetialWithCustomer.count > 0 && self.objAdvanceOrderViewModel.objAdvanceDetail.billNumber.count <= 0 {
                    self.moveToShare()
                } else {
                    Alert().showAlert(message: "This bill alredy shared please check in bill list".localized(), viewController: self)
                }
            }
        }
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
    
        let newData = strCustomerName.lowercased().components(separatedBy: "Back".localized().lowercased())
        if newData.count > 1 {
            if objAdvanceOrderViewModel.isFromBack {
                objAdvanceOrderViewModel.isFromBack = false
                DispatchQueue.main.async {
                    self.backClicked()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.objAdvanceOrderViewModel.isFromBack = true
                }
                return
            }
        }
        
        let data = strCustomerName.lowercased().components(separatedBy: "Call".localized().lowercased())
        if data.count > 1 && objAdvanceOrderViewModel.isFromCall {
            objAdvanceOrderViewModel.isFromCall = false
            for i in 0...objAdvanceOrderViewModel.arrdisplayData.count - 1 {
                let strTitle = objAdvanceOrderViewModel.arrdisplayData[i].strTitle
                if strTitle == AdvanceTitle.customerNumber.strSelectedTitle() {
                    objAdvanceOrderViewModel.arrdisplayData[i].strDescription.makeACall()
                    return
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.objAdvanceOrderViewModel.isFromCall = true
            }
        }
    }
}
