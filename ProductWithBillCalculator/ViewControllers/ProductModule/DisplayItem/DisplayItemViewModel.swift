//
//  DisplayItemViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 01/09/21.
//

import UIKit
import Floaty
class DisplayItemViewModel: NSObject {
    var strConvertedDate:String = ""
    var headerViewXib:CommanView?
    var objCustomTableView = CustomTableView()
    var arrDisplayData = [Items]()
    var objProductQuery = ProductQuery()
    var tableView:UITableView?
    func fetchAllData() {
        objProductQuery.fetchAllData { (result) in
            self.arrDisplayData = result
            self.tableView?.reloadData()
        } failure: { (isSuccess) in
            self.arrDisplayData.removeAll()
            self.tableView?.reloadData()
        }
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Item List".localized() //"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(HomeViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
       // headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension DisplayItemViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrDisplayData.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrDisplayData[index] as! T
    }
    
}
extension DisplayIemViewController: FloatyDelegate {
    
    func layoutFAB() {
        let floaty = Floaty()
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add".localized() + " " + "Iteam".localized(), icon: UIImage(named: "product")) {item in
            DispatchQueue.main.async {
                self.nextToAddIteam()
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
extension DisplayIemViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return objDisplayItemViewModel.numberOfRows()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objDisplayItemViewModel.heightForRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            let data:Items = objDisplayItemViewModel.numberOfItemAtIndex(index: indexPath.row)
            cell.lblItemDetails.text = data.strItemsName
            cell.lblItemType.text = "\(data.quantityPerUnit) \(data.strQuantityType.localized())"
            cell.lblItemPrice.text = "\(data.price)"
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            return
        }
        let data:Items = objDisplayItemViewModel.numberOfItemAtIndex(index: indexPath.row)
        let objAddProduct:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objAddProduct.isFromProduct = false
        objAddProduct.isFromAddItem = false
        objAddProduct.objDisplayData = data
        objAddProduct.modalPresentationStyle = .overFullScreen
        objAddProduct.updateAllData = {[weak self] in
            self!.tblDisplayData = self?.tblDisplayData
            self!.objDisplayItemViewModel.fetchAllData()
        }
        self.present(objAddProduct, animated: true, completion: nil)
    }
}
