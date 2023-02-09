//
//  AddProductViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit
import Floaty
class AddProductViewController: UIViewController {
    
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewBtnSave: UIView!
    var isFromProduct:Bool = false
    var isFromAddProduct:Bool = false
    var isFromAddItem:Bool = false
    var selectedIndex:Int = -1
    var floaty = Floaty()
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplay: UITableView!
    var updateAllData:updateDataWhenBackClosure?
    var updateProductData:updateAddedItem?
    var objProductViewModel = ProductViewModel()
    var objIteamViewModel = ItemViewModel()
    var objDisplayData:Items = Items(strItemsName: "", quantityPerUnit: 0.0, quantity: 0.0, strQuantityType: "", price:0.0,numberOfPice:1, totalPrice: 0.0)
    var objProductDetialWithCustomer = ProductDetialWithCustomer(productDetailId: -1, customerId: -1, productId: -1, customerName: "", date: "", iteamName: "", paiedDate: "", price: 0.0, quantity: "", status: "", billNumber: "")
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var lblGstMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ConfigureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Opened".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeachButton()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }

    func ConfigureData()  {
        lblGstMessage.text = "Please set price include GST charges".localized()
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBtnSave.frame.size.height = 100.0
        }
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        btnSave.setUpButton()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        if isFromProduct {
            btnDelete.isHidden = true
            objProductViewModel.viewController = self
            objProductViewModel.tableView = self.tblDisplay
            objProductViewModel.configureData(isFromAdd: isFromAddProduct, headerView: viewHeader, objDisplayData: (objDisplayData))
            objProductViewModel.strSelectedStringFilter = {[weak self] result in
                if result == "Reset" {
                    DispatchQueue.main.async {
                        self!.objProductViewModel.viewController = self
                        SpeachListner.objShared.setUpData(viewController: self!)
                        MBProgressHub.showLoadingSpinner(sender: self!.view)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self!.setUpSpeachButton()
                        MBProgressHub.dismissLoadingSpinner(self!.view)
                        SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
                    }
                } else {
                    self?.setUpSpeakValue(result: result)
                }
               
            }
            lblGstMessage.isHidden = true
        } else {
            lblGstMessage.isHidden = false
            objIteamViewModel.tableView = self.tblDisplay
            if isFromAddItem {
                btnDelete.isHidden = true
            }
            objIteamViewModel.configureData(isFromAdd: isFromAddItem, headerView: viewHeader, objDisplayData: (objDisplayData))
        }
        tblDisplay.delegate = self
        tblDisplay.dataSource = self
        self.layoutFAB()
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidLoad()
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        objProductViewModel.isAddFirstTime = true
        if isFromProduct {
            if isFromAddProduct {
                self.updateProductData!(objProductViewModel.selectedItem!,selectedIndex)
                self.dismiss(animated: true, completion: nil)
            } else {
                if objProductDetialWithCustomer.productDetailId == -1 {
                    self.updateProductData!(self.objProductViewModel.selectedItem!,self.selectedIndex)
                    self.dismiss(animated: true, completion: nil)
                } else {
                    objProductViewModel.updateProductDataInDataBase(objProductDetialWithCustomer: objProductDetialWithCustomer) { (isSuccess) in
                        self.updateProductData!(self.objProductViewModel.selectedItem!,self.selectedIndex)
                        FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
                        self.dismiss(animated: true, completion: nil)
                    }
                }
            }
            
        } else {
            let validation = objIteamViewModel.setUpValidation(viewController: self)
            if validation {
                objIteamViewModel.saveDataInDatabase(viewController: self) { (isSuccess) in
                    self.updateAllData!()
                    FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        objProductViewModel.isAddFirstTime = false
    }
    
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message:kDeleteMessage.localized(), ok: { (isSucces) in
            self.objIteamViewModel.deleteFromDatabase(viewController: self, itemName: self.objDisplayData.strItemsName) { (isSuccess) in
                self.updateAllData!()
                FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
                self.dismiss(animated: true, completion: nil)
            }
        }, isCancel: false) { (isFailed) in
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddProductViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromProduct {
            return objProductViewModel.numberOfRows()
        } else {
            return objIteamViewModel.numberOfRows()
        }
           
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFromProduct {
            return objProductViewModel.heightForRow()
        } else {
            return objIteamViewModel.heightForRow()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplay.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.txtDescription.tag = indexPath.row
        if isFromProduct {
            objProductViewModel.setUpCellData(cell: cell, index: indexPath.row, viewController: self)
        } else {
            objIteamViewModel.setUpCellData(cell: cell, index: indexPath.row, viewController: self)
        }
        cell.selectionStyle = .none
        return cell
    }
}
