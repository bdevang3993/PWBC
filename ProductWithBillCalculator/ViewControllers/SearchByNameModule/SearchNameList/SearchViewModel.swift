//
//  SearchViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/03/21.
//

import UIKit
import Floaty
import CoreData
import IQKeyboardManagerSwift

class SearchExpnaceModel: NSObject {
    var headerViewXib:CommanView?
    var arrProductDetialWithCustomer = [ProductDetialWithCustomer]()
    var arrOldProductDetialWithCustomer = [ProductDetialWithCustomer]()
    var objBillDescriptionQuery = BillDescriptionQuery()
    var arrMemberName = [String]()
    var sectionData = [String]()
    var currentPage = Date()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Search Account".localized() //"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(SearchExpnaceViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension SearchExpnaceViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if txtType.text == kBilledStatus || txtType.text == kPaiedStatus {
            return 2 + objSearchExpenseViewModel.sectionData.count
        } else {
            return 3
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if txtType.text == kBilledStatus || txtType.text == kPaiedStatus {
            if section == 0 || section == objSearchExpenseViewModel.sectionData.count + 1 {
                return 0
            } else {
                return 40
            }
        }
        else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if txtType.text == kBilledStatus || txtType.text == kPaiedStatus {
            if section == 0 || section == objSearchExpenseViewModel.sectionData.count + 1 {
                return ""
            } else {
                return "Bill Number".localized() + ":" + "\(objSearchExpenseViewModel.sectionData[section - 1])"
            }
        } else {
            return ""
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.section ==  0 {
                return 100
            } else if indexPath.section == objSearchExpenseViewModel.sectionData.count  {
                return 100
            } else {
                return 80
                
            }
        } else {
            if indexPath.section ==  0 {
                return 70
            } else if indexPath.section == objSearchExpenseViewModel.sectionData.count  {
                return 70
            } else {
                return 50
            }
        }
    }
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if section == 1 {
//            return objSearchExpenseViewModel.arrProductDetialWithCustomer.count
//        } else {
//            return 1
//        }
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if txtType.text == kBilledStatus || txtType.text == kPaiedStatus {
            if section == 0 || section == objSearchExpenseViewModel.sectionData.count + 1  {
                return 1
            } else {
                let data = self.objSearchExpenseViewModel.arrProductDetialWithCustomer.filter{$0.billNumber == objSearchExpenseViewModel.sectionData[section - 1]}
                return data.count
            }
        } else {
            if section == 1 {
                return objSearchExpenseViewModel.arrProductDetialWithCustomer.count
            } else {
                return 1
            }
        }
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var count:Int = -1
        if txtType.text == kBilledStatus || txtType.text == kPaiedStatus {
            count = objSearchExpenseViewModel.sectionData.count + 1
        } else {
            count = 2
        }
        if indexPath.section == 0 {
            let cell = tblSearchData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == count {
            let cell = tblSearchData.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            cell.lblTotalPrice.text = "\(totoalAmount)"
            cell.selectionStyle = .none
            return cell
        }
        else  {
            let cell = tblSearchData.dequeueReusableCell(withIdentifier: "LoanDetailsTableViewCell") as! LoanDetailsTableViewCell
            var objData:ProductDetialWithCustomer = ProductDetialWithCustomer()
            if objSearchExpenseViewModel.arrProductDetialWithCustomer.count > 0 {
                if txtType.text == kBilledStatus || txtType.text == kPaiedStatus {
                    let data = objSearchExpenseViewModel.arrProductDetialWithCustomer.filter{$0.billNumber == objSearchExpenseViewModel.sectionData[indexPath.section - 1]}
                    objData = data[indexPath.row]
                } else {
                    objData = objSearchExpenseViewModel.arrProductDetialWithCustomer[indexPath.row]
                }
              
                cell.lblDateofPay.text =  objData.iteamName
                cell.lblDateofPay.adjustsFontSizeToFitWidth = true
                cell.lblDateofPay.numberOfLines = 0
                cell.lblDateofPay.sizeToFit()
                cell.lblBankName.text = "\(objData.quantity)"
                cell.lblBankName.sizeToFit()
                cell.lblDeduction.text = "\(objData.price)"
                cell.lblDeduction.sizeToFit()
            }
         
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
//            let data = objSearchExpenseViewModel.arrBorrowDetail[indexPath.row]
//            let objEditData:AddBorrowViewController =  UIStoryboard(name: kBorrowStoryBoard, bundle: nil).instantiateViewController(identifier: "AddBorrowViewController") as! AddBorrowViewController
//            objEditData.isfromEdit = true
//            objEditData.dicBorrowData = data
//            let strDate = data["date"] as! String
//            objEditData.currentPage = dateFormatter.date(from: strDate)
//            objEditData.updatcallBack = {[weak self]  in
//            }
//            objEditData.modalPresentationStyle = .overFullScreen
//            self.present(objEditData, animated: true, completion: nil)
        }
    }
}
extension SearchExpnaceViewController {
    func configData() {
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.lblNoData.textColor = hexStringToUIColor(hex: strTheamColor)
        self.txtName.textColor = hexStringToUIColor(hex: strTheamColor)
        self.txtType.textColor = hexStringToUIColor(hex: strTheamColor)
        self.lblNoData.isHidden = false
        self.tblSearchData.isHidden = true
        objSearchExpenseViewModel.setHeaderView(headerView: self.viewHeader)
        imgDownName.tintColor = hexStringToUIColor(hex: strTheamColor)
        imgDownType.tintColor = hexStringToUIColor(hex: strTheamColor)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.txtName.layer.borderWidth = 1.0
        self.txtName.layer.borderColor = UIColor.white.cgColor
        self.txtName.placeholder = "Select".localized() + " " + "Name".localized()
        self.txtType.layer.borderWidth = 1.0
        self.txtType.layer.borderColor = UIColor.white.cgColor
        self.txtType.placeholder = "Select".localized() + " " + "Type".localized()
        txtType.layer.borderColor = UIColor.white.cgColor
        self.lblNoData.text = "No data found".localized()
        self.tblSearchData.delegate = self
        self.tblSearchData.dataSource = self
        self.tblSearchData.tableFooterView = UIView()
        self.layoutFAB()
    }
    func deleteAllEntry() {
        
        let isEntryDeleted = objProductDetailsQuery.deleteAllEntry()
        if isEntryDeleted {
            self.txtType.text = ""
            self.objSearchExpenseViewModel.arrOldProductDetialWithCustomer.removeAll()
            self.fetchSearchData(name: self.txtName.text!)
        }
        FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
    }
    func setAlertForDatePicker() {
        setAlertWithCustomAction(viewController: self, message: "please choose the date of paied".localized(), ok: { (success) in
            self.setDate()
        }, isCancel: false) { (falied) in
        }
    }
    func moveToPayment() {
        let objPayment:PaySomeAmountViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "PaySomeAmountViewController") as! PaySomeAmountViewController
        objPayment.modalPresentationStyle = .overFullScreen
        objPayment.totalAmount = Int(totoalAmount)
        objPayment.arrProductDetialWithCustomer = self.objSearchExpenseViewModel.arrProductDetialWithCustomer
        //objPayment.arrBorrowDetail = objSearchExpenseViewModel.arrBorrowDetail
        objPayment.updateAllData = {[weak self] in
            self!.fetchDataWithType(name: self!.txtName.text!, type: self!.txtType.text!)
        }
        self.present(objPayment, animated: true, completion: nil)
    }
    func setDate() {
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedValue) in
            var strBillNumber:String = ""
            self.objSearchExpenseViewModel.currentPage = selectedValue
            let strSelectedDate = self.dateFormatter.string(from: selectedValue)
            DispatchQueue.main.async {
               MBProgressHub.showLoadingSpinner(sender: self.view)
                if self.objSearchExpenseViewModel.arrProductDetialWithCustomer.count <= 0 {
                    Alert().showAlert(message: "please choose the date of paied".localized(), viewController: self)
                    return
                }
                for i in 0...self.objSearchExpenseViewModel.arrProductDetialWithCustomer.count - 1 {
                    let data = self.objSearchExpenseViewModel.arrProductDetialWithCustomer[i]
                    let id = data.productDetailId
                    strBillNumber = data.billNumber
                    self.objProductDetailsQuery.updateWithDate(productDetailId: id, status: kPaiedStatus, date: strSelectedDate, billNumber: data.billNumber, customerName: data.customerName)
                }
                FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
                if strBillNumber.count > 3 {
                   let updatedData = self.objSearchExpenseViewModel.objBillDescriptionQuery.updateWithBillNumber(billNumber: strBillNumber, isPaied: true)
                }
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.txtType.text = ""
                self.fetchSearchData(name: self.txtName.text!)
            }
        }
    }
    func fetchSearchData(name:String) {
        self.objProductDetailsQuery.fetchAllDataByName(name: txtName.text!) { (result) in
            self.txtType.text = ""
            self.objSearchExpenseViewModel.arrOldProductDetialWithCustomer = result
            self.objSearchExpenseViewModel.arrProductDetialWithCustomer = result
            self.tblSearchData.isHidden = false
            self.lblNoData.isHidden = true
            self.updateTotalData()
            self.tblSearchData.reloadData()
        } failure: { (isFailed) in
            self.objSearchExpenseViewModel.arrProductDetialWithCustomer.removeAll()
            self.updateTotalData()
            self.tblSearchData.reloadData()
        }
    }
    func fetchDataWithType(name:String,type:String) {
        objSearchExpenseViewModel.sectionData.removeAll()
        self.objSearchExpenseViewModel.arrProductDetialWithCustomer = self.objSearchExpenseViewModel.arrOldProductDetialWithCustomer.filter{$0.status == type}
        if type == kBilledStatus || type == kPaiedStatus {
            let totalSection = self.objSearchExpenseViewModel.arrProductDetialWithCustomer.compactMap{$0.billNumber}
            let data = totalSection.removingDuplicates()
            objSearchExpenseViewModel.sectionData = data
        }
        self.updateTotalData()
        self.tblSearchData.reloadData()
    }
    
    func updateTotalData() {
        totoalAmount = 0
        if objSearchExpenseViewModel.arrProductDetialWithCustomer.count > 0 {
            self.lblNoData.isHidden = true
            self.tblSearchData.isHidden = false
            for i in 0...objSearchExpenseViewModel.arrProductDetialWithCustomer.count - 1 {
                let data = objSearchExpenseViewModel.arrProductDetialWithCustomer[i]
                let value:Double = data.price
                totoalAmount = totoalAmount + value
            }
            totoalAmount = totoalAmount.rounded(toPlaces: 2)
        }
        self.tblSearchData.reloadData()
    }
  
    func getNameList() {
       MBProgressHub.showLoadingSpinner(sender: self.view)
        objCustomerQuery.fetchAllData { (result) in
            self.objSearchExpenseViewModel.arrMemberName = result.compactMap{$0.strCustomerName}
        } failure: { (isFailed) in
        }

        //objSearchExpenseViewModel.arrMemberName = AllMemberList.shared.getCustomerNameArray()
        MBProgressHub.dismissLoadingSpinner(self.view)
    }
    func pickData() {
        txtType.text?.removeAll()
        if objSearchExpenseViewModel.arrMemberName.count <= 0 {
            Alert().showAlert(message: "please add customer type member from home screen and add details".localized(), viewController: self)
            return
        } else {
            IQKeyboardManager.shared.resignFirstResponder()
            PickerView.objShared.setUPickerWithValue(arrData: objSearchExpenseViewModel.arrMemberName, viewController: self) { (selectedValue) in
                DispatchQueue.main.async {
                    self.txtName.text = selectedValue
                    self.fetchSearchData(name: (selectedValue))
                }
            }
        }
    }
}

