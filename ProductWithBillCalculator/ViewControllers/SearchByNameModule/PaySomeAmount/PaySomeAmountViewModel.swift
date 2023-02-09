//
//  PaySomeAmountViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/09/21.
//

import UIKit

class PaySomeAmountViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrTitle = ["Date","Amount","TransactionId"]
    var arrDateTitle = ["Start Date","End Date"]
    var arrDescription = ["","",""]
    var isFromDate:Bool = false
    var arrCheckAmount = [CheckAmount]()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        if isFromDate {
            headerViewXib!.lblTitle.text = "Select Dates"
        } else {
            headerViewXib!.lblTitle.text = "Pay Amount"
        }
       
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(PaySomeAmountViewController(), action: #selector(PaySomeAmountViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension PaySomeAmountViewController {
    func configureData() {
        
        if UIDevice.current.userInterfaceIdiom == .pad {
                    viewBtnSubmit.frame.size.height = 100.0
                } 
        objPaySomeAmountViewModel.isFromDate = isFromSelectDate
        objPaySomeAmountViewModel.setHeaderView(headerView: self.viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        btnSave.setUpButton()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        if isFromSelectDate {
            
        } else {
            let date = dateFormatter.string(from: Date())
            objPaySomeAmountViewModel.arrDescription[0] = date
            self.updateTotalData()
        }
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.delegate = self
    }
    
    func setUpDate(index:Int) {
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedDate) in
            if self.isFromSelectDate {
                self.objPaySomeAmountViewModel.arrDescription[index] = converFunction(date: selectedDate)!
            } else {
                self.objPaySomeAmountViewModel.arrDescription[index] = self.dateFormatter.string(from: selectedDate)
            }
           
            self.tblDisplayData.reloadData()
        }
    }
    
    func setUpPricePicker(index:Int) {
        let arrPrice = objPaySomeAmountViewModel.arrCheckAmount.compactMap{$0.amount}
        let stringArray = arrPrice.map { String($0) }
        PickerView.objShared.setUPickerWithValue(arrData: stringArray, viewController: self) { (selectedValue) in
            self.objPaySomeAmountViewModel.arrDescription[1] = selectedValue
            self.tblDisplayData.reloadData()
        }
    }
    
    func checkForValidation() -> Bool {
        if objPaySomeAmountViewModel.arrDescription[0].isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Date".localized(), viewController: self)
            return false
        }
        if objPaySomeAmountViewModel.arrDescription[1].isEmpty {
            Alert().showAlert(message: "please select".localized()  + " " + "Amount".localized(), viewController: self)
            return false
        }
        if Int(objPaySomeAmountViewModel.arrDescription[1])! > totalAmount  {
            Alert().showAlert(message: "provided amount is more then the total amount".localized(), viewController: self)
           return false
        }
        return true
    }
    
    func checkForDateValidation() -> Bool{
        if objPaySomeAmountViewModel.arrDescription[0].isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "first".localized() + " " + "Date".localized(), viewController: self)
            return false
        }
        if objPaySomeAmountViewModel.arrDescription[1].isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "End".localized() + " " + "Date".localized(), viewController: self)
            return false
        }
        return true
    }
    
    func updateTotalData() {
        var calculateAmount:Double = 0.0
        if arrProductDetialWithCustomer.count > 0 {
            for i in 0...arrProductDetialWithCustomer.count - 1 {
                let data = arrProductDetialWithCustomer[i]
                calculateAmount = calculateAmount + data.price
                if calculateAmount > 500 {
                    let objData = CheckAmount(amount: Int(calculateAmount), index: i)
                    objPaySomeAmountViewModel.arrCheckAmount.append(objData)
                }
            }
        }
        self.tblDisplayData.reloadData()
    }
    
    func updateInDatabase() {
        let data = objPaySomeAmountViewModel.arrCheckAmount.filter{$0.amount == Int(objPaySomeAmountViewModel.arrDescription[1])}
        let index = data[0].index
        for i in 0...index {
            let userData:ProductDetialWithCustomer = arrProductDetialWithCustomer[i]
            _ = objProductDetailsQuery.update(price: userData.price, quantity: userData.quantity, productDetailId: userData.productDetailId, status: kPaiedStatus, numberOfPice:userData.numberOfPice)
        }
        FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
        setAlertWithCustomAction(viewController: self, message: "Payment added Successfully".localized(), ok: { (isSuccess) in
            self.updateAllData!()
            self.dismiss(animated: true, completion: nil)
        }, isCancel: false) { (isSuccess) in
        }
    }
    
    func deleteEntrybetweenDatesFromDatabase() {
        
        
//        let update = objUserExpenseQuery.deleteAllEntry(startDate: objPaySomeAmountViewModel.arrDescription[0], endDate: objPaySomeAmountViewModel.arrDescription[1])
//        if update {
//            setAlertWithCustomAction(viewController: self, message: "remove entries between two dates successfully", ok: { (isSuccess) in
//                self.updateAllData!()
//                self.dismiss(animated: true, completion: nil)
//            }, isCancel: false) { (isSuccess) in
//            }
//        }

    }
}
extension PaySomeAmountViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromSelectDate {
            return objPaySomeAmountViewModel.arrDateTitle.count
        }
        else {
            return objPaySomeAmountViewModel.arrTitle.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 130
        } else {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        var strTitle:String = ""
        if isFromSelectDate {
            strTitle = objPaySomeAmountViewModel.arrDateTitle[indexPath.row]
        } else {
            strTitle = objPaySomeAmountViewModel.arrTitle[indexPath.row]
        }
        cell.lblTitle.text = strTitle
        cell.txtDescription.text = objPaySomeAmountViewModel.arrDescription[indexPath.row]
        cell.txtDescription.tag = indexPath.row
        cell.btnSelection.tag = indexPath.row
        
        if !isFromSelectDate {
            if cell.lblTitle.text == "Date"  || cell.lblTitle.text == "Amount" {
                cell.btnSelection.isHidden = false
                cell.imgDown.isHidden = false
                if cell.txtDescription.text!.count <= 0 {
                    cell.txtDescription.text = kSelectOption
                }
            } else {
                cell.btnSelection.isHidden = true
                cell.imgDown.isHidden = true
            }
        } else {
            if cell.txtDescription.text!.count <= 0 {
                cell.txtDescription.text = kSelectOption
            }
        }
        
        cell.selectedIndex = {[weak self] index in
            if self!.isFromSelectDate {
                self?.setUpDate(index: index)
            } else {
                if index == 0 {
                    self?.setUpDate(index: index)
                } else {
                    self?.setUpPricePicker(index: index)
                }
            }
            
        }
        cell.selectionStyle = .none
        return cell
    }
}
extension PaySomeAmountViewController: UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    let value = textField.text?.dropLast()
                    objPaySomeAmountViewModel.arrDescription[textField.tag] = String(value!)
                    return true
                }
            }
        objPaySomeAmountViewModel.arrDescription[textField.tag] = textField.text! + string
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tblDisplayData.reloadData()
        return true
    }
}
