//
//  EventListViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/08/21.
//

import Foundation
import Floaty

class EventListViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerViewXib!.lblTitle.text = "Event List".localized()   //"Journal List"
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "drawer")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(EventListViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension EventListViewController {
    func configData() {
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        self.lblNoDataFound.textColor = hexStringToUIColor(hex: strTheamColor)
        eventListViewModel.setHeaderView(headerView: self.viewForHeader)
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
        self.lblNoDataFound.isHidden = true
        self.fetchAllEvents()
        self.layoutFAB()
    }
    
    func fetchAllEvents() {
       MBProgressHub.showLoadingSpinner(sender: self.view)
        GetAllEventList.shared.fetchAllEvent { (arrEventList) in
            self.arrEventDetails.removeAll()
            self.arrEventDetails = arrEventList
            DispatchQueue.main.async {
                MBProgressHub.dismissLoadingSpinner(self.view)
                self.tblDisplayData.reloadData()
            }
        }
    }
    
    func moveToLICDetail(data:LicenceList) {
        
        let objAddLicence:AddLicenceViewController = UIStoryboard(name:LicenceStoryBoard , bundle: nil).instantiateViewController(identifier: "AddLicenceViewController") as! AddLicenceViewController
        objAddLicence.objLicenceData = data
        objAddLicence.modalPresentationStyle = .overFullScreen
        objAddLicence.updateData = {[weak self] in
            self?.fetchAllEvents()
        }
        self.present(objAddLicence, animated: true, completion: nil)
    }
}

extension EventListViewController: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return arrEventDetails.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.section == 0 {
                return 100
            } else {
                return 80
            }
        }
        else {
            if indexPath.section == 0 {
                return 70
            } else {
                return 50
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            DispatchQueue.main.async {
                cell.lblItemName.text = "Type".localized()
                cell.lblDate.text = "Date".localized()
                cell.lblPrice.text = "Remaining".localized()
            }
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "EventTableViewCell") as! EventTableViewCell
            let data = arrEventDetails[indexPath.row]
            cell.lblEventName.text = data.licenceName
            cell.lblDate.text = data.lastDate
            cell.lblDays.text = "\(data.daysRemaining)" + "Days"
            cell.contentView.backgroundColor = .white
            cell.selectionStyle = .none
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let dicData = arrEventDetails[indexPath.row]
            self.moveToLICDetail(data: dicData)
        }
    }
}

extension EventListViewController: FloatyDelegate {
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        
        floaty.addItem(SideMenuTitle.speak.selectedString(), icon: UIImage(named: "mic")) {item in
            SpeachListner.objShared.viewController = self
            self.setUpSpeechData()
        }
        self.view.addSubview(floaty)
    }
    func setUpSpeechData() {
        DispatchQueue.main.async {
            SpeachListner.objShared.selectedString = { [weak self] result in
                let split = result.split(separator: " ")
                let lastTwo = String(split.suffix(2).joined(separator: [" "]))
                print("Last String = \(lastTwo)")
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
}
