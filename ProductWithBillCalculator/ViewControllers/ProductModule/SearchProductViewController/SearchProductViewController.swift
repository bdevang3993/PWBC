//
//  SearchProductViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 03/09/21.
//

import UIKit
import Floaty

enum TypeOfSearch {
   case customerName,productName,payerName
   func selectedType() -> String {
       switch self {
       case .customerName:
           return "Customer"
       case .productName:
           return "Product"
       case .payerName:
           return "Payer"
       }
   }
}

class SearchProductViewController: UIViewController {
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var txtSearch: UITextField!
    @IBOutlet weak var lblNoData: UILabel!
    var isFromHome:Bool = false
    var isBackCall:Bool = true
    var strTypeOfSearch:String = TypeOfSearch.customerName.selectedType()
    var updateProductData:updateAddedItem?
    var backFromProduct:TASelectedIndex?
    var updateSearchCustomer:updateSearchCustomer?
    var objSearchProductViewModel = SearchProductViewModel()
    var objSearchCustomerViewModel = SearchCustomerViewModel()
    var objPayerListViewModel = SearchPayerDataViewModel()
    var isWordMatch:Bool = true
    var floaty = Floaty()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
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
    
    @objc func backClicked() {
        if isSpeackSpeechOn {
            if strType == TypeOfSearch.productName.selectedType() {
                backFromProduct!(0)
            } else {
                OpenListNavigation.objShared.viewController.viewDidAppear(true)
            }
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureData() {
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
       
//        SpeachListner.objShared.selectedString = { [weak self] result in
//            let split = result.split(separator: " ")
//            var lastTwo = String(split.suffix(2).joined(separator: [" "]))
//            print("Last String = \(lastTwo)")
//            if lastTwo.lowercased().contains("Item".lowercased()) {
//                let wordToRemove = "Item".lowercased()
//                if let range = lastTwo.lowercased().range(of: wordToRemove) {
//                    lastTwo.removeSubrange(range)
//                    print("result = \(lastTwo)")
//                }
//            }
//            if lastTwo.count > 1 {
//                self!.objSearchProductViewModel.filterSpeakDataWithString(strValue: lastTwo)
//            }
//        }
        txtSearch.delegate = self
        self.lblNoData.isHidden = true
        self.lblNoData.textColor = hexStringToUIColor(hex: strTheamColor)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        lblNoData.textColor = hexStringToUIColor(hex: strTheamColor)
        switch strTypeOfSearch {
        case TypeOfSearch.customerName.selectedType():
            txtSearch.placeholder = "Customer".localized() + " " + "Name".localized()
            objSearchCustomerViewModel.tableView = self.tblDisplayData
            objSearchCustomerViewModel.viewController = self
            objSearchCustomerViewModel.fetchAllData(lblNoData: lblNoData, viewController: self)
            objSearchCustomerViewModel.setHeaderView(headerView: viewHeader)
            objSearchCustomerViewModel.updateSearchCustomerViewModel = updateSearchCustomer
            break
        case TypeOfSearch.productName.selectedType():
            txtSearch.placeholder = "Product".localized() + " " + "Name".localized()
            objSearchProductViewModel.tableView = self.tblDisplayData
            objSearchProductViewModel.viewController = self
            objSearchProductViewModel.fetchAllData(lblNoData: lblNoData)
            objSearchProductViewModel.setHeaderView(headerView: viewHeader)
            objSearchProductViewModel.updateProductDataSearchProduct = updateProductData
            break
        case TypeOfSearch.payerName.selectedType():
            txtSearch.placeholder = "Sales".localized() + " " + "Name".localized()
            objPayerListViewModel.tableView = self.tblDisplayData
            objPayerListViewModel.viewController = self
            objPayerListViewModel.fetchAllData(lblNoData: lblNoData)
            objPayerListViewModel.setHeaderView(headerView: viewHeader)
            break
        default:
           break
        }
        self.layoutFAB()
       
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        self.tblDisplayData.tableFooterView = UIView()
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SearchProductViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch strTypeOfSearch {
        case TypeOfSearch.customerName.selectedType():
            return objSearchCustomerViewModel.numberOfRows()
        case TypeOfSearch.productName.selectedType():
            return objSearchProductViewModel.numberOfRows()
        case TypeOfSearch.payerName.selectedType():
            return  objPayerListViewModel.numberOfRows()
        default:
            return objSearchCustomerViewModel.numberOfRows()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch strTypeOfSearch {
        case TypeOfSearch.customerName.selectedType():
            return objSearchCustomerViewModel.heightForRow()
        case TypeOfSearch.productName.selectedType():
            return objSearchProductViewModel.heightForRow()
        case TypeOfSearch.payerName.selectedType():
            return  objPayerListViewModel.heightForRow()
        default:
            return objSearchCustomerViewModel.heightForRow()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "BusinessListTableViewCell") as! BusinessListTableViewCell
        
        switch strTypeOfSearch {
        case TypeOfSearch.customerName.selectedType():
            let data:CustomerList = objSearchCustomerViewModel.numberOfItemAtIndex(index: indexPath.row)
            cell.lblTitle.text = data.strCustomerName
            break
        case TypeOfSearch.productName.selectedType():
            let data:Items = objSearchProductViewModel.numberOfItemAtIndex(index: indexPath.row)
            cell.lblTitle.text = data.strItemsName
            break
        case TypeOfSearch.payerName.selectedType():
            let data:PayerData = objPayerListViewModel.numberOfItemAtIndex(index: indexPath.row)
            cell.lblTitle.text = data.strName
            break
        default:
            break
        }
        cell.selectionStyle = .none
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch strTypeOfSearch {
        case TypeOfSearch.customerName.selectedType():
            let data:CustomerList = objSearchCustomerViewModel.numberOfItemAtIndex(index: indexPath.row)
            updateSearchCustomer!(data)
            self.dismiss(animated: true, completion: nil)
            break
        case TypeOfSearch.productName.selectedType():
            let data:Items = objSearchProductViewModel.numberOfItemAtIndex(index: indexPath.row)
            updateProductData!(data, indexPath.row)
            self.dismiss(animated: true, completion: nil)
            break
        case TypeOfSearch.payerName.selectedType():
            let data:PayerData = objPayerListViewModel.numberOfItemAtIndex(index: indexPath.row)
            objPayerListViewModel.moveToAddPayer(viewController: self, tblDisplayData: self.tblDisplayData, lblNoData: lblNoData, data: data)
            break
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
        if TypeOfSearch.payerName.selectedType() == strTypeOfSearch {
            let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
                success(true)
              MBProgressHub.showLoadingSpinner(sender: self.view)
                let data:PayerData = self.objPayerListViewModel.numberOfItemAtIndex(index: indexPath.row)
                self.objPayerListViewModel.deletePayerData(data: data) { (isSuccess) in
                    self.objPayerListViewModel.fetchAllData(lblNoData: self.lblNoData)
                    MBProgressHub.dismissLoadingSpinner(self.view)
                }
            })
            deleteAction.backgroundColor = .red
            return UISwipeActionsConfiguration(actions: [deleteAction])
        }
        else {
            return UISwipeActionsConfiguration()
        }
     }
}
extension SearchProductViewController:UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                switch strTypeOfSearch {
                case TypeOfSearch.customerName.selectedType():
                    objSearchCustomerViewModel.filterSearchData(strCustomerName: txtSearch.text!)
                    break
                case TypeOfSearch.productName.selectedType():
                    objSearchProductViewModel.filterSearchData(strItemName: txtSearch.text!)
                    break
                case TypeOfSearch.payerName.selectedType():
                    objPayerListViewModel.filterSearchData(strName: txtSearch.text!)
                    break
                default:
                    break
                }
                
                return true
            }
        }
        if txtSearch.text!.count > 1 {
            switch strTypeOfSearch {
            case TypeOfSearch.customerName.selectedType():
                objSearchCustomerViewModel.filterSearchData(strCustomerName: txtSearch.text! + string)
                break
            case TypeOfSearch.productName.selectedType():
                objSearchProductViewModel.filterSearchData(strItemName: txtSearch.text! + string)
                break
            case TypeOfSearch.payerName.selectedType():
                let name:String = txtSearch.text! + string
                objPayerListViewModel.filterSearchData(strName: name.capitalizingFirstLetter())
                break
            default:
                break
            }

        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.tblDisplayData!.reloadData()
        return true
    }
}
extension SearchProductViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        var strTitle:String = "Add".localized() + " " + "Iteam".localized()
        switch strTypeOfSearch {
        case TypeOfSearch.customerName.selectedType():
            strTitle = "Add".localized() + " " + "Customer".localized()
            break
        case TypeOfSearch.productName.selectedType():
            strTitle = "Add".localized() + " "  + "Iteam".localized()
            break
        case TypeOfSearch.payerName.selectedType():
            strTitle = "Add".localized() + " " + "Payer".localized()
            break
        default:
            break
        }
        floaty.addItem(strTitle, icon: UIImage(named: "product")) {item in
            DispatchQueue.main.async {                    
                    switch self.strTypeOfSearch {
                    case TypeOfSearch.customerName.selectedType():
                        self.objSearchCustomerViewModel.addToCustomer(lblNoData: self.lblNoData, viewController: self)
                        break
                    case TypeOfSearch.productName.selectedType():
                        self.objSearchProductViewModel.moveToAddIteam(viewController: self, tblDisplayData: self.tblDisplayData, lblNoData: self.lblNoData)
                        break
                    case TypeOfSearch.payerName.selectedType():
                        self.objPayerListViewModel.moveToAddPayer(viewController: self, tblDisplayData: self.tblDisplayData, lblNoData: self.lblNoData, data: self.objPayerListViewModel.objPayerData)
                        break
                    default:
                        break
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
            SpeachListner.objShared.selectedString = { [weak self] result in
             let split = result.split(separator: " ")
             var lastTwo = String(split.suffix(2).joined(separator: [" "]))
                lastTwo = removeWhiteSpace(strData: lastTwo)
                if lastTwo.lowercased().contains("Item".lowercased()) {
                    let wordToRemove = "Item".lowercased()
                    if let range = lastTwo.lowercased().range(of: wordToRemove) {
                        lastTwo.removeSubrange(range)
                    }
                }
                let backData = lastTwo.lowercased().components(separatedBy:"Back".localized().lowercased())
                if backData.count > 1 {
                    if self!.isBackCall {
                        self?.isBackCall = false
                        SpeachListner.objShared.setUpStopData()
                        DispatchQueue.main.async {
                            self!.backClicked()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self!.isBackCall = true
                        }
                    }
                    return
                }
                
                let data = lastTwo.lowercased().components(separatedBy: "Index".lowercased())
                if data.count > 1 {
                    if let range = lastTwo.lowercased().range(of: "Index".lowercased()) {
                        let value:String = String(lastTwo[range.upperBound...])
                        if !data.last!.isEmpty && value.count > 0 {
                            var lastValue:String = removeWhiteSpace(strData: data.last!)
                            if  !lastValue.isNumeric {
                                lastValue =  String(split.suffix(1).joined(separator: [" "]))
                                let number = lastValue.spelled
                                if !lastValue.contains("ze")  && number == 0{
                                    return
                                }
                                lastValue = String(number)
                                lastTwo = lastValue
                                if self!.strTypeOfSearch == TypeOfSearch.productName.selectedType() {
                                    self!.objSearchProductViewModel.viewController = self
                                    self?.objSearchProductViewModel.tableView = self?.tblDisplayData
                                    self!.objSearchProductViewModel.filterSpeakDataWithString(strValue: lastTwo)
                                }
                                if self!.strTypeOfSearch == TypeOfSearch.customerName.selectedType(){
                                    self?.setUpForCustomer(strName: lastTwo)
                                }
                                if self!.strTypeOfSearch == TypeOfSearch.payerName.selectedType() {
                                    self?.setUpPayer(strName: lastTwo)
                                }
                                return
                            } else {
                                if lastValue.isNumeric {
                                    let number = lastValue.spelled
                                    lastValue = String(number)
                                    lastTwo = lastValue
                                    if self!.strTypeOfSearch == TypeOfSearch.productName.selectedType() {
                                    self!.objSearchProductViewModel.viewController = self
                                    self?.objSearchProductViewModel.tableView = self?.tblDisplayData
                                    self!.objSearchProductViewModel.filterSpeakDataWithString(strValue: lastTwo)
                                    }
                                    return
                                } else {
                                    return
                                }
                            }
                        } else {
                            return
                        }
                    } else {
                        return
                    }
                }
                if self!.isWordMatch{
                    if self!.strTypeOfSearch == TypeOfSearch.productName.selectedType(){
                        self!.isWordMatch = false
                        DispatchQueue.main.async {
                            self!.objSearchProductViewModel.updateProductDataSearchProduct = self!.updateProductData
                            self!.objSearchProductViewModel.viewController = self
                            self?.objSearchProductViewModel.tableView = self?.tblDisplayData
                            self!.objSearchProductViewModel.filterSpeakDataWithString(strValue: lastTwo)
                        }
                    }
                    else if self!.strTypeOfSearch == TypeOfSearch.customerName.selectedType() {
                        self?.setUpForCustomer(strName: lastTwo)
                    }
                    else if self!.strTypeOfSearch == TypeOfSearch.payerName.selectedType() {
                        self?.setUpPayer(strName: lastTwo)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3)  {
                        self!.isWordMatch = true
                    }
                }
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
    }
    
    func setUpForCustomer(strName:String) {
        objSearchCustomerViewModel.viewController = self
        objSearchCustomerViewModel.updateSearchCustomerViewModel = updateSearchCustomer
        objSearchCustomerViewModel.filterSearchWithString(strCustomerName: strName)
    }
    func setUpPayer(strName:String)  {
        objPayerListViewModel.viewController = self
        objPayerListViewModel.tableView = tblDisplayData
        objPayerListViewModel.filterSearchWithString(strCustomerName: strName, lblNoData: lblNoData)
    }
}
