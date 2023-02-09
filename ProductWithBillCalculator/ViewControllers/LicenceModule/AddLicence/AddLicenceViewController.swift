//
//  AddLicenceViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 08/09/21.
//

import UIKit
import Floaty

class AddLicenceViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var viewCorner: UIView!
    var floaty = Floaty()
    var isFromAdd:Bool = false
    var isReciptAttached:Bool = false
    var updateData:updateDataWhenBackClosure?
    @IBOutlet weak var btnSave: UIButton!
    var objAddLicenceViewModel = AddLicenceViewModel()
    var objLicenceData = LicenceList(licenceid: -1, licenceName: "", licenceNumber: "", paymentDate: "", registerDate: "", lastDate: "",price: "0.0", licenceImage: Data(),daysRemaining: 10000)
    @IBOutlet weak var viewbtnSave: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Opened".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    func configureData() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewbtnSave.frame.size.height = 100
        }
        objAddLicenceViewModel.viewController = self
        objAddLicenceViewModel.tblDisplayData = tblDisplayData
        objAddLicenceViewModel.setHeaderView(headerView: viewHeader, isFromAdd: isFromAdd)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        objAddLicenceViewModel.setUpCustomDelegate()
        isReciptAttached = objAddLicenceViewModel.setUpData(objLicenceList: objLicenceData, isfromAdd: isFromAdd)
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        if isFromAdd {
            btnDelete.isHidden = true
        }else {
            btnDelete.isHidden = false
        }
        btnSave.setUpButton()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        self.layoutFAB()
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
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidLoad()
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    @IBAction func btnDeleteClicked(_ sender: Any) {
        setAlertWithCustomAction(viewController: self, message: "Are you sure you have to delete this Entry".localized() + "?", ok: { (isSuccess) in
            self.objAddLicenceViewModel.deleteFromDatabase(licenceid: self.objLicenceData.licenceid) { (isSuccess) in
                if isSuccess {
                    setAlertWithCustomAction(viewController: self, message: kDeleteMessage.localized(), ok: { (isSuccess) in
                        self.updateData!()
                        self.dismiss(animated: true, completion: nil)
                    }, isCancel: false) { (isSuccess) in
                        Alert().showAlert(message:kDatafailedToSave.localized(), viewController: self)
                    }
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
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        if isFromAdd {
            objAddLicenceViewModel.saveDataInDatabase { (result) in
                if result {
                    setAlertWithCustomAction(viewController: self, message: kDataSaveSuccess.localized(), ok: { (isSuccess) in
                        self.updateData!()
                        self.dismiss(animated: true, completion: nil)
                    }, isCancel: false) { (isFailed) in
                    }
                }
            }
        } else {
            objAddLicenceViewModel.updateInDatabase(updateData: { (result) in
                if result {
                    setAlertWithCustomAction(viewController: self, message: kDataUpdate.localized(), ok: { (isSUccess) in
                        self.updateData!()
                        self.dismiss(animated: true, completion: nil)
                    }, isCancel: false) { (isFailed) in
                    }
                } else {
                    self.updateData!()
                    Alert().showAlert(message:kDatafailedToSave.localized(), viewController: self)
                }
            }, objLicenceData: objLicenceData)
        }
    }
}
extension AddLicenceViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return objAddLicenceViewModel.numberOfRows()
        } else {
            return 1
        }
       
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return objAddLicenceViewModel.heightForRow()
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 100
            } else {
                return 70
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanTextFieldTableViewCell") as! LoanTextFieldTableViewCell
            objAddLicenceViewModel.setUpCell(index: indexPath.row, cell: cell)
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "AddRecipesTableViewCell") as! AddRecipesTableViewCell
            if isFromAdd {
                cell.lblRecipsTitle.text = "Add".localized() + " " + "License".localized() + " " + "Image".localized()
            }
            else {
                if isReciptAttached {
                    cell.lblRecipsTitle.text = "Show".localized() + " " + "License".localized() + " " + "Image".localized()
                } else {
                    cell.lblRecipsTitle.text = "Add".localized() + " " + "License".localized() + " " + "Image".localized()
                }
            }
            cell.selectionStyle = .none
            return cell
        }

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            objAddLicenceViewModel.moveToImage(isFromAdd: isFromAdd, isReciptAttached: isReciptAttached)
        }
    }
    
}
