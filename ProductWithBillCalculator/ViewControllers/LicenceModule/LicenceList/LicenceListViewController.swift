//
//  LicenceViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 08/09/21.
//

import UIKit
import Floaty

class LicenceListViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objLicenceListViewModel = LicenceListViewModel()
    var strSelectedLastDate:String = ""
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
        objLicenceListViewModel.setHeaderView(headerView: viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
        self.tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        objLicenceListViewModel.fetchAllData(tableView: tblDisplayData)
        self.layoutFAB()
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
extension LicenceListViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  section == 0 {
            return 1
        } else {
           return objLicenceListViewModel.numberOfRows()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 100.0
        } else {
            return 70.0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            DispatchQueue.main.async {
                cell.lblItemName.text = "Iteam".localized() + " " + "Name".localized()
                cell.lblPrice.text = "Date".localized()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            if indexPath.row >= 0 {
                let data:LicenceList = objLicenceListViewModel.numberOfItemAtIndex(index: indexPath.row)
                cell.lblItemDetails.text = data.licenceName
                cell.lblItemPrice.text = data.lastDate
                if data.lastDate == strSelectedLastDate {
                    cell.contentView.backgroundColor = .orange
                } else {
                    cell.contentView.backgroundColor = .white
                }
            }
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            self.objLicenceListViewModel.moveToAddLicence(viewController: self, index: indexPath.row, tableView: tblDisplayData)
        }
    }
}
