//
//  SearchCustomerViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 06/09/21.
//

import Foundation
import UIKit

class SearchCustomerViewModel: NSObject {
    var objCutomerQuery = CustomerQuery()
    var arrAllItems = [CustomerList]()
    var arrOldItems = [CustomerList]()
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var viewController:UIViewController?
    var updateSearchCustomerViewModel:updateSearchCustomer?
    var objCustomTableView = CustomTableView()
    var isSpeackFirstTime:Bool = true
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Search".localized() + " " + "Customer".localized()
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
       // headerViewXib!.btnBack.setImage(UIImage(named: "backArrow"), for: .normal)
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(SearchProductViewController(), action: #selector(SearchProductViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
        self.setUpCustomDelegate()
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func fetchAllData(lblNoData:UILabel,viewController:UIViewController) {
        objCutomerQuery.fetchAllData { (result) in
            if result.count > 0 {
                lblNoData.isHidden = true
            } else {
                lblNoData.isHidden = false
            }
            self.arrAllItems = result
            self.arrOldItems = result
            self.tableView!.reloadData()
        } failure: { (isFailed) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                setAlertWithCustomAction(viewController: viewController, message: "no customer found please add customer".localized(), ok: { (isSuccess) in
                    lblNoData.isHidden = false
                    self.addToCustomer(lblNoData: lblNoData, viewController: viewController)
                }, isCancel: false) { (isFailed) in
                }
            }
        }
    }
//    func moveToAddCustomer(viewController:UIViewController,tblDisplayData:UITableView,lblNoData:UILabel) {
//        let objSearchCustomer:SearchProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
//        objSearchCustomer.modalPresentationStyle = .overFullScreen
//        objSearchCustomer.isFromHome = true
//        objSearchCustomer.updateSearchCustomer = {[weak self] result in
//            self?.fetchAllData(lblNoData: lblNoData, viewController: viewController)
//
//        }
//        viewController.present(objSearchCustomer, animated: true, completion: nil)
//    }
    func addToCustomer(lblNoData:UILabel,viewController:UIViewController) {
        let objAddCustomer:AddCustomerViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "AddCustomerViewController") as! AddCustomerViewController
        objAddCustomer.modalPresentationStyle = .overFullScreen
        objAddCustomer.isFromAdd = true
        objAddCustomer.dataUpdated = {[weak self] in
            self?.fetchAllData(lblNoData: lblNoData, viewController: viewController)
        }
        viewController.present(objAddCustomer, animated: true, completion: nil)
    }
    func filterSearchData(strCustomerName:String) {
        if strCustomerName.count > 1 {
            arrAllItems = arrOldItems.filter{$0.strCustomerName.contains(strCustomerName)}
        } else {
            arrAllItems = arrOldItems
        }
        self.tableView!.reloadData()
    }
    
    func filterSearchWithString(strCustomerName:String) {
        guard let tableDisplayView = self.tableView else {
            Alert().showAlert(message: "please go back and come again".localized(), viewController: viewController!)
            return
        }
        if strCustomerName.isNumeric {
            print("Selected index = \(strCustomerName)")
            if arrAllItems.count > Int(strCustomerName)! {
                let data:CustomerList = arrAllItems[Int(strCustomerName)!]
                DispatchQueue.main.async {
                    self.updateSearchCustomerViewModel!(data)
                    self.viewController!.dismiss(animated: true, completion: nil)
                }
                return
            } else {
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "please select correct index".localized())
                return
            }
          
        }
        var isDataMatch:Bool = false
        let arrAllData = strCustomerName.split(separator: " ")
        for value in arrAllData {
            if isDataMatch == false {
                let strValue = value.prefix(2).lowercased()
                if strValue.count > 1 {
                    if strValue.contains("Clear".localized().lowercased()) {
                        arrAllItems = arrOldItems
                        tableDisplayView.reloadData()
                        return
                    }
                    arrAllItems = arrOldItems.filter{$0.strCustomerName.lowercased().contains(strValue.lowercased())}
                    if self.arrAllItems.count == 1 {
                        isDataMatch = true
                        let data:CustomerList = self.arrAllItems[0]
                        DispatchQueue.main.async {
                            self.updateSearchCustomerViewModel!(data)
                            self.viewController!.dismiss(animated: true, completion: nil)
                        }
                        return
                    } else if self.arrAllItems.count <= 0 {
                        self.arrAllItems = arrOldItems
                        if self.isSpeackFirstTime {
                            self.isSpeackFirstTime = false
                        SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "product not found")
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            self.isSpeackFirstTime = true
                        }
                            print("is Data Match = \(isDataMatch)")
                            tableDisplayView.reloadData()
                        return
                    }else {
                        if self.arrAllItems.count > 0 {
                            if self.arrAllItems.count != self.arrOldItems.count {
                                tableDisplayView.reloadData()
                                isDataMatch = true
                                var string:String = "please select one index"
                                for i in 0...self.arrAllItems.count - 1 {
                                    string = string + " " + "index is \(i) for " + self.arrAllItems[i].strCustomerName
                                }
                                if self.isSpeackFirstTime {
                                    self.isSpeackFirstTime = false
                                    SpeachRecognizerData.objShared.setupValueForSpeak(strValue: string)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.isSpeackFirstTime = true
                                }
                            }
                            return
                        }
                    }
                }
            }
        }
    }
}
extension SearchCustomerViewModel:CustomTableDelegate,CustomTableDataSource {
    
    func numberOfRows() -> Int {
        return arrAllItems.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrAllItems[index] as! T
    }
}
