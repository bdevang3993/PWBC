//
//  BillListViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 22/09/21.
//

import UIKit
import Floaty
class BillListViewModel: NSObject {
    var headerViewXib:CommanView?
    var arroldDisplayData = [BillList]()
    var arrDisplayData = [BillList]()
    var arrAllDisplayData = [BillList]()
    var objBillDescriptionQuery = BillDescriptionQuery()
    var objProductDetailQuery = ProductDetailsQuery()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
//        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Bill List".localized()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnHeader.isHidden = false
        headerViewXib?.btnHeader.setImage(UIImage(systemName: "trash"), for: .normal)
        headerViewXib?.btnHeader.tintColor = .white
        headerViewXib?.btnHeader.addTarget(BillListViewController(), action: #selector(BillListViewController.deleteAllData), for: .touchUpInside)
        headerViewXib?.btnBack.addTarget(BillListViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func fetchAllDataByCurrentMonth(tblDispalyData:UITableView,view:UIView,lblNoData:UILabel) {
        MBProgressHub.objShared.showProgressHub(view:view)
        let firstDate = Date().startOfMonth()
        let strDate = dateFormatter.string(from: firstDate)
        let newDate:String = String(strDate.suffix(7))
        objBillDescriptionQuery.fetchAllDataByMonth(startDate: newDate) { (billList) in
            self.arrAllDisplayData = billList
            self.arroldDisplayData = billList
            self.arrDisplayData = self.arroldDisplayData
            if self.arroldDisplayData.count > 0 {
                lblNoData.isHidden = true
            } else {
                lblNoData.isHidden = false
            }
            tblDispalyData.reloadData()
            MBProgressHub.objShared.hideProgressHub(view: view)
        } failure: { (isFailed) in
            self.arrDisplayData.removeAll()
            tblDispalyData.reloadData()
            MBProgressHub.objShared.hideProgressHub(view: view)
            lblNoData.isHidden = false
        }
    }
    
    func searchAllData(strValue:String,tblDispalyData:UITableView) {
        let value = validatePhoneNumber(value:strValue)
        let checkValue = strValue.split(separator: "/")
        if value {
            arrDisplayData = arroldDisplayData.filter{$0.customerNumber.contains(strValue)}
            if self.arrDisplayData.count <= 0 {
                self.arrDisplayData.removeAll()
            }
            tblDispalyData.reloadData()
        } else if checkValue.count > 1 {
            arrDisplayData = arroldDisplayData.filter{$0.billNumber.contains(strValue)}
            if self.arrDisplayData.count <= 0 {
                self.arrDisplayData.removeAll()
            }
            tblDispalyData.reloadData()
        }else {
            if strValue.count <= 1 {
                self.arrDisplayData = self.arroldDisplayData
            } else {
                arrDisplayData = arroldDisplayData.filter{$0.customerName.lowercased().contains(strValue.lowercased())}
                if self.arrDisplayData.count <= 0 {
                    self.arrDisplayData.removeAll()
                }
            }
            tblDispalyData.reloadData()
        }
        self.arroldDisplayData = self.arrAllDisplayData
    }
    
    func setUpDatePicker(viewController:UIViewController,tblDispalyData:UITableView,lblNoData:UILabel,txtSearch:UITextField) {
        PickerView.objShared.setUpDatePickerWithDate(viewController: viewController) { (selectedValue) in
            let strSelectedDate = self.dateFormatter.string(from: selectedValue)
            txtSearch.text = strSelectedDate
            self.objBillDescriptionQuery.fetchAllDataByDate(date: strSelectedDate) { (billList) in
                self.arrDisplayData = billList
                if self.arrDisplayData.count > 0 {
                    lblNoData.isHidden = true
                } else {
                    lblNoData.isHidden = false
                }
                tblDispalyData.reloadData()
            } failure: { (isFailed) in
                self.arrDisplayData.removeAll()
                tblDispalyData.reloadData()
            }
        }
    }
    
    func setUpDateWithMonthsPicker(viewController:UIViewController,tblDispalyData:UITableView,lblNoData:UILabel,txtSearch:UITextField) {
        PickerView.objShared.setUpDatePickerWithMonthAndYear(viewController: viewController) { [self] (selectedValue) in
            let firstDate = selectedValue.startOfMonth()
            let strDate = dateFormatter.string(from: firstDate)
            let newDate:String = String(strDate.suffix(7))
            txtSearch.text = newDate
            self.objBillDescriptionQuery.fetchAllDataByMonth(startDate: newDate) { (billList) in
                self.arrDisplayData = billList
                if self.arrDisplayData.count > 0 {
                    lblNoData.isHidden = true
                } else {
                    lblNoData.isHidden = false
                }
                tblDispalyData.reloadData()
                MBProgressHub.objShared.hideProgressHub(view: viewController.view)
            } failure: { (isFailed) in
                self.arrDisplayData.removeAll()
                tblDispalyData.reloadData()
                MBProgressHub.objShared.hideProgressHub(view: viewController.view)
                lblNoData.isHidden = false
            }
        }
    }
    
    func getFirstAndLastDate(date:Date) -> (String,String) {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)
        let comps2 = NSDateComponents()
        comps2.month = 1
        comps2.day = -1
        let endOfMonth = calendar.date(byAdding: comps2 as DateComponents, to: startOfMonth!)
        return(dateFormatter.string(from: startOfMonth!),dateFormatter.string(from: endOfMonth!))
    }
    
    func setUpTypePicker(viewController:UIViewController,tblDispalyData:UITableView,lblNoData:UILabel,txtType:UITextField,txtName:UITextField) {
        PickerView.objShared.setUPickerWithValue(arrData: [kPaiedStatus.localized(),"UnPaied".localized(),"All".localized()], viewController: viewController) { (result) in
            var selectedValue:Bool = false
            txtType.text = result
            if result == kPaiedStatus.localized() {
                selectedValue = true
            }
            if result == "All".localized() {
                self.arrDisplayData = self.arroldDisplayData
            } else {
                self.arrDisplayData = self.arroldDisplayData.filter{$0.isPaied == selectedValue}
            }
            if txtName.text!.count > 0 {
                self.arroldDisplayData = self.arrDisplayData
                self.searchAllData(strValue: txtName.text!, tblDispalyData: tblDispalyData)
            }
            tblDispalyData.reloadData()
        }
    }
    
    func moveToBillDisplay(data:BillList,viewcontroller:UIViewController,tblDisplayData:UITableView,lblNoRecordFound:UILabel) {
        let objImageDisplayViewController:ImageDisplayViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "ImageDisplayViewController") as! ImageDisplayViewController
        objImageDisplayViewController.isFromBillDisplay = true
        objImageDisplayViewController.objImageDisplay.isFromBillDisplay = true
        objImageDisplayViewController.objImageDisplay.objBillList = data
        objImageDisplayViewController.modalPresentationStyle = .overFullScreen
        objImageDisplayViewController.updateClosure = { [weak self] in
            self!.fetchAllDataByCurrentMonth(tblDispalyData: tblDisplayData, view: viewcontroller.view, lblNoData: lblNoRecordFound)
            FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
        }
        viewcontroller.present(objImageDisplayViewController, animated: true, completion: nil)
    }
}
extension BillListViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrDisplayData.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrDisplayData[index] as! T
    }
    
}
extension BillListViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return objBillList.numberOfRows()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let  cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanDetailsTableViewCell") as! LoanDetailsTableViewCell
            let data:BillList = objBillList.numberOfItemAtIndex(index: indexPath.row)
            cell.lblDateofPay.text = data.date
            cell.lblDeduction.text = "\(data.amount)"
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let data:BillList = objBillList.numberOfItemAtIndex(index: indexPath.row)
            objBillList.moveToBillDisplay(data: data, viewcontroller: self, tblDisplayData: tblDisplayData, lblNoRecordFound: lblNoRecordFound)
        }
        
    }
}
extension BillListViewController:UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.txtSelectType.text = "All".localized()
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    
                    if value!.count <= 1 {
                        objBillList.searchAllData(strValue:removeWhiteSpace(strData: String(value!)) , tblDispalyData: tblDisplayData)
                    }
                    return true
                }
            }
        let data:String = textField.text! + string
        if data.count > 2 {
            objBillList.searchAllData(strValue:removeWhiteSpace(strData: data), tblDispalyData: tblDisplayData)
        }
        return true
    }
}
extension BillListViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        
        floaty.addItem("Filter by Month".localized(), icon: UIImage(named: "dues")) {item in
            DispatchQueue.main.async {
                
                self.txtSearchData.resignFirstResponder()
                self.objBillList.setUpDateWithMonthsPicker(viewController: self, tblDispalyData: self.tblDisplayData, lblNoData: self.lblNoRecordFound, txtSearch: self.txtSearchData)
            }
        }
        
        
        floaty.addItem("Select Date".localized(), icon: UIImage(named: "dues")) {item in
            DispatchQueue.main.async {
                self.txtSearchData.resignFirstResponder()
                self.txtSearchData.text = ""
                self.txtSelectType.text = "All".localized()
                self.objBillList.setUpDatePicker(viewController: self, tblDispalyData: self.tblDisplayData, lblNoData: self.lblNoRecordFound, txtSearch: self.txtSearchData)
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
