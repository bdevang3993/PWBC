//
//  BillDisplayViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 14/09/21.
//

import UIKit
import Floaty
class BillDisplayViewController: UIViewController {

    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var lblGSTIN: UILabel!
    @IBOutlet weak var lblSeprator1: UILabel!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var lblSeprator2: UILabel!
    @IBOutlet weak var viewDisplayData: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var viewFooter: UIView!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblCompanyName: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblBillNO: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblThanks: UILabel!
    @IBOutlet weak var txtCustomerName: UITextField!
    var strSelectedDate:String = ""
    var updateClosure:updateDataWhenBackClosure?
    var objBillDisplayViewModel = BillDisplayViewModel()
    var objProductDetailsQuery = ProductDetailsQuery()
    var documentInteractionController:UIDocumentInteractionController!
    var arrProductDetialWithCustomer = [ProductDetialWithCustomer]()
    var objBillList = BillList(billId: 0, isPaied: false, billImage: Data(), customerName: "", customerNumber: "", date: "", amount: 0.0, billNumber: "")
    var floaty = Floaty()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
//        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    var totoalAmount:Double = 0.0
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
    
    override func viewDidAppear(_ animated: Bool) {
        if isSpeackSpeechOn {
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
    
    @objc func updateView() {
        let objBillDisplayViewController:BillDisplayViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "BillDisplayViewController") as! BillDisplayViewController
        objBillDisplayViewController.arrProductDetialWithCustomer = self.arrProductDetialWithCustomer
        objBillDisplayViewController.modalPresentationStyle = .overFullScreen
        self.view.window?.rootViewController = objBillDisplayViewController
    }
    
    @IBAction func btnBackClicked(_ sender: Any) {
        if objBillDisplayViewModel.strBillSelectedType != BillSelectionType.save.selectedType() && objBillDisplayViewModel.strBillSelectedType != "" {
           MBProgressHub.showLoadingSpinner(sender: self.view)
            let customerId = arrProductDetialWithCustomer[0].customerId
            if customerId == -10 {
                _ = objProductDetailsQuery.deleteEntryWithBillNumber(billNumber:  arrProductDetialWithCustomer[0].billNumber)
            }
            MBProgressHub.dismissLoadingSpinner(self.view)
            updateClosure!()
        }
        if isSpeackSpeechOn {
            updateClosure!()
        }
        self.dismiss(animated: true, completion: nil)
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