extension SearchExpnaceViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Share  Details".localized(), icon: UIImage(named: "share")) { item in
            DispatchQueue.main.async {
                let userDefault = UserDefaults.standard
                if (userDefault.value(forKey: kCustomer) != nil){
                    let name = userDefault.value(forKey: kCustomer) as! String
                    if name.count <= 0 {
                        Alert().showAlert(message: "please add company Name and Logo from icon".localized(), viewController: self)
                        return
                    }
                }
               
                if self.txtType.text == kBorrowStatus {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure you want to Share  Details".localized() + "?", ok: { (value) in
                        let objBillDisplayViewController:BillDisplayViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "BillDisplayViewController") as! BillDisplayViewController
                        objBillDisplayViewController.strSelectedDate = self.dateFormatter.string(from: self.objSearchExpenseViewModel.currentPage)
                        objBillDisplayViewController.arrProductDetialWithCustomer = self.objSearchExpenseViewModel.arrProductDetialWithCustomer
                        objBillDisplayViewController.updateClosure = {[weak self] in
                            self?.fetchSearchData(name: self!.txtName.text!)
                        }
                        objBillDisplayViewController.modalPresentationStyle = .overFullScreen
                        self.present(objBillDisplayViewController, animated: true, completion: nil)
                        
                    }, isCancel: true) { (value) in
                        
                    }
                } else {
                    Alert().showAlert(message: "please check the bill in bill list".localized(), viewController: self)
                }

            }
        }
        floaty.addItem("Delete all Paied Entries".localized(), icon: UIImage(systemName:"trash")) { item in
            DispatchQueue.main.async {
                if self.txtType.text == kPaiedStatus {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure delete all Paied Entries".localized() + "?", ok: { (value) in
                        self.deleteAllEntry()
                    }, isCancel: true) { (value) in
                        
                    }
                } else {
                    Alert().showAlert(message: "please select type as Borrow".localized(), viewController: self)
                }
             
            }
        }
        
        floaty.addItem("Paid All dues".localized(), icon: UIImage(named: "dues")) { item in
            DispatchQueue.main.async {
                if self.txtType.text == kBorrowStatus {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure paied all dues".localized() + "?", ok: { (value) in
                        self.setAlertForDatePicker()
                    }, isCancel: true) { (value) in
                        
                    }
                } else {
                    Alert().showAlert(message: "please select type as Borrow".localized(), viewController: self)
                }
             
            }
        }
        floaty.addItem("Paid Some dues".localized(), icon: UIImage(named: "dues")) { item in
            DispatchQueue.main.async {
                if self.txtType.text == kBorrowStatus && self.totoalAmount > 500 {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure paied some dues more then 500".localized() + "?", ok: { (value) in
                        self.moveToPayment()
                    }, isCancel: true) { (value) in
                        
                    }
                } else if self.totoalAmount < 500 {
                    Alert().showAlert(message: "If dues amount should be more then 500 then only you give some installment".localized(), viewController: self)
                }
                else {
                    Alert().showAlert(message: "please select type as Borrow".localized(), viewController: self)
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
                let split = result.split(separator: " ")
                let lastTwo = String(split.suffix(2).joined(separator: [" "]))
                print("Last String = \(lastTwo)")
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
}
