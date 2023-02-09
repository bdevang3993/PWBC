//
//  AddCustomerViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 04/09/21.
//

import UIKit
import Floaty
class AddCustomerViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrListData = [ItemList]()
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var tableView:UITableView?
    var objCustomerQuery = CustomerQuery()
    var dataAddedSuccess:TASelectedIndex?
    var nextIndex:Int = -1
    var isFromAdd:Bool = false
    var isNamePresent:Bool = false
    var isFromAddCUstomer:Bool = true
    var isFromBack:Bool = true
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromAdd {
            headerViewXib!.lblTitle.text = "Add".localized() + " " + "Customer".localized()
        } else {
            headerViewXib!.lblTitle.text = "Edit".localized() + " " + "Customer".localized()
        }
        
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(AddCustomerViewController(), action: #selector(AddCustomerViewController.backClicked), for: .touchUpInside)
        
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
        self.getInfo()
        self.setUpCustomDelegate()
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }

    func setData(objCustomerData:CustomerList,isFromAdd:Bool) {
        arrListData.removeAll()
        var isEditable:Bool = false
        if isFromAdd {
            isEditable = true
        }
        arrListData.append(ItemList(strTitle: "Customer".localized() + " " + "Name".localized(), strDescription: objCustomerData.strCustomerName, isPicker: false, isEditable: isEditable))
        arrListData.append(ItemList(strTitle: "Customer".localized() + " " + "Mobile".localized() + " " + "Number".localized(), strDescription: objCustomerData.strMobileNumber, isPicker: false, isEditable: true))
        arrListData.append(ItemList(strTitle: "Customer".localized() + " " + "Email Id".localized(), strDescription: objCustomerData.strEmailId, isPicker: false, isEditable: true))
        self.tableView?.reloadData()
    }
    func setUpCustomeCell(cell:LoanTextFieldTableViewCell,index:Int)  {
        let data:ItemList = self.numberOfItemAtIndex(index: index)
        cell.lblTitle.text = data.strTitle
        cell.txtDescription.text = data.strDescription
        cell.txtDescription.tag = index
        cell.txtDescription.delegate = self
        if data.isEditable == false {
            cell.txtDescription.isEnabled = false
        }
        if index == 1 {
            cell.txtDescription.keyboardType = .numberPad
        } else if index == 2 {
            cell.txtDescription.keyboardType = .emailAddress
        } else {
            cell.txtDescription.keyboardType = .default
        }
        if data.isPicker {
            cell.btnSelection.isHidden = false
            cell.imgDown.isHidden = false
        } else {
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
        }
        cell.selectedIndex = { [weak self] index in
        }
    }
    func checkForValidatation() -> Bool {
        if arrListData[0].strDescription.isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + "Customer".localized() + " " + "Name".localized(), viewController: viewController!)
            return false
        }
        
        if arrListData[1].strDescription.count > 0 {
            let value = Double(arrListData[1].strDescription.convertedDigitsToLocale(Locale(identifier: "EN")))
            arrListData[1].strDescription = arrListData[1].strDescription.convertedDigitsToLocale(Locale(identifier: "EN"))
            if value == nil {
                Alert().showAlert(message: "please provide".localized() + " " + "Customer".localized() + " " + "Number".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard", viewController: viewController!)
                return false
            }
        }
     
        if arrListData[2].strDescription.isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + "Customer".localized() + " " + "Email".localized(), viewController: viewController!)
            return false
        }
        if arrListData[2].strDescription.count > 0 {
           let isvalied = isValidEmail(emailStr: arrListData[2].strDescription)
            if !isvalied {
                let strAlert:String =  "please provide".localized() + " " + "valied".localized() + " " + "Email Id".localized() + " " + "OR".localized() + " " + "Add".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard"
                Alert().showAlert(message:strAlert, viewController: viewController!)
                return false
            }
        }
       return true
    }
    func getInfo()  {
        objCustomerQuery.getRecordsCount { (result) in
            self.nextIndex = result + 1
        }
    }
    func getAllUserName(allData data:@escaping(([CustomerList]) -> Void)) {
        objCustomerQuery.fetchAllData { (result) in
            data(result)
        } failure: { (isFailed) in
            data([CustomerList]())
        }
    }
    func saveInDatabase(saveData save:@escaping(Bool) -> Void) {
        if isNamePresent {
            Alert().showAlert(message: "This customer already exist please check in customer list".localized(), viewController: viewController!)
            return
        }
        let data = objCustomerQuery.saveinDataBase(customerId:  self.nextIndex, customerName: arrListData[0].strDescription, emailId: arrListData[2].strDescription, mobileNumber: arrListData[1].strDescription)
        if data {
            setAlertWithCustomAction(viewController: viewController!, message: kDataSaveSuccess.localized(), ok: { (isSuccess) in
                save(true)
            }, isCancel: false) { (isSucess) in
                save(isSucess)
            }
        }
    }
    
    func updateInDatabase(selectedIndex:Int,updateData update:@escaping(Bool) -> Void) {
        let data = objCustomerQuery.update(customerId: selectedIndex, emailId: arrListData[2].strDescription, mobileNumber: arrListData[1].strDescription)
        if data {
            setAlertWithCustomAction(viewController: viewController!, message: kDataUpdate.localized(), ok: { (isSuccess) in
                update(true)
            }, isCancel: false) { (isSucess) in
                update(isSucess)
            }
        }
    }
    
    func deleteFromDatabase(objCustomerList:CustomerList, deleteData delete:@escaping(Bool) -> Void) {
        let data = objCustomerQuery.delete(customerId: objCustomerList.customerId)
        if data {
            setAlertWithCustomAction(viewController: viewController!, message: kDeleteData.localized(), ok: { (isSucces) in
                delete(true)
            }, isCancel: false) { (isFailed) in
                Alert().showAlert(message: kFetchDataissue.localized(), viewController: self.viewController!)
            }
        } else {
            Alert().showAlert(message: kFetchDataissue.localized(), viewController: viewController!)
        }
    }
    func checkForValidation(arrAllData:[CustomerList]) -> Bool{
        let objDataMatch = arrAllData.filter{$0.strCustomerName == arrListData[0].strDescription}
        if objDataMatch.count > 0 {
            Alert().showAlert(message: "This customer name exist please choose other one".localized(), viewController: viewController!)
            return false
        }
        let objNumber = arrAllData.filter{$0.strMobileNumber == arrListData[1].strDescription}
        if objNumber.count > 0 {
            Alert().showAlert(message: "This customer number exist please choose other one".localized(), viewController: viewController!)
            return false
        }
        return true
    }
    
    func moveToPhoneDirectory(objCustomerData:CustomerList) {
        var objNewData:CustomerList = objCustomerData
        let objFetchData:FetchContactViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "FetchContactViewController") as! FetchContactViewController
        objFetchData.modalPresentationStyle = .overFullScreen
        objFetchData.backParent = {[weak self] result in
            if result == 0 {
                DispatchQueue.main.async {
                    self!.viewController!.dismiss(animated: true, completion: nil)
                }
            } else {
                self!.isFromBack  = true
                SpeachListner.objShared.setUpStopData()
                DispatchQueue.main.async {
                    MBProgressHub.showLoadingSpinner(sender: self!.viewController!.view)
                    self!.viewController?.viewDidAppear(true)
                }
            }
        }
        objFetchData.selectedData = {[weak self] result in
            self!.dataAddedSuccess!(0)
            objNewData.strCustomerName = result.customerName
            let result = String(result.mobileNumber.filter("0123456789.".contains))
            print("result = \(result)")
            objNewData.strMobileNumber = result
            self!.setData(objCustomerData: objNewData, isFromAdd:self!.isFromAdd)
        }
        viewController!.present(objFetchData, animated: true, completion: nil)
    }
}
extension AddCustomerViewModel:CustomTableDelegate,CustomTableDataSource {
    
