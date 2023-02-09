//
//  HomeViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import Floaty
import FSCalendar
import CoreData


class HomeViewModel: NSObject {
    var strConvertedDate:String = ""
    var headerViewXib:CommanView?
    var arrAllItems = [Items]()
    var objProductDetailsQuery = ProductDetailsQuery()
    var objProductQuery = ProductQuery()
    var productDetailId:Int = -1
    var objCustomer:CustomerList?
    var totoalAmount:Double = 0
    var arrProductDetialWithCustomer = [ProductDetialWithCustomer]()
    var viewController:UIViewController?
    var btnSave:UIButton?
    var tableView:UITableView?
    var timeInterVal:Int = 0
    var isFromSpeack:Bool = true
    var isShareCallFirstTime:Bool = true
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
        headerViewXib!.btnHeader.isHidden = false
        headerViewXib!.btnHeader.setTitle("Clear All".localized(), for: .normal)
        headerViewXib!.btnHeader.addTarget(HomeViewController(), action:#selector(HomeViewController.clearAllEntry), for: .touchUpInside)
        headerViewXib!.lblTitle.text = "Home".localized()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(HomeViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
        self.getProductDetailId()
    }
    func getProductDetailId() {
        objProductDetailsQuery.getRecordsCount { (id) in
            self.productDetailId = id
        }
    }
    func fetchFromDatabase(date:Date,tableView:UITableView,name:String) {
        MBProgressHub.objShared.showProgressHub(view: (viewController?.view)!)
       // self.arrAllItems.removeAll()
        let date:String = dateFormatter.string(from:date)
        objProductDetailsQuery.fetchAllData(date: date,name: name) { (result) in
            self.arrProductDetialWithCustomer = result.filter{$0.status == kBorrowStatus}
            self.setUpValueAsPerTheName(strName: name)
            MBProgressHub.objShared.hideProgressHub(view: (self.viewController?.view)!)
            self.updateTotalData()
            if self.arrProductDetialWithCustomer.count > 0 {
                self.btnSave?.isHidden = false
            } else {
                self.btnSave?.isHidden = true
            }
            tableView.reloadData()
        } failure: { (isFailed) in
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "No data found".localized())
            self.arrProductDetialWithCustomer.removeAll()
            self.arrAllItems.removeAll()
            self.updateTotalData()
            tableView.reloadData()
            self.btnSave?.isHidden = true
            MBProgressHub.objShared.hideProgressHub(view: (self.viewController?.view)!)
        }
    }
    
    func setUpValueAsPerTheName(strName:String) {
        self.arrAllItems.removeAll()
        for  value in self.arrProductDetialWithCustomer {
            self.objProductQuery.fetchDataByProdctID(productId: value.productId) { (item) in
                if item.count > 0 {
                    let itemData = item[0]
                    let arrQuantity = value.quantity.split(separator: " ")
                    let item = Items(strItemsName: value.iteamName, quantityPerUnit: itemData.quantityPerUnit, quantity:Double(arrQuantity[0])!, strQuantityType: itemData.strQuantityType, price: itemData.price, productId: value.productId, numberOfPice: value.numberOfPice, totalPrice: value.price)
                    self.arrAllItems.append(item)
                }
            } failure: { (isFailed) in
                if value.iteamName == "Other".localized() {
                    self.arrAllItems.append(Items(strItemsName: "Other".localized(), quantityPerUnit: 0.0, quantity: 0.0, strQuantityType: "", price: 0.0, productId: -5, numberOfPice: 0, totalPrice: value.price))
                }
                self.updateTotalData()
                self.tableView!.reloadData()
                self.btnSave?.isHidden = true
                MBProgressHub.objShared.hideProgressHub(view: (self.viewController?.view)!)
            }
        }
    }
    
    
    func updateTotalData() {
        totoalAmount = 0
        if arrAllItems.count > 0 {
            for i in 0...arrAllItems.count - 1 {
                let data = arrAllItems[i]
                totoalAmount = totoalAmount + data.totalPrice
            }
        }
        totoalAmount = totoalAmount.rounded(toPlaces: 2)
        if totoalAmount > 0 {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Your total amount is".localized() + " " + "\(totoalAmount)")
        }
        tableView?.reloadData()
    }
    func setUpInDatabase(date:Date,tableview:UITableView,name:String) {
        MBProgressHub.objShared.showProgressHub(view: (viewController?.view)!)
        let newDate:String = dateFormatter.string(from:date)
        if arrAllItems.count > 0 {
            if arrAllItems.count > arrProductDetialWithCustomer.count {
                for i in arrProductDetialWithCustomer.count...arrAllItems.count - 1 {
                    self.productDetailId = productDetailId + 1
                    let data:Items = arrAllItems[i]
                    let quntity:String = "\(data.quantity) \(data.strQuantityType.lowercased())"
                    _ = objProductDetailsQuery.saveinDataBase(productDetailId: self.productDetailId, customerId: objCustomer!.customerId, productId: data.productId, customerName: objCustomer!.strCustomerName, date: newDate, iteamName: data.strItemsName, paiedDate: "", price: data.totalPrice, quantity: quntity, status: kBorrowStatus, numberOfPice: data.numberOfPice)
                }
            }
        }
        self.fetchFromDatabase(date:date, tableView:tableview , name: name)
        MBProgressHub.objShared.hideProgressHub(view: (viewController?.view)!)
    }
    

