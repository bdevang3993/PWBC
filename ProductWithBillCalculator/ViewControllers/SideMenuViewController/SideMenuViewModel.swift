//
//  SideMenuViewModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit

class SideMenuViewModel: NSObject {
    var arrDescription = [String]()
    //["Home","Iteam List","Customer List","Organization Detail","Licence","Account Details","Bill List","Order Booking","Save Payer QR","Privacy Policy","Terms of Use","Apple Terms (EULA)","Setting","Event Details","Profile","Change Password","Restore Data from back up","Delete Data","Logout"]
    func setUpDescription() {
        arrDescription.removeAll()
        arrDescription.append("Home".localized())
        arrDescription.append("Iteam List".localized())
        arrDescription.append("Customer List".localized())
        arrDescription.append("Organization Detail".localized())
        arrDescription.append("License".localized())
        arrDescription.append("Account Details".localized())
        arrDescription.append("Bill List".localized())
        arrDescription.append("Order Booking".localized())
        arrDescription.append("Save Payer QR".localized())
        arrDescription.append("Privacy Policy".localized())
        arrDescription.append("Terms of Use".localized())
        arrDescription.append("Apple Terms (EULA)".localized())
        arrDescription.append("Setting".localized())
        arrDescription.append("Event Details".localized())
        arrDescription.append("Profile".localized())
        arrDescription.append("Change Password".localized())
        arrDescription.append("Restore Data from back up".localized())
        arrDescription.append("Delete Data".localized())
        arrDescription.append("Logout".localized())
    }
    
}
extension SideMenuViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 70.0
        } else {
            return 50.0
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objSideMenuViewModel.arrDescription.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "RearTableViewCell") as! RearTableViewCell
        cell.lblDescrption.text = objSideMenuViewModel.arrDescription[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            Navigation.objShared.moveToHomeViewContrller(viewController: self)
//            let objHomeView:HomeViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
//            self.revealViewController()?.pushFrontViewController(objHomeView, animated: true)
        }
        if indexPath.row == 1 {
            Navigation.objShared.moveToItemList(viewController: self)
//            let objDisplayIem:DisplayIemViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "DisplayIemViewController") as! DisplayIemViewController
//            self.revealViewController()?.pushFrontViewController(objDisplayIem, animated: true)
        }
        if indexPath.row == 2 {
            Navigation.objShared.moveToCustomerList(viewController: self)
//            let objCustomer:CustomerListViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "CustomerListViewController") as! CustomerListViewController
//            self.revealViewController()?.pushFrontViewController(objCustomer, animated: true)
        }
        if indexPath.row == 3 {
            Navigation.objShared.moveToOrganizationDescription(viewController: self)
//            let objHospital:LogoAndNameViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "LogoAndNameViewController") as! LogoAndNameViewController
//            self.revealViewController()?.pushFrontViewController(objHospital, animated: true)
        }
        if indexPath.row == 4 {
            Navigation.objShared.moveToLicenceList(viewController: self)
//            let objLicence:LicenceListViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "LicenceListViewController") as! LicenceListViewController
//            self.revealViewController()?.pushFrontViewController(objLicence, animated: true)
        }
        if indexPath.row == 5 {
            Navigation.objShared.moveToAccountDetail(viewController: self)
//            let objBorrowDetail:SearchExpnaceViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchExpnaceViewController") as! SearchExpnaceViewController
//            self.revealViewController()?.pushFrontViewController(objBorrowDetail, animated: true)
        }
        if indexPath.row == 6 {
            Navigation.objShared.moveToBillList(viewController: self)
//            let objBillList:BillListViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "BillListViewController") as! BillListViewController
//            self.revealViewController()?.pushFrontViewController(objBillList, animated: true)
        }
        if indexPath.row == 7 {
            Navigation.objShared.moveToOrderBooking(viewController: self)
//            let objListAdvance:ListAdvanceViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "ListAdvanceViewController") as! ListAdvanceViewController
//            self.revealViewController()?.pushFrontViewController(objListAdvance, animated: true)
        }
        if indexPath.row == 8 {
            Navigation.objShared.moveToPayerQR(viewController: self)
            //Save QR payer
//            let objSearchProduct:SearchProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
//            objSearchProduct.strTypeOfSearch = TypeOfSearch.payerName.selectedType()
//            self.revealViewController()?.pushFrontViewController(objSearchProduct, animated: true)
        }
        if indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 11 {
            let objTerms:TermsAndConditionViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
            if indexPath.row == 10 {
                objTerms.isfromPrivacy = false
            }else if indexPath.row == 11 {
                objTerms.isFromEULA = true
            }
            else {
                objTerms.isfromPrivacy = true
            }
            self.revealViewController()?.pushFrontViewController(objTerms, animated: true)
        }
        if indexPath.row == 12 {
            Navigation.objShared.moveToSetting(viewController: self)
//            let objTheamPicker:TheamPickerViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TheamPickerViewController") as! TheamPickerViewController
//            self.revealViewController()?.pushFrontViewController(objTheamPicker, animated: true)
        }
        if indexPath.row == 13 {
            Navigation.objShared.moveToEventDetails(viewController: self)
//            let objEventList:EventListViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "EventListViewController") as! EventListViewController
//            self.revealViewController()?.pushFrontViewController(objEventList, animated: true)
        }
        
        if indexPath.row == 14 {
            Navigation.objShared.moveToProfile(viewController: self)
//            let objProfile:SignUpViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
//            objProfile.isFromSignUp = false
//            objProfile.updateData = {[weak self] in
//            }
//            self.revealViewController()?.pushFrontViewController(objProfile, animated: true)
        }
        
        if indexPath.row == 15 {
            Navigation.objShared.changePassword(viewController: self)
//            let objChangePassword:ChangePasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
//            self.revealViewController()?.pushFrontViewController(objChangePassword, animated: true)
        }
        
        
        if indexPath.row == 16 {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to take back up from icloude".localized() + "?", ok: { (isSuccess) in
                self.moveToLoaderPage(isDelete: false)
            }, isCancel: true) { (isFalied) in
            }
        }
        
        if indexPath.row == 17 {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you want to remove database from icloude and locally, after it you can't be get any data from the app, you have to crate new user".localized() + "?", ok: { (isSuccess) in
                self.moveToLoaderPage(isDelete: true)
            }, isCancel: true) { (isFalied) in
            }
        }
        
        if indexPath.row == 18 {
            let alert = UIAlertController(title: kAppName, message: "Are you sure you want to logout".localized() + "?", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Cancel".localized(), style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK".localized(), style: .default, handler: { (logout) in
                self.moveToMainPage()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func moveToMainPage() {        
        let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
        self.view.window?.rootViewController = initialViewController
    }
    func moveToLoaderPage(isDelete:Bool) {
        let viewController = UIStoryboard(name:LicenceStoryBoard , bundle: nil).instantiateViewController(identifier: "LoaderNavigation")
        isFromDelete = isDelete
        self.view.window?.rootViewController = viewController
    }
}
