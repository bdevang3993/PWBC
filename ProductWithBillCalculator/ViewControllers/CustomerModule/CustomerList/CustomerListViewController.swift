//
//  CustomerListViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 06/09/21.
//

import UIKit
import Floaty

class CustomerListViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objCustomerListViewModel = CustomerListViewModel()
    var floaty = Floaty()
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
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    func configureData() {
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        objCustomerListViewModel.viewController = self
        objCustomerListViewModel.setHeaderView(headerView: viewHeader)
        objCustomerListViewModel.getDataFromDB()
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        layoutFAB()
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.tableFooterView = UIView()
        tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
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
extension CustomerListViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return objCustomerListViewModel.numberOfRows()
        } else {
            return 1
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 90
        } else {
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            DispatchQueue.main.async {
                cell.lblItemName.text = "Name".localized()
                cell.lblPrice.text = "Email".localized()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            let data:CustomerList = objCustomerListViewModel.numberOfItemAtIndex(index: indexPath.row)
                cell.lblItemDetails.text = data.strCustomerName
            cell.lblItemPrice.text = data.strEmailId
            cell.lblItemPrice.adjustsFontSizeToFitWidth = true
            cell.lblItemPrice.numberOfLines = 0
            cell.lblItemPrice.sizeToFit()
            cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            //let data:CustomerList = objCustomerListViewModel.numberOfItemAtIndex(index: indexPath.row)
            objCustomerListViewModel.moveToAddCustomer(index: indexPath.row, tablView: tableView)
        }
    }
    
}
