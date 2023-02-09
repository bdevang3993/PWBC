//
//  AddCustomerViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 04/09/21.
//

import UIKit
import Floaty

class AddCustomerViewController: UIViewController {

    @IBOutlet weak var viewBtnSave: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var btnFromDevice: UIButton!
    @IBOutlet weak var tblDisplayData: UITableView!
    var isFromAdd:Bool = false
    var selectedIndex:Int = -1
    var floaty = Floaty()
    @IBOutlet weak var btnDelete: UIButton!
    var dataUpdated:updateDataWhenBackClosure?
    var objCustomerData = CustomerList(strCustomerName: "", strEmailId: "", strMobileNumber: "", customerId: -1)
    var arrAllData = [CustomerList]()
    var objAddCustomerViewModel = AddCustomerViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Alert().showAlert(message: "please select".localized() + " " + "English" + " " + "Keyboard", viewController: self)
        self.configureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Opened".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    func configureData() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBtnSave.frame.size.height = 100
        }
        if !isFromAdd {
            btnFromDevice.titleLabel?.text = ""
            btnFromDevice.isHidden = true
        } else {
            btnFromDevice.setTitle("Add from device".localized(), for: .normal)
            if arrAllData.count <= 0 {
                objAddCustomerViewModel.getAllUserName { (result) in
                    self.arrAllData = result
                }
            }
            btnDelete.isHidden = true
        }
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        objAddCustomerViewModel.isFromAdd = isFromAdd
        objAddCustomerViewModel.setHeaderView(headerView: viewHeader)
        objAddCustomerViewModel.setData(objCustomerData: objCustomerData, isFromAdd: isFromAdd)
        objAddCustomerViewModel.viewController = self
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        btnSave.setUpButton()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        objAddCustomerViewModel.tableView = tblDisplayData
        self.layoutFAB()
        objAddCustomerViewModel.dataAddedSuccess = {[weak self] index in
            self!.setUpSpeechData()
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if isSpeackSpeechOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    @objc func backClicked() {
        dataUpdated!()
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidLoad()
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    @IBAction func btnDeviceClicked(_ sender: Any) {
        objAddCustomerViewModel.moveToPhoneDirectory(objCustomerData: objCustomerData)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        let isValied = objAddCustomerViewModel.checkForValidatation()
        if isValied && isFromAdd {
           let isSuccedSaved = objAddCustomerViewModel.checkForValidation(arrAllData: arrAllData)
            if isSuccedSaved {
                objAddCustomerViewModel.saveInDatabase { (isSuccess) in
                    if isSuccess {
                        FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
                        self.dataUpdated!()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Alert().showAlert(message: kDatafailedToSave.localized(), viewController: self)
                    }
                }
            }
        } else {
            objAddCustomerViewModel.updateInDatabase(selectedIndex: objCustomerData.customerId) { (isSuccess) in
                if isSuccess {
                    FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
                    self.dataUpdated!()
                    self.dismiss(animated: true, completion: nil)
                } else {
                    Alert().showAlert(message: kDatafailedToSave.localized(), viewController: self)
                }
            }
        }
    }
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message: kDeleteMessage.localized(), ok: { (isSuccess) in
            self.objAddCustomerViewModel.deleteFromDatabase(objCustomerList: self.objCustomerData) { (isSuccess) in
                if isSuccess {
                    self.dataUpdated!()
                    self.dismiss(animated: true, completion: nil)
                }
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
extension AddCustomerViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAddCustomerViewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objAddCustomerViewModel.heightForRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        objAddCustomerViewModel.setUpCustomeCell(cell: cell, index: indexPath.row)
        cell.selectionStyle = .none
        return cell
     }
    
    
}
