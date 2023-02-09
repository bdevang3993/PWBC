//
//  ListAdvanceViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 30/09/21.
//

import UIKit
import Floaty
class ListAdvanceViewController: UIViewController {
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDisplay: UITableView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    var strSelectedNotificationOrderDate:String = ""
    var objListAdvanceViewModel = ListAdvanceViewModel()
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
        objListAdvanceViewModel.setHeaderView(headerView: viewHeader)
        objListAdvanceViewModel.fetchAllData(tblDisplay: tblDisplay)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.tblDisplay.delegate = self
        self.tblDisplay.dataSource = self
        self.tblDisplay.tableFooterView = UIView()
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
extension ListAdvanceViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return objListAdvanceViewModel.numberOfRows()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return objListAdvanceViewModel.heightForRow()
        } else {
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 100.0
            } else {
                return 70.0
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplay.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            DispatchQueue.main.async {
                cell.lblItemName.text = "Name".localized()
                cell.lblDate.text = "Date".localized()
                cell.lblPrice.text = "Time".localized()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplay.dequeueReusableCell(withIdentifier: "EntryTableViewCell") as! EntryTableViewCell
            let data:AdvanceAllData = objListAdvanceViewModel.numberOfItemAtIndex(index: indexPath.row)
            cell.lblItemDetails.text = data.iteamName
            if strSelectedNotificationOrderDate == data.date {
                cell.contentView.backgroundColor = .orange
            } else {
                cell.contentView.backgroundColor = .white
            }
            cell.lblItemType.text = data.date
            cell.lblItemPrice.text = data.time
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            objListAdvanceViewModel.moveToAdvance(viewcontroller: self, index: indexPath.row, tableView: tblDisplay)
        }
    }
}
