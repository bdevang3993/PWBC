//
//  ListAdvanceViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 30/09/21.
//

import UIKit
import Floaty

class ListAdvanceViewModel: NSObject {
    var headerViewXib:CommanView?
    var objOrderDetailsQuery = OrderDetailsQuery()
    var arrAdvanceDetail = [AdvanceDetail]()
    var arrAllAdvanceDetail = [AdvanceAllData]()
    var arrProductDetialWithCustomer = [ProductDetialWithCustomer]()
    var objProductDetailsQuery = ProductDetailsQuery()
    var objCustomTableView = CustomTableView()
    var isDataMatch:Bool = false
    var isSpeakFound:Bool = true
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "List of Orders".localized()
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(ListAdvanceViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    func setUpCustomDelegate() {
        objCustomTableView.delegate = self
        objCustomTableView.dataSource = self
    }
    func fetchAllData(tblDisplay:UITableView) {
        self.arrAdvanceDetail.removeAll()
        self.arrProductDetialWithCustomer.removeAll()
        self.arrAllAdvanceDetail.removeAll()
        objOrderDetailsQuery.fetchAllData { (result) in
            self.arrAdvanceDetail = result
            if self.arrAdvanceDetail.count > 0 {
                for value in self.arrAdvanceDetail {
                    let advanceid = value.productDetailId
                    self.objProductDetailsQuery.fetchAllDataByProductId(productDetailId: "\(advanceid)") { (result) in
                        let data = result[0]
                        self.arrProductDetialWithCustomer.append(data)
                        let advanceData = AdvanceAllData(productDetailId: data.productDetailId, date:value.date, time: value.time, advance: value.advance, remains: value.remains, pickupNumber: value.pickupNumber, customerId: data.customerId, productId: data.productId, customerName: data.customerName,customerNumber:value.customerNumber, iteamName: data.iteamName, paiedDate: data.paiedDate, price: data.price, quantity: data.quantity, status: data.status, billNumber: data.billNumber)
                        self.arrAllAdvanceDetail.append(advanceData)
                    } failure: { (isFailed) in
                        tblDisplay.reloadData()
                    }
                }
                tblDisplay.reloadData()
            }
            
        } failure: { (isFailed) in
            self.arrProductDetialWithCustomer.removeAll()
            self.arrAllAdvanceDetail.removeAll()
            tblDisplay.reloadData()
        }
    }
    
    func moveToAdvance(viewcontroller:UIViewController,index:Int,tableView:UITableView) {
        let objAdvance:AdvanceOrderViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AdvanceOrderViewController") as! AdvanceOrderViewController
        objAdvance.modalPresentationStyle = .overFullScreen
        objAdvance.objAdvanceOrderViewModel.isFromAddDetails = true
        if  index != -1 {
            objAdvance.objAdvanceOrderViewModel.objAdvanceDetail = arrAllAdvanceDetail[index]
            objAdvance.objAdvanceOrderViewModel.isFromAddDetails = false 
        }
        objAdvance.updateData = {[weak self] in
            self?.fetchAllData(tblDisplay: tableView)
        }
        viewcontroller.present(objAdvance, animated: true, completion: nil)
    }
}
extension ListAdvanceViewModel:CustomTableDelegate,CustomTableDataSource {
    func numberOfRows() -> Int {
        return arrAllAdvanceDetail.count
    }
    func heightForRow() -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func numberOfItemAtIndex<T>(index: Int) -> T {
        return arrAllAdvanceDetail[index] as! T
    }
}
extension ListAdvanceViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Add".localized() + " " + "Order Detail".localized(), icon: UIImage(named: "product")) {item in
            DispatchQueue.main.async {
                self.objListAdvanceViewModel.moveToAdvance(viewcontroller: self, index: -1, tableView: self.tblDisplay)
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
                
                let data = lastTwo.lowercased().components(separatedBy: "Index".localized().lowercased())
                if data.count > 1 && self?.objListAdvanceViewModel.isDataMatch == false {
                    if let range = lastTwo.lowercased().range(of: "Index".localized().lowercased()) {
                        let value:String = String(lastTwo[range.upperBound...])
                        print("data = \(data)")
                        self!.objListAdvanceViewModel.isDataMatch = true
                        if !data.last!.isEmpty && value.count > 0 {
                            var lastValue:String = removeWhiteSpace(strData: data.last!)
                            if  !lastValue.isNumeric {
                                lastValue =  String(split.suffix(1).joined(separator: [" "]))
                                let number = lastValue.spelled
                                if !lastValue.contains("ze")  && number == 0 {
                                    return
                                }
                                lastValue = String(number)
                                self!.objListAdvanceViewModel.moveToAdvance(viewcontroller: self!, index: number, tableView: self!.tblDisplay)
                                
                            }
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            self!.objListAdvanceViewModel.isDataMatch = false
                        }
                    }
                }
                
                let newdata = lastTwo.lowercased().components(separatedBy: "Edit".localized().lowercased())
                if newdata.count > 0 && self?.objListAdvanceViewModel.isSpeakFound == true {
                    if let range = lastTwo.lowercased().range(of: "Edit".localized().lowercased()) {
                        self?.objListAdvanceViewModel.isSpeakFound = false
                        var string:String = "please select one index"
                        for i in 0...self!.objListAdvanceViewModel.arrAllAdvanceDetail.count - 1 {
                            string = string + " " + "index is \(i) for " + self!.objListAdvanceViewModel.arrAllAdvanceDetail[i].iteamName
                        }
                        DispatchQueue.main.async {
                            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: string)
                        }
                        let value:String = String(lastTwo[range.upperBound...])
                        if value.count > 0 {
                            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "speak is stop now If you want to start then change the Speech setup from setting".localized())
                        }
                    }
                }
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
}