    func setUpShareData(viewController:UIViewController,save saveBlock: @escaping ((Bool) -> Void)) {
        
        if objCustomer == nil {
           // Alert().showAlert(message: "Please save Data First", viewController: viewController)
            
            if arrAllItems.count > 0 {
                let selected = dateFormatter.string(from: Date())
                if arrAllItems.count > arrProductDetialWithCustomer.count {
                    for i in arrProductDetialWithCustomer.count...arrAllItems.count - 1 {
                        self.productDetailId = productDetailId + 1
                        let value:Items = arrAllItems[i]
                        let data = ProductDetialWithCustomer(productDetailId: self.productDetailId, customerId: -1, productId: value.productId, customerName: "", date: selected, iteamName: value.strItemsName, paiedDate: selected, price: value.totalPrice, quantity: "\(value.quantity) \(value.strQuantityType.lowercased())", status: kBorrowStatus, billNumber: "")
                        arrProductDetialWithCustomer.append(data)
                    }
                    saveBlock(true)
                } else {
                    saveBlock(false)
            }
            } else {
                saveBlock(false)
            }
        } else {
            setAlertWithCustomAction(viewController: viewController, message: "Have you saved this Data if not then save in Database or yes then continue".localized() + "?", ok: { (isSuccess) in
                saveBlock(true)
            }, isCancel: true) { (isFailed) in
                saveBlock(false)
            }
        }
    }
    
}
extension HomeViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        
        floaty.addItem("Add".localized() + " " + "Product".localized(), icon: UIImage(named: "product")) {item in
            DispatchQueue.main.async {
                self.moveToAddProduct(index: -1)
            }
        }
        
        floaty.addItem("Add".localized() + " " + "Iteam".localized(), icon: UIImage(named: "product")) {item in
            DispatchQueue.main.async {
                self.nextToAddIteam()
            }
        }
        
        floaty.addItem("Share Bill base on Date".localized(), icon: UIImage(named: "share")) { item in
            DispatchQueue.main.async {
                if self.objHomeViewModel.arrProductDetialWithCustomer.count > 0 {
                    self.objHomeViewModel.setUpShareData(viewController: self) { (isSuccess) in
                        if isSuccess {
                            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to Share  Details".localized() + "?", ok: { (value) in
                                self.moveToShare()
                            }, isCancel: true) { (value) in
                            }
                        }
                    }
                } else {
                    setAlertWithCustomAction(viewController: self, message: "Are you sure you want to Share  Details".localized() + " " + "without".localized() + " " + "customer information".localized() + " " + "?", ok: { (isSuccess) in
                        self.shareDataWithoutSave()
                    }, isCancel: true) { (isFailed) in
                    }
                }
            }
        }
        
        floaty.addItem("Retrive Data Added".localized(), icon: UIImage(named: "product")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to Retrive Data if you have didn't store current data then please save first this data".localized() + "?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    if self.txtName.text!.count > 0 {
                        self.getAllDataFromDB(name: self.txtName.text!)
                    } else {
                        Alert().showAlert(message: "please select".localized() + " " + "Customer".localized() + " " + "Name".localized() , viewController: self)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
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
                if lastTwo.lowercased().contains("Name".localized().lowercased()) && self!.objHomeViewModel.isFromSpeack{
                    self!.objHomeViewModel.isFromSpeack = false
                    DispatchQueue.main.async {
                        self?.btnCustomerNameClicked(AnyObject.self)
                    }
                   
                }
                if (lastTwo.lowercased().contains("Save".localized().lowercased()) || lastTwo.lowercased().contains("Add".localized().lowercased())) &&  self!.objHomeViewModel.isFromSpeack {
                    self!.objHomeViewModel.isFromSpeack = false
                    DispatchQueue.main.async {
                        self?.btnSaveClicked(AnyObject.self)
                    }
                }
                if lastTwo.lowercased().contains("View".localized().lowercased()) && self!.objHomeViewModel.isFromSpeack {
                    self!.objHomeViewModel.isFromSpeack = false
                    DispatchQueue.main.async {
                        if self!.txtName.text == "" {
                            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: kSelectCustomerData.localized())
                        } else {
                            self!.getAllDataFromDB(name: self!.txtName.text!)
                        }
                    }
                }
                if lastTwo.lowercased().contains("Clear".localized().lowercased()) {
                    self?.txtName.text = ""
                    self?.clearAllEntry()
                }
                
                if lastTwo.lowercased().contains("Bill".localized().lowercased()) {
                    self?.shareBill()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self!.objHomeViewModel.isFromSpeack = true
                }
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
}
extension HomeViewController {
    
