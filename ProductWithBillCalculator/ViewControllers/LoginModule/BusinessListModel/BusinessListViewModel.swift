//
//  BusinessListViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit

class BusinessListViewModel: NSObject {
    var headerViewXib:CommanView?
    var arrBusinessType = [BusinessType]()
    var objCustomTableView = CustomTableView()
    var tblDisplay:UITableView?
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    
    func setHeaderView(headerView:UIView,isFromSelectLangauge:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        if isFromSelectLangauge {
            headerViewXib!.lblTitle.text = "Prefer Language".localized()
            headerViewXib!.imgBack.isHidden = true
            headerViewXib!.btnBack.isHidden = true
        } else {
            headerViewXib!.lblTitle.text = "Business List".localized()
            headerViewXib!.imgBack.isHidden = false
            headerViewXib!.btnBack.isHidden = false
        }
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(BusinessListViewController(), action: #selector(BusinessListViewController.backClicked), for: .touchUpInside)
        
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func fetchBusinessData(arrSelectedBusinessList:[BusinessType]) {
        self.fetchTypeOfBusiness { (result) in
            self.arrBusinessType = result
            for i in 0...self.arrBusinessType.count - 1 {
                if arrSelectedBusinessList.contains(where: { (business) -> Bool in
                    business.strBusinessName.localized() == self.arrBusinessType[i].strBusinessName.localized()
                }){
                    self.arrBusinessType[i].isSelected = true
                }
            }
            self.tblDisplay!.reloadData()
        } failure: { (isSuccess) in
        }
    }
    func fetchTypeOfBusiness(data businessData:@escaping (([BusinessType]) -> Void),failure failureBlock:@escaping ((Bool) -> Void)) {
        var arrSelectedBusinessType = [BusinessType]()
        if let path = Bundle.main.path(forResource: "ProductUnit", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]//mutableLeaves
                let arrAllData = jsonObj["Units"] as! [Any]
                for data in arrAllData {
                    let newData = data as! [String:Any]
                    let type = newData["type"] as! String
                    var value = newData["values"] as! [String]
                    for i in 0...value.count - 1 {
                        value[i] = value[i].localized()
                    }
                    var data = BusinessType(strBusinessName: type.localized(), arrBusinessUnits:value, isSelected: false)
                    if arrSelectedBusinessType.count > 0 {
                        for i in 0...arrSelectedBusinessType.count - 1 {
                            if arrSelectedBusinessType[i].strBusinessName.localized() == type.localized() {
                                data.isSelected = true
                            }
                        }
                    }
                    self.arrBusinessType.append(data)
                }
                businessData(self.arrBusinessType)
            }
            catch {
                failureBlock(false)
                print("parse error: \(error.localizedDescription)")
            }
        }
    }
    func setUpCellData(index:Int,cell:BusinessListTableViewCell) {
        let data:BusinessType = self.arrBusinessType[index]
        cell.lblTitle.text = data.strBusinessName
        if data.isSelected {
            cell.imgSelect.image = UIImage(systemName: "checkmark.square")//UIImage(named: "checkmark.square")
        } else {
            cell.imgSelect.image = UIImage(systemName: "squareshape")//UIImage(named: "squareshape")
        }
    }
    
    func setupDataSelection(index:Int) {
        var data:BusinessType = self.arrBusinessType[index]
        if data.isSelected == false {
            data.isSelected = true
        }else {
            data.isSelected = false
        }
        self.arrBusinessType[index] = data
        self.tblDisplay!.reloadData()
    }
}
extension BusinessListViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrBusinessType.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrBusinessType[index] as! T
    }
}

