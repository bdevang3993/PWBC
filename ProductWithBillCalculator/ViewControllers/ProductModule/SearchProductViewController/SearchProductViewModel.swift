//
//  SearchProductViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 03/09/21.
//

import UIKit
import Floaty
import Speech
class SearchProductViewModel: NSObject {
    var objProductQuery = ProductQuery()
    var arrAllItems = [Items]()
    var arrOldItems = [Items]()
    var headerViewXib:CommanView?
    var tableView:UITableView?
    var objCustomTableView = CustomTableView()
    var viewController:UIViewController?
    var isSpeackFirstTime:Bool = true
    var updateProductDataSearchProduct:updateAddedItem?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Search".localized() + " " +  "Product".localized()
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.btnBack.setImage(UIImage(named: "backArrow"), for: .normal)
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
    func fetchAllData(lblNoData:UILabel) {
        objProductQuery.fetchAllData { (result) in
            self.arrOldItems.removeAll()
            if result.count > 0 {
                lblNoData.isHidden = true
            } else {
                lblNoData.isHidden = false
            }
            self.arrOldItems = result
            self.arrOldItems.append(Items(strItemsName: "other", quantityPerUnit: 0.0, quantity: 0.0, strQuantityType: "", price: 0.0, productId: -5, numberOfPice: 0, totalPrice: 0.0))
            self.arrAllItems = self.arrOldItems
            self.tableView!.reloadData()
        } failure: { (isSuccess) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                lblNoData.isHidden = false
                setAlertWithCustomAction(viewController: self.viewController!, message: "no item found in item list please add item first".localized(), ok: { (isSuccess) in
                    self.setListData(lblNoData: lblNoData)
                }, isCancel: false) { (isFailed) in
                }
            }
        }
    }
    func setListData(lblNoData:UILabel) {
        let objListData:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objListData.modalPresentationStyle = .overFullScreen
        objListData.isFromProduct = false
        objListData.isFromAddItem = true
        objListData.updateAllData = {[weak self] in
            lblNoData.isHidden = true
            self?.fetchAllData(lblNoData: lblNoData)
        }
        viewController?.present(objListData, animated: true, completion: nil)
    }
    
    func filterSearchData(strItemName:String) {
        print("Item Name = \(strItemName.prefix(2))")
      
        if strItemName.count > 1 {
            arrAllItems = arrOldItems.filter{$0.strItemsName.contains(strItemName)}
        } else {
            arrAllItems = arrOldItems
        }
        self.tableView!.reloadData()
    }
    func filterSpeakDataWithString(strValue:String) {
        
        if strValue.isNumeric {
            print("Selected index = \(strValue)")
            if arrAllItems.count > Int(strValue)! {
                let data:Items = arrAllItems[Int(strValue)!]
                DispatchQueue.main.async {
                    self.updateProductDataSearchProduct!(data, 0)
                    self.viewController!.dismiss(animated: true, completion: nil)
                }
                return
            } else {
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "please select correct index".localized())
                return
            }
          
        }
        var strItemName:String = ""
        var isDataMatch:Bool = false
        let arrAllData = strValue.split(separator: " ")
        for value in arrAllData {
            if isDataMatch == false {
                strItemName = value.lowercased()
                let strnewItemName = strItemName.prefix(2)
                if strnewItemName.count > 1 {
                    if strItemName.contains("clear") {
                        arrAllItems = arrOldItems
                        self.tableView!.reloadData()
                        return
                    } else {
                        DispatchQueue.main.async { [self] in
                            self.arrAllItems = self.arrOldItems.filter{$0.strItemsName.lowercased().contains(strnewItemName)}
                            self.tableView!.reloadData()
                            if self.arrAllItems.count == 1 {
                                isDataMatch = true
                                let data:Items = self.arrAllItems[0]
                                DispatchQueue.main.async {
                                    self.updateProductDataSearchProduct!(data, 0)
                                    self.viewController!.dismiss(animated: true, completion: nil)
                                }
                                return
                            } else if self.arrAllItems.count <= 0 {
                                self.arrAllItems = self.arrOldItems
                                if isSpeackFirstTime {
                                    isSpeackFirstTime = false
                                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "product not found")
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        isSpeackFirstTime = true
                                    }
                                }
                                DispatchQueue.main.async {
                                    self.tableView!.reloadData()
                                }
                            } else {
                                if self.arrAllItems.count > 0 {
                                    if self.arrAllItems.count != self.arrOldItems.count {
                                        isDataMatch = true
                                        var string:String = "please select one index"
                                        for i in 0...self.arrAllItems.count - 1 {
                                            string = string + " " + "index is \(i) for " + self.arrAllItems[i].strItemsName
                                        }
                                        if isSpeackFirstTime {
                                            isSpeackFirstTime = false
                                            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: string)
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                isSpeackFirstTime = true
                                            }
                                        }
                                    }
                                    isDataMatch = true
                                }
                                return
                            }
                        }
                    }
                }
            }
        }
//        if isDataMatch == false {
//            arrAllItems = arrOldItems
//            self.tableView!.reloadData()
//        }
    }
    
    
    func moveToAddIteam(viewController:UIViewController,tblDisplayData:UITableView,lblNoData:UILabel) {
        let objItema:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objItema.isFromProduct = false
        objItema.isFromAddItem = true
        objItema.modalPresentationStyle = .overFullScreen
        objItema.updateAllData = {[weak self] in
            self?.fetchAllData(lblNoData: lblNoData)
            //self!.objDisplayItemViewModel.fetchAllData()
        }
        viewController.present(objItema, animated: true, completion: nil)
    }
    

}
extension SearchProductViewModel:CustomTableDelegate,CustomTableDataSource {
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

