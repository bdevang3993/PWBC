//
//  FetchContactViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 04/09/21.
//

import UIKit
import Floaty
class FetchContactViewModel: NSObject {
    var headerViewXib:CommanView?
    var isFromFrechContact:Bool = true
    var isFromBack:Bool = true
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Contact List".localized()
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(FetchContactViewController(), action: #selector(FetchContactViewController.backClicked), for: .touchUpInside)
        headerViewXib!.btnHeader.isHidden = false
        headerViewXib!.btnHeader.setTitle("Sync".localized(), for: .normal)
        headerViewXib!.btnHeader.addTarget(FetchContactViewController(), action: #selector(FetchContactViewController.syncContact), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension FetchContactViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "ContactTableViewCell") as! ContactTableViewCell
        let data = contacts[indexPath.row]
        cell.lblTitle.text = data.customerName
        cell.lblNumber.text = data.mobileNumber
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = contacts[indexPath.row]
        setAlertWithCustomAction(viewController: self, message: "Are you sure you have to select this Contact".localized() + "?", ok: { (isSuccess) in
            self.selectedData!(data)
            self.dismiss(animated: true, completion: nil)
        }, isCancel: false) { (isSuccess) in
        }
    }
}
extension FetchContactViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
                let isBackSpace = strcmp(char, "\\b")
                if (isBackSpace == -92) {
                    self.filterSearchData(strCustomerName: txtPersonName.text!)
                    return true
                }
            }
        if txtPersonName.text!.count > 1 {
            self.filterSearchData(strCustomerName: txtPersonName.text! + string)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tblDisplayData!.reloadData()
        return true
    }
}
extension FetchContactViewController: FloatyDelegate {
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
        let data = strCustomerName.lowercased().components(separatedBy: "Index".lowercased())
        let split = strCustomerName.split(separator: " ")
        var lastTwo = String(split.suffix(2).joined(separator: [" "]))
        var isIndexmatch:Bool = false
        lastTwo = removeWhiteSpace(strData: lastTwo)
        let backData = lastTwo.lowercased().components(separatedBy:"Back".localized().lowercased())
        if backData.count > 1 {
            if objFetchContact.isFromBack {
                objFetchContact.isFromBack = false
                DispatchQueue.main.async {
                    self.backClicked()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.objFetchContact.isFromBack = false
                }
            }
            return
        }
        if data.count > 1  && objFetchContact.isFromFrechContact {
            if let range = lastTwo.lowercased().range(of: "Index".lowercased()) {
                let value:String = String(lastTwo[range.upperBound...])
                if !data.last!.isEmpty && value.count > 0 {
                    isIndexmatch = true
                    objFetchContact.isFromFrechContact = false
                    var lastValue:String = removeWhiteSpace(strData: data.last!)
                    if  !lastValue.isNumeric {
                        lastValue =  String(split.suffix(1).joined(separator: [" "]))
                        let number = lastValue.spelled
                        if !lastValue.contains("ze")  && number == 0 {
                            self.setUpFlag()
                            return
                        }
                        if number >= 0 {
                            print("Selected index = \(number)")
                            if contacts.count > number {
                                let data:CustomerInfo = contacts[number]
                                DispatchQueue.main.async {
                                    self.selectedData!(data)
                                    self.dismiss(animated: true, completion: nil)
                                }
                                self.setUpFlag()
                                return
                            } else {
                                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "please select correct index".localized())
                                self.setUpFlag()
                                return
                            }
                            
                        }
                    }
                }
            }
        }
        if isIndexmatch == false && objFetchContact.isFromFrechContact {
            var isDataMatch:Bool = false
            let arrAllData = strCustomerName.split(separator: " ")
            
            for value in arrAllData {
                let strValue = value.prefix(2).lowercased()
                if strValue.count > 1 {
                    if strValue.contains("Clear".localized().lowercased()) {
                        contacts = oldContacts
                        tblDisplayData.reloadData()
                        self.setUpFlag()
                        return
                    }
                    contacts = oldContacts.filter{$0.customerName.lowercased().contains(strValue.lowercased())}
                    if self.contacts.count == 1 {
                        isDataMatch = true
                        let data:CustomerInfo = self.contacts[0]
                        DispatchQueue.main.async {
                            self.selectedData!(data)
                            self.dismiss(animated: true, completion: nil)
                        }
                        self.setUpFlag()
                        return
                    } else {
                        if self.contacts.count > 0 {
                            if self.contacts.count != self.oldContacts.count {
                                tblDisplayData.reloadData()
                                isDataMatch = true
                                objFetchContact.isFromFrechContact = false
                                var string:String = "please select one index"
                                for i in 0...self.contacts.count - 1 {
                                    string = string + " " + "index is \(i) for " + self.contacts[i].customerName
                                }
                                DispatchQueue.main.async {
                                    SpeachRecognizerData.objShared.setupValueForSpeak(strValue: string)
                                }
                                self.setUpFlag()
                                
                                return
                            }
                        }
                    }
                }
            }
            if isDataMatch == false {
                contacts = oldContacts
                tblDisplayData.reloadData()
            }
        }
    }
    func setUpFlag() {
        DispatchQueue.main.asyncAfter(deadline:.now() + 3) {
            self.objFetchContact.isFromFrechContact = true
        }
    }
}
