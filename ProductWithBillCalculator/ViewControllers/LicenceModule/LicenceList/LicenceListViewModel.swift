//
//  LicenceViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 08/09/21.
//

import UIKit
import Floaty

class LicenceListViewModel: NSObject {
    var headerViewXib:CommanView?
    var objCustomTableView = CustomTableView()
    var arrLicenceList = [LicenceList]()
    var objLicenceDetailsQuery = LicenceDetailsQuery()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "License".localized() + " " + "List".localized() //"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(LicenceListViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
       
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func moveToAddLicence(viewController:UIViewController,index:Int,tableView:UITableView) {
        
        let objAddLicence:AddLicenceViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "AddLicenceViewController") as! AddLicenceViewController
        objAddLicence.modalPresentationStyle = .fullScreen
        if index >= 0 {
            let data:LicenceList = numberOfItemAtIndex(index: index)
            objAddLicence.objLicenceData = data
        }
        if index == -1 {
            objAddLicence.isFromAdd = true
        } else {
            objAddLicence.isFromAdd = false
        }
        objAddLicence.updateData = {[weak self] in
            self?.fetchAllData(tableView: tableView)
        }
        viewController.present(objAddLicence, animated: true, completion: nil)
    }
    func fetchAllData(tableView:UITableView) {
      objLicenceDetailsQuery.fetchAllData(record: { (results) in
        self.arrLicenceList = results
        self.setUpCustomDelegate()
        tableView.reloadData()
        }, failure: { (isFailed) in
            self.arrLicenceList.removeAll()
            tableView.reloadData()
        })
    }
}
extension LicenceListViewModel:CustomTableDelegate,CustomTableDataSource {
    
    func numberOfRows() -> Int {
        self.arrLicenceList.count
    }
    func heightForRow() -> CGFloat {
        return 70.0
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
            return self.arrLicenceList[index] as! T
    }
}
extension LicenceListViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add".localized() + " " + "License".localized(), icon: UIImage(named: "licence")) {item in
            DispatchQueue.main.async {
                self.objLicenceListViewModel.moveToAddLicence(viewController: self, index: -1, tableView: self.tblDisplayData)
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
