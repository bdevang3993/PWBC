//
//  CustomeListViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 06/09/21.
//

import UIKit
import Floaty

class CustomerListViewModel: NSObject {
    var strConvertedDate:String = ""
    var headerViewXib:CommanView?
    var objCustomTableView = CustomTableView()
    var arrListData = [CustomerList]()
    var customerQuery = CustomerQuery()
    var viewController:UIViewController?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Customer List".localized() //"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(CustomerListViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func getDataFromDB() {
        customerQuery.fetchAllData { (result) in
            self.arrListData = result
            self.setUpCustomDelegate()
        } failure: { (isFailed) in
            Alert().showAlert(message:kFetchDataissue.localized() , viewController: self.viewController!)
        }
    }
    
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func moveToAddCustomer(index:Int,tablView:UITableView) {
        let objAddCustomer:AddCustomerViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "AddCustomerViewController") as! AddCustomerViewController
        if index == -1 {
            objAddCustomer.isFromAdd = true
        } else {
            objAddCustomer.isFromAdd = false
            objAddCustomer.objCustomerData = arrListData[index]
        }
        objAddCustomer.arrAllData = self.arrListData
        objAddCustomer.selectedIndex = index
        objAddCustomer.modalPresentationStyle = .overFullScreen
        objAddCustomer.dataUpdated = {[weak self] in
            self?.getDataFromDB()
            tablView.reloadData()
        }
        viewController?.present(objAddCustomer, animated: true, completion: nil)
    }
}
extension CustomerListViewModel:CustomTableDelegate,CustomTableDataSource {
    
    func numberOfRows() -> Int {
        return arrListData.count
    }
    func heightForRow() -> CGFloat {
        return 70.0
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrListData[index] as! T
    }
}
extension CustomerListViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add".localized() + " " + "Customer".localized(), icon: UIImage(named: "user")) {item in
            DispatchQueue.main.async {
                self.objCustomerListViewModel.moveToAddCustomer(index: -1, tablView: self.tblDisplayData)
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
