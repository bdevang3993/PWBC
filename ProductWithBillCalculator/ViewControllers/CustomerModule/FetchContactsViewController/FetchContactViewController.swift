//
//  FetchContactViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 04/09/21.
//

import UIKit
import Contacts
import Floaty
typealias taSelectedData = (CustomerInfo) -> Void
class FetchContactViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var txtPersonName: UITextField!
    @IBOutlet weak var lblNoData: UILabel!
    var objFetchContact = FetchContactViewModel()
    var contacts = [CustomerInfo]()
    var oldContacts = [CustomerInfo]()
    var floaty = Floaty()
    var selectedData:taSelectedData?
    var objCustomerQuery = CustomerQuery()
    var nextIndex:Int = -1
    var isContactSync:Bool = false
    var backParent:TASelectedIndex?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
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
    
    func configureData() {
        self.getInfo()
        txtPersonName.placeholder = "Person".localized() + " " + "Name".localized()
        lblNoData.isHidden = true
        objFetchContact.setHeaderView(headerView: viewHeader)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        txtPersonName.delegate = self
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.tableFooterView = UIView()
        tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        self.fetchContacts()
        self.layoutFAB()
    }
    private func fetchContacts() {
        // 1.
        let store = CNContactStore()
        store.requestAccess(for: .contacts) { (granted, error) in
            if let error = error {
                print("failed to request access", error)
                return
            }
            if granted {
                // 2.
                let keys = [CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey]
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                do {
                    // 3.
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stopPointer) in
                        self.contacts.append(CustomerInfo(customerName: contact.givenName, mobileNumber: contact.phoneNumbers.first?.value.stringValue ?? "", emailId: ""))
                        self.oldContacts = self.contacts
                        DispatchQueue.main.async {
                            self.tblDisplayData.reloadData()
                        }
                    })
                } catch let error {
                    print("Failed to enumerate contact", error)
                }
            } else {
                print("access denied")
            }
        }
    }
    func filterSearchData(strCustomerName:String) {
        if strCustomerName.count > 1 {
            contacts = oldContacts.filter{$0.customerName.lowercased().contains(strCustomerName.lowercased())}
        } else {
            contacts = oldContacts
        }
        tblDisplayData.reloadData()
    }
    @objc func backClicked() {
        if isContactSync {
            if isSpeackSpeechOn {
                backParent!(0)
            }
            self.dismiss(animated: true, completion: nil)
        } else {
            if isSpeackSpeechOn {
                backParent!(1)
            }
            self.dismiss(animated: true, completion: nil)
            OpenListNavigation.objShared.viewController.viewDidAppear(true)
        }
    }
    @objc func syncContact() {
        MBProgressHub.showLoadingSpinner(sender: self.view)
        if self.nextIndex == 0 {
            for value in contacts {
               
                let data = objCustomerQuery.saveinDataBase(customerId:  self.nextIndex, customerName: value.customerName, emailId:value.emailId, mobileNumber: value.mobileNumber.onlyDigits())
                self.nextIndex = self.nextIndex + 1
                isContactSync = true
                print("Data = \(data)")
            }
            MBProgressHub.dismissLoadingSpinner(self.view)
        } else {
            for value in contacts {
                objCustomerQuery.fetchDataByName(customerName: value.customerName) { (result) in

                } failure: { (isSuccess) in
                    self.isContactSync = true
                    DispatchQueue.main.async {
                        let data = self.objCustomerQuery.saveinDataBase(customerId:  self.nextIndex, customerName: value.customerName, emailId:value.emailId, mobileNumber: value.mobileNumber.onlyDigits())
                        self.nextIndex = self.nextIndex + 1
                        print("data = \(data)")
                    }
                }
            }
            MBProgressHub.dismissLoadingSpinner(self.view)
        }
    }
    func getInfo() {
        objCustomerQuery.getRecordsCount { (result) in
            self.nextIndex = result + 1
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
