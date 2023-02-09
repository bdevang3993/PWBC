//
//  AdvanceOrderViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 30/09/21.
//

import UIKit
import Floaty

class AdvanceOrderViewController: UIViewController {

    @IBOutlet weak var imgPaied: UIImageView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDelete: UIButton!
    var floaty = Floaty()
    var objAdvanceOrderViewModel = AdvanceOrderViewModel()
    var updateData:updateDataWhenBackClosure?
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        imgPaied.isHidden = true
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.ConfigureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Opened".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    func ConfigureData()  {
        objAdvanceOrderViewModel.setHeaderView(headerView: viewHeader)
        objAdvanceOrderViewModel.getRecordId()
        objAdvanceOrderViewModel.viewController = self
        objAdvanceOrderViewModel.tableView = tblDisplayData
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBottom.frame.size.height = 100.0
        }
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        if objAdvanceOrderViewModel.isFromAddDetails {
            btnDelete.isHidden = true
        } else {
            btnDelete.isHidden = false
        }
        if objAdvanceOrderViewModel.objAdvanceDetail.status == kPaiedStatus {
            imgPaied.isHidden = false
            btnSave.isHidden = true
            self.layoutFAB()
            tblDisplayData.reloadData()
        }
        objAdvanceOrderViewModel.tableView = tblDisplayData
        objAdvanceOrderViewModel.setUpDisplayData()
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        btnSave.setUpButton()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius:cornderRadious)
        if isSpeackSpeechOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
        
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidLoad()
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    @objc func paiedClicked() {
        let isValied = objAdvanceOrderViewModel.validation()
        if isValied  {
            objAdvanceOrderViewModel.updatePaiedData { (isSuccess) in
                if isSuccess {
                    setAlertWithCustomAction(viewController: self, message: "You have paied your remaining dues".localized(), ok: { (isSuccess) in
                        self.updateData!()
                        self.dismiss(animated: true, completion: nil)
                    }, isCancel: false) { (isFailed) in
                    }
                } else {
                    Alert().showAlert(message: kDatafailedToSave.localized(), viewController: self)
                }
            }
        }
    }
    
    
    func moveToShare() {
        let objBillDisplayViewController:BillDisplayViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "BillDisplayViewController") as! BillDisplayViewController
        let strSelectedDate = dateFormatter.string(from: Date())
        objBillDisplayViewController.strSelectedDate = strSelectedDate
        objBillDisplayViewController.arrProductDetialWithCustomer = objAdvanceOrderViewModel.arrProductDetialWithCustomer
        objBillDisplayViewController.objBillDisplayViewModel.isFromAdvanceOrder = true
        objBillDisplayViewController.updateClosure = {[weak self] in
            
        }
        objBillDisplayViewController.modalPresentationStyle = .overFullScreen
        self.present(objBillDisplayViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        let isValied = objAdvanceOrderViewModel.validation()
        if isValied  {
            if objAdvanceOrderViewModel.isFromAddDetails {
                objAdvanceOrderViewModel.saveInDatabase { (isSuccess) in
                    if isSuccess {
                        setAlertWithCustomAction(viewController: self, message: kDataSaveSuccess.localized(), ok: { (isSuccess) in
                            self.updateData!()
                            self.dismiss(animated: true, completion: nil)
                        }, isCancel: false) { (isFailed) in
                        }
                    }
                }
            } else {
                objAdvanceOrderViewModel.updateInDatabase { (isSuccess) in
                    if isSuccess {
                        setAlertWithCustomAction(viewController: self, message: kDataUpdate.localized(), ok: { (isSuccess) in
                            self.updateData!()
                            self.dismiss(animated: true, completion: nil)
                        }, isCancel: false) { (isFailed) in
                        }
                    }
                }
            }
        }
    }
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message: "Are you sure you have to delete this order".localized() + "?", ok: { (isSuccess) in
            self.objAdvanceOrderViewModel.deleteFromDatabase { (isSuccess) in
                self.updateData!()
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
extension AdvanceOrderViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objAdvanceOrderViewModel.numberOfRows()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return objAdvanceOrderViewModel.heightForRow()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
        cell.txtDescription.tag = indexPath.row
        objAdvanceOrderViewModel.setUpCellData(cell: cell, index: indexPath.row, viewController: self)
        if imgPaied.isHidden == false {
            cell.txtDescription.isEnabled = false
            cell.btnSelection.isEnabled = false
        }
        cell.selectionStyle = .none
        return cell
    }
}