    func shareBill() {
        if txtName.text!.count <= 0 {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "please select".localized() + " " + "Customer".localized() + " " + "Name".localized())
        } else {
            if objHomeViewModel.isShareCallFirstTime {
                objHomeViewModel.isShareCallFirstTime = false
                DispatchQueue.main.async {
                    self.moveToShare()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.objHomeViewModel.isShareCallFirstTime = true
                }
            }
        }
    }
    
    
    func shareDataWithoutSave() {
       MBProgressHub.showLoadingSpinner(sender: self.view)
       
        if objHomeViewModel.arrAllItems.count > 0 {
            self.setUpCustomerWithProduct()
        } else {
            Alert().showAlert(message: "No Data Found".localized(), viewController: self)
        }
        MBProgressHub.objShared.hideProgressHub(view:self.view)
    }
    
    func setUpCustomerWithProduct() {
        let newDate:String = dateFormatter.string(from: self.currentPage!)
        if objHomeViewModel.arrAllItems.count > objHomeViewModel.arrProductDetialWithCustomer.count {
            for i in self.objHomeViewModel.arrProductDetialWithCustomer.count...self.objHomeViewModel.arrAllItems.count - 1 {
                self.objHomeViewModel.productDetailId = self.objHomeViewModel.productDetailId + 1
                let data:Items = self.objHomeViewModel.arrAllItems[i]
                let quntity:String = "\(data.quantity) \(data.strQuantityType.lowercased())"
                _ = self.objHomeViewModel.objProductDetailsQuery.saveinDataBase(productDetailId: self.objHomeViewModel.productDetailId, customerId: -10, productId: data.productId, customerName: "Customer Name", date: newDate, iteamName: data.strItemsName, paiedDate: "", price: data.totalPrice, quantity: quntity, status: kBorrowStatus, numberOfPice: data.numberOfPice)
            }
            
            self.objHomeViewModel.objProductDetailsQuery.fetchAllData(date: newDate,name: "Customer Name") { (result) in
                self.objHomeViewModel.arrProductDetialWithCustomer = result.filter{$0.status == kBorrowStatus}
                self.moveToShare()
            } failure: { (isFailed) in
            }
        }
    }
    
    func moveToShare() {
        self.setUpCustomerWithProduct()
        let objBillDisplayViewController:BillDisplayViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "BillDisplayViewController") as! BillDisplayViewController
        objBillDisplayViewController.strSelectedDate = dateFormatter.string(from: currentPage!)
        objBillDisplayViewController.arrProductDetialWithCustomer = objHomeViewModel.arrProductDetialWithCustomer //self.arrProductDetialWithCustomer
        objBillDisplayViewController.updateClosure = {[weak self] in
            self?.getAllDataFromDB(name: self!.txtName.text!)
            if isSpeackSpeechOn && self!.objHomeViewModel.isShareCallFirstTime {
                self!.objHomeViewModel.isShareCallFirstTime = false
                self!.setUpSpeachView()
            }
        }
        objBillDisplayViewController.modalPresentationStyle = .overFullScreen
        self.present(objBillDisplayViewController, animated: true, completion: nil)
    }
    
    func moveToAddProduct(index:Int) {
        let objAddProduct:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objAddProduct.modalPresentationStyle = .overFullScreen
        objAddProduct.selectedIndex = index
        objAddProduct.isFromProduct = true
        objAddProduct.isFromAddProduct = true
        if index != -1 {
            print("All Data count = \(objHomeViewModel.arrProductDetialWithCustomer.count)")
            objAddProduct.objDisplayData = objHomeViewModel.arrAllItems[index]
            if objHomeViewModel.arrProductDetialWithCustomer.count >  0 {
                if index < objHomeViewModel.arrProductDetialWithCustomer.count {
                    objAddProduct.objProductDetialWithCustomer = objHomeViewModel.arrProductDetialWithCustomer[index]
                }
            }
            objAddProduct.isFromAddProduct = false
        }
        objAddProduct.updateProductData = {[weak self] (result,index) in
            if index < 0 {
                self!.objHomeViewModel.arrAllItems.append(result)
            } else {
                self!.objHomeViewModel.arrAllItems[index] = result
                //self!.objHomeViewModel.updateInDatabase(date: (self?.currentPage)!, index: index)
            }
            self!.objHomeViewModel.updateTotalData()
            if self!.objHomeViewModel.arrAllItems.count > 0 {
                self?.btnSave.isHidden = false
            } else {
                self?.btnSave.isHidden = true
            }
            self!.tblDisplayData.reloadData()
        }
        self.present(objAddProduct, animated: true, completion: nil)
    }
    
    func nextToAddIteam() {
        let objItema:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objItema.isFromProduct = false
        objItema.isFromAddItem = true
        objItema.modalPresentationStyle = .overFullScreen
        objItema.updateAllData = {[weak self] in
            //self!.objDisplayItemViewModel.fetchAllData()
        }
        self.present(objItema, animated: true, completion: nil)
    }
    
    func fetchAllEvents() {
        appDelegate.selectedViewController = {[weak self] (name,date) in
            self?.moveToViewController(strName: name, date: date)
        }
        self.fetchOrderEvent()
       MBProgressHub.showLoadingSpinner(sender: self.view)
        GetAllEventList.shared.checkForDays = 10
        GetAllEventList.shared.fetchAllEvent { (arrEventList) in
            if arrEventList.count > 0 {
                for dicEvent in arrEventList {
                    self.objHomeViewModel.timeInterVal = self.objHomeViewModel.timeInterVal + 5
                    let days:String = "\(dicEvent.daysRemaining)"
                    self.scheduleNotification(type: "Licence Renewal" , remainingDays: days, lastDate: dicEvent.lastDate, timeInterVal: self.objHomeViewModel.timeInterVal)
                }
            }
            DispatchQueue.main.async {
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.appDelegate.isFirstTime = false
                let userDefault = UserDefaults.standard
                let date = Date()
                userDefault.set(date, forKey: kDate)
                userDefault.synchronize()
            }
        }
    }
    
    func fetchOrderEvent() {
       MBProgressHub.showLoadingSpinner(sender: self.view)
        GetAllEventList.shared.checkForDays = 3
        GetAllEventList.shared.fetchOrderEvent { (result) in
            if result.count > 0 {
                for value in result {
                    self.objHomeViewModel.timeInterVal = self.objHomeViewModel.timeInterVal + 5
                    self.scheduleNotification1(type: "Hand over order on".localized() + " " + "\(value.date)" + " and" + "\(value.time)" + " " + "please check the order status and order list".localized(), date: value.date, timeInterVal: self.objHomeViewModel.timeInterVal)
                }
            }
            DispatchQueue.main.async {
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
        }
    }
    
    func moveToViewController(strName:String,date:String) {
        if strName == "Order Detail" {
            let objListAdvance:ListAdvanceViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "ListAdvanceViewController") as! ListAdvanceViewController
            objListAdvance.strSelectedNotificationOrderDate = date
            self.revealViewController()?.pushFrontViewController(objListAdvance, animated: true)
        } else {
            let objLicence:LicenceListViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "LicenceListViewController") as! LicenceListViewController
            objLicence.strSelectedLastDate = date
            self.revealViewController()?.pushFrontViewController(objLicence, animated: true)
        }
    }
    
    //MARK:- Schedule LocalNotification
    func scheduleNotification(type: String, remainingDays:String,lastDate:String,timeInterVal:Int) {
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Event Update".localized()
        content.title = "License".localized()
        content.subtitle = lastDate
        content.sound = UNNotificationSound.default
        content.body = "Your Event type is".localized() + " " + "\(type)" + " " + "and".localized() + " " + "number of days remains".localized() + " " + "\(remainingDays)" + "please check before expird".localized()
        content.categoryIdentifier = categoryIdentifire
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterVal), repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: categoryIdentifire,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
        appDelegate.notificationCenter.setNotificationCategories([category])
    }
    
    func scheduleNotification1(type: String,date:String,timeInterVal:Int) {
        //Compose New Notificaion
        let content = UNMutableNotificationContent()
        let categoryIdentifire = "Order Update".localized()
        content.title = "Order Detail".localized()
        content.subtitle = date
        content.sound = UNNotificationSound.default
        content.body = type
        content.categoryIdentifier = categoryIdentifire
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timeInterVal), repeats: false)
        let identifier = "Local Notification1"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        appDelegate.notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
            let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
            let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
            let category = UNNotificationCategory(identifier: categoryIdentifire,
                                                  actions: [snoozeAction, deleteAction],
                                                  intentIdentifiers: [],
                                                  options: [])
        appDelegate.notificationCenter.setNotificationCategories([category])
    }
}
extension HomeViewController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return objHomeViewModel.arrAllItems.count
        }else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100
        } else {
            return 70
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        }
        else if indexPath.section == 1 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            let objData = objHomeViewModel.arrAllItems[indexPath.row]
            cell.lblItemDetails.text = objData.strItemsName
            cell.lblItemType.text = "\(objData.quantity)X\(objData.numberOfPice) \(objData.strQuantityType.localized().lowercased())"
            cell.lblItemType.numberOfLines = 0
            cell.lblItemType.sizeToFit()
            cell.lblItemPrice.text = "\(objData.totalPrice)"
            cell.selectionStyle = .none
            return cell
        }
        else {
            let  cell = tblDisplayData.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            cell.lblTotalPrice.text = "\(objHomeViewModel.totoalAmount)"
            cell.lblTotalAmount.adjustsFontSizeToFitWidth = true
            cell.lblTotalAmount.numberOfLines = 0
            cell.lblTotalAmount.sizeToFit()
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
        self.moveToAddProduct(index: indexPath.row)
        }
    }
    func tableView(_ tableView: UITableView,
                    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
     {
         let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
             success(true)
           MBProgressHub.showLoadingSpinner(sender: self.view)
            if self.objHomeViewModel.arrProductDetialWithCustomer.count > 0 {
                let productDetailId = self.objHomeViewModel.arrProductDetialWithCustomer[indexPath.row].productDetailId
               let isSuccess = self.objHomeViewModel.objProductDetailsQuery.delete(productDetailId: productDetailId)
                if isSuccess {
                    self.objHomeViewModel.arrProductDetialWithCustomer.remove(at: indexPath.row)
                    self.objHomeViewModel.arrAllItems.remove(at: indexPath.row)
                    self.objHomeViewModel.updateTotalData()
                }
                MBProgressHub.dismissLoadingSpinner(self.view)
            } else {
                self.objHomeViewModel.arrAllItems.remove(at: indexPath.row)
                self.objHomeViewModel.updateTotalData()
                MBProgressHub.dismissLoadingSpinner(self.view)
            }
         })
         deleteAction.backgroundColor = .red
         return UISwipeActionsConfiguration(actions: [deleteAction])
     }

}
extension HomeViewController : FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let key = self.dateFormatter.string(from: date)
        
        if self.datesWithMultipleEvents.contains(key) {
            return 1
        } else {
            return 0
        }
    }
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let value = checkForNextDate(selectedDate: date)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert.localized(), viewController: self)
            return
        }
        _ = self.dateFormatter.string(from: date)
//        if self.datesWithMultipleEvents.contains(key) {
//
//        }
        _ = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        objHomeViewModel.strConvertedDate = convertdateFromDate(date: date)
        lblDate.text = converFunction( date: date)
        self.currentPage = date
        historySelectedDate = date
        self.calenderView.setCurrentPage(self.currentPage!, animated: true)
        self.calenderView.select(self.currentPage)
        if txtName.text!.count > 0 {
            self.getAllDataFromDB(name: txtName.text!)
        }
        
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        //          print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
}