    func numberOfRows() -> Int {
        return arrListData.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130.0
        } else {
            return 100.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrListData[index] as! T
    }
}
extension AddCustomerViewModel:UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    self.arrListData[textField.tag].strDescription =  String(value!)
                    return true
                }
            }
        let data:String = textField.text! + string
            self.arrListData[textField.tag].strDescription =  data//data.lowercased()
        if textField.tag == 1 {
            if textField.text!.count > 11 {
                Alert().showAlert(message: kMobileDigitAlert.localized(), viewController: viewController!)
                return false
            }
        }

        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tableView!.reloadData()
        return true
    }
}
extension AddCustomerViewController: FloatyDelegate {
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
                self?.filerStringValue(strValue: result)
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }

    func filerStringValue(strValue:String) {
        let newData = strValue.lowercased().components(separatedBy: "Device".localized().lowercased())
        if objAddCustomerViewModel.isFromAddCUstomer && newData.count > 1 {
            self.objAddCustomerViewModel.isFromAddCUstomer = false
            self.btnDeviceClicked(AnyObject.self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.objAddCustomerViewModel.isFromAddCUstomer = true
            }
            return
        }
        let split = strValue.split(separator: " ")
        var lastTwo = String(split.suffix(2).joined(separator: [" "]))
        lastTwo = removeWhiteSpace(strData: lastTwo)
        let backData = lastTwo.lowercased().components(separatedBy:"Back".localized().lowercased())
        if backData.count > 1 {
            if objAddCustomerViewModel.isFromBack {
                objAddCustomerViewModel.isFromBack  = false
                DispatchQueue.main.async {
                    self.backClicked()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.objAddCustomerViewModel.isFromBack  = true
                }
            }
            return
        }
        
        if lastTwo.lowercased().contains("Save".localized().lowercased()) &&  objAddCustomerViewModel.isFromAddCUstomer {
            self.btnSaveClicked(AnyObject.self)
            self.objAddCustomerViewModel.isFromAddCUstomer = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.objAddCustomerViewModel.isFromAddCUstomer = true
            }
        }
    }
}
