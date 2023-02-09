//
//  BillListViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 22/09/21.
//

import UIKit
import Floaty
class BillListViewController: UIViewController {
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var txtSelectType: UITextField!
    @IBOutlet weak var imgDown: UIImageView!
    
    var objBillList = BillListViewModel()
    var  floaty = Floaty()
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var lblNoRecordFound: UILabel!
    @IBOutlet weak var txtSearchData: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Moved".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius:cornderRadious)
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
    }
    func configureData() {
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        lblNoRecordFound.textColor = hexStringToUIColor(hex: strTheamColor)
        lblNoRecordFound.text = "No data found".localized()
        txtSearchData.placeholder = "Customer".localized() + " " + "Name".localized() + "/" + "Mobile".localized() + " /" + "Bill Number".localized()
        objBillList.fetchAllDataByCurrentMonth(tblDispalyData: tblDisplayData, view: self.view, lblNoData: lblNoRecordFound)
        objBillList.setHeaderView(headerView: viewHeader)
        self.layoutFAB()
        self.txtSearchData.delegate = self
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
        self.viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.imgDown.tintColor = hexStringToUIColor(hex: strTheamColor)
        self.txtSelectType.text = "All".localized()
    }
    
    @IBAction func btnTypeClicked(_ sender: Any) {
        self.objBillList.setUpTypePicker(viewController: self, tblDispalyData: tblDisplayData, lblNoData: lblNoRecordFound, txtType: txtSelectType, txtName: txtSearchData)
    }
    
    @objc func deleteAllData() {
        setAlertWithCustomAction(viewController: self, message: "Are you sure delete all Paied Entries".localized(), ok: { (isSucces) in
            self.deleteSelectedData()
        }, isCancel: true) { (isCancel) in
        }
    }
    
    func deleteSelectedData() {
        var deleted:Bool = false
        for value in objBillList.arrDisplayData {
            if value.isPaied {
                deleted = objBillList.objBillDescriptionQuery.deleteEntryWithBillNumber(billNumber: value.billNumber)
                let deleted = objBillList.objProductDetailQuery.deleteEntryWithBillNumber(billNumber: value.billNumber)
            }
        }
        if deleted {
            self.objBillList.arrDisplayData.removeAll()
            self.tblDisplayData.reloadData()
            setAlertWithCustomAction(viewController: self, message: kDeleteData.localized(), ok: { (isSuccess) in
            }, isCancel: false) { (isFailed) in
            }
        } else {
            Alert().showAlert(message: "if bill is paied then only you can delete the bill".localized(), viewController: self)
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
