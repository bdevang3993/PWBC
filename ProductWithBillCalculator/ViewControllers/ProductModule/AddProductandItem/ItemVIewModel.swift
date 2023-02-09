//
//  ItemVIewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit
import SBPickerSelector
import IQKeyboardManagerSwift
class ItemViewModel: NSObject {
    var headerViewXib:CommanView?
    var isFromAddItem:Bool = false
    var objCustomTableView = CustomTableView()
    var arrdisplayData = [ItemList]()
    var objProductQuery = ProductQuery()
    var tableView:UITableView?
    var selectedItem:Items?
    var arrBusinessType = [BusinessType]()
    var objBusinessListViewModel = BusinessListViewModel()
    var selectedUnit:Double = 0.0
    var arrSelectedUnits = [String]()
    var viewController:UIViewController?
    var isIteamExist:Bool = false
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromAddItem {
            headerViewXib!.lblTitle.text = "Add".localized() + " " + "Iteam".localized()
        }else {
            headerViewXib!.lblTitle.text = "Edit".localized() + " " + "Iteam".localized() + " " + "Details".localized()
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
        self.objBusinessListViewModel.fetchTypeOfBusiness { (result) in
            self.arrBusinessType = result
            let userDefault = UserDefaults.standard
            var arrUnits = [String]()
            var strValue:String = ""
            if let value = userDefault.value(forKey: kBusinessType) {
                strValue = value as! String
            } else {
                var objGetData = BusinessDatabaseQuerySetUp()
                let data = objGetData.fetchData()
                let value = data["businessType"]
                strValue = value as! String
            }
            let filterData = strValue.split(separator: ",")
            for value in filterData {
                let strBusinessName =  removeWhiteSpace(strData: String(value))
                let data = self.arrBusinessType.filter{$0.strBusinessName.localized() == strBusinessName.localized()}
                if data.count > 0 {
                    for unit in data[0].arrBusinessUnits {
                        arrUnits.append(unit)
                    }
                }
            }
            arrUnits.removeDuplicates()
            self.arrSelectedUnits = arrUnits
        } failure: { (isFailed) in
        }
        self.isFromAddItem = isFromAdd
        self.setHeaderView(headerView: headerView)
        self.setUpDisplayData(objDisplayData: objDisplayData)
        selectedItem = objDisplayData
        self.setUpCustomDelegate()
    }
    func setUpDisplayData(objDisplayData:Items) {
        arrdisplayData.removeAll()
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.itemName.strSelectedTitle(), strDescription: objDisplayData.strItemsName, isPicker:false, isEditable:isFromAddItem == true ? true:false))
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.quantityType.strSelectedTitle(), strDescription: objDisplayData.strQuantityType.localized(),isPicker:true, isEditable: true))
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.quantityPerUnit.strSelectedTitle(), strDescription: "\(objDisplayData.quantityPerUnit)",isPicker:false, isEditable: false))
        arrdisplayData.append(ItemList(strTitle: ItemDisplayTItle.itemPrice.strSelectedTitle(), strDescription: "\(objDisplayData.price)", isPicker:false,isEditable: true))
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func setUpQuantityType(index:Int,viewController:UIViewController)  {
        self.viewController = viewController
        IQKeyboardManager.shared.resignFirstResponder()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: self.arrSelectedUnits).cancel {
            print("cancel, will be autodismissed")
            }.set { values in
                if let values = values as? [String] {
                    self.arrdisplayData[index].strDescription = values[0]
                    self.setupUnit(value: values[0])
                }
        }.present(into: viewController)
    }
    
    func setupUnit(value:String) {
        switch value {
        case "Unit".localized():
            selectedUnit = QuantityTypeUnits.unit.selectedUnit()
            break
        case "Gm".localized():
            selectedUnit = QuantityTypeUnits.gm.selectedUnit()
            break
        case "Kg".localized():
            selectedUnit = QuantityTypeUnits.kg.selectedUnit()
            break
        case "Lt".localized():
            selectedUnit = QuantityTypeUnits.lt.selectedUnit()
            break
        case "Ml".localized():
            selectedUnit = QuantityTypeUnits.ml.selectedUnit()
            break
        case "Box".localized():
            selectedUnit = QuantityTypeUnits.box.selectedUnit()
            break
        case "Tablet".localized():
            selectedUnit = QuantityTypeUnits.tablet.selectedUnit()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.setUpPopUpForTotalItemInTablet()
            }
            break
        case "Bottal".localized():
            selectedUnit = QuantityTypeUnits.bottal.selectedUnit()
            break
        case "Size".localized():
            selectedUnit = QuantityTypeUnits.size.selectedUnit()
            break
        case "Piece".localized():
            selectedUnit = QuantityTypeUnits.piece.selectedUnit()
            break
        case "Cup".localized():
            selectedUnit = QuantityTypeUnits.cup.selectedUnit()
            break
        case "Can".localized():
            selectedUnit = QuantityTypeUnits.can.selectedUnit()
            break
        case "Pkg".localized():
            selectedUnit = QuantityTypeUnits.pkg.selectedUnit()
            break
        default:
            selectedUnit = QuantityTypeUnits.unit.selectedUnit()
        }
        arrdisplayData[2].strDescription = "\(selectedUnit)"
        self.tableView?.reloadData()
    }
    
    func setUpPopUpForTotalItemInTablet() {
        let alertController = UIAlertController(title: kAppName, message: "please provide total count of pices in one tablet".localized(), preferredStyle: .alert)

        let saveAction = UIAlertAction(title: "Ok".localized(), style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            self.selectedItem?.numberOfPice = Int(firstTextField.text!)!
        })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "total pices".localized()
            textField.keyboardType = .decimalPad
        }
        alertController.addAction(saveAction)
        viewController!.present(alertController, animated: true, completion: nil)
    }
    
    func setUpCellData(cell:LoanTextFieldTableViewCell,index:Int,viewController:UIViewController) {
        let data:ItemList = numberOfItemAtIndex(index: index)
        cell.lblTitle.text = data.strTitle
        cell.txtDescription.text = data.strDescription
        cell.txtDescription.tag = index
        cell.txtDescription.delegate = self
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
        if data.isEditable == false {
            cell.txtDescription.isEnabled = false
            cell.btnSelection.isHidden = true
            cell.imgDown.isHidden = true
        } else {
            cell.txtDescription.isEnabled = true
        }
        if ItemDisplayTItle.itemName.strSelectedTitle() == cell.lblTitle.text {
            cell.txtDescription.keyboardType = .default
        } else {
            cell.txtDescription.keyboardType = .decimalPad
        }
        
        cell.selectedIndex = {[weak self] index in
            
            let data:ItemList =  self!.numberOfItemAtIndex(index: index)
            if data.strTitle == ItemDisplayTItle.quantityType.strSelectedTitle() {
                self?.setUpQuantityType(index: index, viewController: viewController)
            }
        }
    }
    
    func setUpValidation(viewController:UIViewController) -> Bool  {
        if arrdisplayData[0].strDescription.isEmpty {
            Alert().showAlert(message: "please provide".localized() + " " + "Iteam".localized() + " " + "Name".localized(), viewController: viewController)
            return false
        }
        if arrdisplayData[1].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Quantity".localized() + " " + "Type".localized(), viewController: viewController)
            return false
        }
        if arrdisplayData[2].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Iteam".localized() + " " + "Unit".localized(), viewController: viewController)
            return false
        }
        if arrdisplayData[3].strDescription.isEmpty {
            Alert().showAlert(message: "please select".localized() + " " + "Iteam".localized() + " " + "Price".localized(), viewController: viewController)
            return false
        }
        let price = Double(arrdisplayData[3].strDescription.convertedDigitsToLocale(Locale(identifier: "EN")))
        arrdisplayData[3].strDescription = "\(price ?? 0.0)"
        if arrdisplayData[3].strDescription.count > 0 && price == nil {
            Alert().showAlert(message: "please select".localized() + " " + "Iteam".localized() + " " + "Price".localized() + " " + "using".localized() + " " + "English" + " " + "Keyboard", viewController: viewController)
            return false
        }
        if price! <= 0.0 {
            Alert().showAlert(message: "please select".localized() + " " + "Iteam".localized() + " " + "Price".localized(), viewController: viewController)
            return false
        }
        return true
    }
    func saveDataInDatabase(viewController:UIViewController,update updateBlock: @escaping ((Bool) -> Void)) {
        if self.isIteamExist {
            Alert().showAlert(message: "This iteam already exist".localized(), viewController: viewController)
            return
        }
        objProductQuery.getRecordsCount { (result) in
            var productId:Int = 0
            if result < 0 {
                productId = 1
            } else {
                productId = result + 1
            }
            DispatchQueue.main.async {
                // do something
                let saveData = self.objProductQuery.saveinDataBase(productId: productId, iteamName: self.arrdisplayData[0].strDescription.lowercased(), price: Double(self.arrdisplayData[3].strDescription) ?? 0.0, qauntityPerUnit: self.selectedUnit, qauntityType: self.arrdisplayData[1].strDescription, qauntity: 0.0, numberOfPice: self.selectedItem!.numberOfPice)
                if saveData {
                    setAlertWithCustomAction(viewController: viewController, message: kItemAdded.localized(), ok: { (isSuccess) in
                        updateBlock(true)
                    }, isCancel: false) { (isFailed) in
                        updateBlock(false)
                    }
                }
            }
        }
    }
    func checkForIteam(strName:String) {
        objProductQuery.fetchDataByItemName(itemName: strName.lowercased()) { (result) in
            if result.count > 0 {
                self.isIteamExist = true
            }
        } failure: { (isFailed) in
            self.isIteamExist = false
        }
    }
    func deleteFromDatabase(viewController:UIViewController,itemName:String,update updateBlock: @escaping ((Bool) -> Void)){
        let deleted = self.objProductQuery.delete(iteamName: itemName)
        if deleted {
            setAlertWithCustomAction(viewController: viewController, message: kDeleteData.localized(), ok: { (isSuccess) in
                updateBlock(true)
            }, isCancel: false) { (isFailed) in
                updateBlock(false)
            }
        }
    }
}
extension ItemViewModel:UITextFieldDelegate {
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
                    self.arrdisplayData[textField.tag].strDescription =  String(value!)
                    return true
                }
            }
        let data:String = textField.text! + string
            self.arrdisplayData[textField.tag].strDescription =  data.lowercased()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 0 {
            self.checkForIteam(strName: textField.text!)
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tableView!.reloadData()
        return true
    }
}
extension ItemViewModel:CustomTableDelegate,CustomTableDataSource {
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

