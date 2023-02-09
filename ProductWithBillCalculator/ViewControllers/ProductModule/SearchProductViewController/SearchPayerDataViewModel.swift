//
//  SearchPayerDataViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/10/21.
//

import UIKit
import Floaty
class SearchPayerDataViewModel: NSObject {
    var objPayerDetailsQuery = PayerDetailsQuery()
    var arrAllPayer = [PayerData]()
    var arroldPayer = [PayerData]()
    var headerViewXib:CommanView?
    var viewController:UIViewController?
    var tableView:UITableView?
    var objCustomTableView = CustomTableView()
    var isSpeackFirstTime:Bool = true
    var objPayerData = PayerData(strName: "", strURL: "", id: -1)
    
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Sales".localized() + " " + "Payment".localized()
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
//        headerViewXib!.btnBack.setImage(UIImage(named: "backArrow"), for: .normal)
        headerViewXib!.lblBack.isHidden = true
        // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(SearchProductViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
        self.setUpCustomDelegate()
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func fetchAllData(lblNoData:UILabel) {
        objPayerDetailsQuery.fetchAllData { (result) in
            lblNoData.isHidden = true
            self.arroldPayer = result
            self.arrAllPayer = result
            self.tableView?.reloadData()
        } failure: { (isFailed) in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                lblNoData.isHidden = false
                self.arrAllPayer.removeAll()
                self.tableView?.reloadData()
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
    
    func filterSearchData(strName:String) {
        if strName.count > 1 {
            arrAllPayer = arroldPayer.filter{$0.strName.contains(strName)}
        } else {
            arrAllPayer = arroldPayer
        }
        self.tableView!.reloadData()
    }
    
    
    func filterSearchWithString(strCustomerName:String,lblNoData:UILabel) {
        if strCustomerName.lowercased() == "Call".lowercased() {
            return
        }
        guard let tableDisplayView = self.tableView else {
            Alert().showAlert(message: "please go back and come again".localized(), viewController: viewController!)
            return
        }
        if strCustomerName.isNumeric {
            print("Selected index = \(strCustomerName)")
            if arrAllPayer.count > Int(strCustomerName)! {
                let data:PayerData = arrAllPayer[Int(strCustomerName)!]
                DispatchQueue.main.async {
                    self.moveToAddPayer(viewController: self.viewController!, tblDisplayData: tableDisplayView, lblNoData: lblNoData, data: data)
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
            if isDataMatch {
                let strValue = value.prefix(2).lowercased()
                if strValue.count > 1 {
                    if strValue.contains("Clear".localized().lowercased()) {
                        arrAllPayer = arroldPayer
                        tableDisplayView.reloadData()
                        return
                    }
                    arrAllPayer = arroldPayer.filter{$0.strName.lowercased().contains(strValue.lowercased())}
                    if self.arrAllPayer.count == 1 {
                        isDataMatch = true
                        let data:PayerData = self.arrAllPayer[0]
                        DispatchQueue.main.async {
                            self.moveToAddPayer(viewController: self.viewController!, tblDisplayData: self.tableView!, lblNoData: lblNoData, data: data)
                            return
                        }
                        return
                    } else if self.arrAllPayer.count <= 0 {
                        arrAllPayer = arroldPayer
                        if isSpeackFirstTime {
                            isSpeackFirstTime = false
                            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "product not found")
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.isSpeackFirstTime = true
                            }
                        }
                        DispatchQueue.main.async {
                            self.tableView!.reloadData()
                        }
                    }
                    else {
                        if self.arrAllPayer.count > 0 {
                            if self.arrAllPayer.count != self.arroldPayer.count {
                                tableDisplayView.reloadData()
                                isDataMatch = true
                                var string:String = "please select one index"
                                for i in 0...self.arrAllPayer.count - 1 {
                                    string = string + " " + "index is \(i) for " + self.arrAllPayer[i].strName
                                }
                                if isSpeackFirstTime {
                                    isSpeackFirstTime = false
                                    SpeachRecognizerData.objShared.setupValueForSpeak(strValue: string)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        self.isSpeackFirstTime = true
                                    }
                                }
                            }
                            return
                        }
                    }
                }
            }
        }
//        if isDataMatch == false {
//            arrAllPayer = arroldPayer
//            tableDisplayView.reloadData()
//        }
    }
    
    
    func moveToAddPayer(viewController:UIViewController,tblDisplayData:UITableView,lblNoData:UILabel,data:PayerData) {
        let objPayer:AddPayerDetailViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "AddPayerDetailViewController") as! AddPayerDetailViewController
        if data.id == -1 {
            objPayer.isFromAddItem = true
        } else {
            objPayer.isFromAddItem = false
        }
        objPayer.objAddPayerDetailViewModel.objPayerData = data
        objPayer.modalPresentationStyle = .overFullScreen
        objPayer.updateAllData = {[weak self] in
            self?.fetchAllData(lblNoData: lblNoData)
        }
        viewController.present(objPayer, animated: true, completion: nil)
    }
    
    func deletePayerData(data:PayerData,deleted deletedData:@escaping((Bool) -> Void))  {
        let deleted = objPayerDetailsQuery.delete(id: data.id)
        if deleted {
            deletedData(true)
        } else {
            deletedData(false)
        }
    }
}
extension SearchPayerDataViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrAllPayer.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrAllPayer[index] as! T
    }
}
