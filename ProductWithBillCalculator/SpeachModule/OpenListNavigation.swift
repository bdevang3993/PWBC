//
//  OpenListNavigation.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 18/01/22.
//

import Foundation

class OpenListNavigation: NSObject {
    static var objShared = OpenListNavigation()
    var isFirstTime:Bool = false
    var isOpenView:Bool = true
    var objHomeViewModel = HomeViewModel()
    var viewController = UIViewController()
    var lastViewController = UIViewController()
    var strOpended = "all ready Opend"
    
    private override init() {
    }
    
    func checkForOpenData(strData:String,viewController:UIViewController) {
        if isFirstTime && isOpenView {
            isFirstTime = false
            self.lastViewController = self.viewController
            self.viewController = viewController
            switch strData {
            case OpenMenuTitle.addProduct.selectedString():
                isOpenView = false
               openAddProductViewContrller(viewController: viewController)
                break
            case OpenMenuTitle.addItem.selectedString():
                isOpenView = false
                openAddItem(viewController: viewController)
                break
            case OpenMenuTitle.addCustomer.selectedString():
                isOpenView = false
                openAddCustomer(viewController: viewController)
                break
            case OpenMenuTitle.addLicence.selectedString():
               openAddLicense(viewController: viewController)
                break
            case OpenMenuTitle.addOrderDetail.selectedString():
                isOpenView = false
               openAddOrder(viewController: viewController)
                break
            case OpenMenuTitle.addPayerQR.selectedString():
                isOpenView = false
               openAddQRCode(viewController: viewController)
                break
            case OpenMenuTitle.subScription.selectedString():
                isOpenView = false
                openSubScription(viewController: viewController)
                break
            default:
                break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isOpenView = true
            }
        }
        
    }
    func openAddProductViewContrller(viewController:UIViewController) {
        if viewController.isKind(of: AddProductViewController.self) || viewController.isKind(of: SearchProductViewController.self){
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objAddProduct:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objAddProduct.modalPresentationStyle = .overFullScreen
        objAddProduct.selectedIndex = -1
        objAddProduct.isFromProduct = true
        objAddProduct.isFromAddProduct = true
        if !viewController.isKind(of: HomeViewController.self) {
            print("is not from Home")
        }
        objAddProduct.updateProductData = {[weak self] (result,index) in
            print("view controller = \(viewController)")
            if !viewController.isKind(of: HomeViewController.self) {
            Navigation.objShared.moveToHomeViewContrller(viewController: viewController)
            }
            //HomeViewController().isTotalUpdateFromNotification = true
            if !viewController.isKind(of: HomeViewController.self) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    var newItem:Items = result
                    newItem.isFromHome = false
                    let userDict:[String: Items] = ["item": newItem]
                    NotificationCenter.default.post(name: Notification.Name(kHomeNotification), object: nil,userInfo:userDict)
                }
            } else {
                let userDict:[String: Items] = ["item": result]
                NotificationCenter.default.post(name: Notification.Name(kHomeNotification), object: nil,userInfo:userDict)
            }
        }
        viewController.present(objAddProduct, animated: true, completion: nil)
    }
    
    func openAddItem(viewController:UIViewController) {
        if viewController.isKind(of: AddProductViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objItema:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objItema.isFromProduct = false
        objItema.isFromAddItem = true
        objItema.modalPresentationStyle = .overFullScreen
        objItema.updateAllData = {[weak self] in
          //  self?.fetchAllData(lblNoData: lblNoData)
        }
        viewController.present(objItema, animated: true, completion: nil)
    }
    
    func openAddCustomer(viewController:UIViewController) {
        if viewController.isKind(of: AddCustomerViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objAddCustomer:AddCustomerViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "AddCustomerViewController") as! AddCustomerViewController
        objAddCustomer.modalPresentationStyle = .overFullScreen
        objAddCustomer.isFromAdd = true
        objAddCustomer.dataUpdated = {[weak self] in
           // self?.fetchAllData(lblNoData: lblNoData, viewController: viewController)
        }
        viewController.present(objAddCustomer, animated: true, completion: nil)
    }
    
    func openAddLicense(viewController:UIViewController) {
        if viewController.isKind(of: AddLicenceViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objAddLicence:AddLicenceViewController = UIStoryboard(name:LicenceStoryBoard , bundle: nil).instantiateViewController(identifier: "AddLicenceViewController") as! AddLicenceViewController
      //  objAddLicence.objLicenceData = data
        objAddLicence.isFromAdd = true
        objAddLicence.modalPresentationStyle = .overFullScreen
        objAddLicence.updateData = {[weak self] in
           // self?.fetchAllEvents()
        }
        viewController.present(objAddLicence, animated: true, completion: nil)
        viewController.viewDidAppear(true)
    }
    
    func openAddOrder(viewController:UIViewController) {
        if viewController.isKind(of: AdvanceOrderViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objAdvance:AdvanceOrderViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AdvanceOrderViewController") as! AdvanceOrderViewController
        objAdvance.modalPresentationStyle = .overFullScreen
        objAdvance.objAdvanceOrderViewModel.isFromAddDetails = true
        objAdvance.updateData = {[weak self] in
          //  self?.fetchAllData(tblDisplay: tableView)
        }
        viewController.present(objAdvance, animated: true, completion: nil)
    }
    
    func openAddQRCode(viewController:UIViewController) {
        if viewController.isKind(of: AddPayerDetailViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objPayer:AddPayerDetailViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "AddPayerDetailViewController") as! AddPayerDetailViewController
            objPayer.isFromAddItem = true
       // objPayer.objAddPayerDetailViewModel.objPayerData = data
        objPayer.modalPresentationStyle = .overFullScreen
        objPayer.updateAllData = {[weak self] in
           // self?.fetchAllData(lblNoData: lblNoData)
        }
        viewController.present(objPayer, animated: true, completion: nil)
    }
    
    func openSubScription(viewController:UIViewController) {
        if viewController.isKind(of: SubScriptionViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objCheckSubScription:SubScriptionViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "SubScriptionViewController") as! SubScriptionViewController
        objCheckSubScription.modalPresentationStyle = .overFullScreen
        viewController.present(objCheckSubScription, animated: true, completion: nil)
    }
}
