//
//  NavigationList.swift
//  SpeeachRecornizer
//
//  Created by devang bhavsar on 04/01/22.
//

import UIKit

class Navigation: NSObject {
    static var objShared = Navigation()
    var isFirstTime:Bool = false
    var viewController:UIViewController?
    var lastViewController = UIViewController()
    var isNavigated:Bool = true
    var strOpended = "all ready Opend"
    private override init() {
        
    }
    func checkForMoveData(strData:String,viewController:UIViewController) {
        if isFirstTime && isNavigated {
            isFirstTime = false
            self.viewController = viewController
            switch strData {
            case SideMenuTitle.home.selectedString().lowercased():
                isNavigated = false
                moveToHomeViewContrller(viewController: viewController)
                break
            case SideMenuTitle.item.selectedString().lowercased():
                isNavigated = false
                moveToItemList(viewController: viewController)
                break
            case SideMenuTitle.customer.selectedString().lowercased():
                isNavigated = false
                moveToCustomerList(viewController: viewController)
                break
            case SideMenuTitle.organization.selectedString().lowercased():
                isNavigated = false
                moveToOrganizationDescription(viewController: viewController)
                break
            case SideMenuTitle.licence.selectedString().lowercased():
                isNavigated = false
                moveToLicenceList(viewController: viewController)
                break
            case  SideMenuTitle.account.selectedString().lowercased():
                isNavigated = false
                moveToAccountDetail(viewController: viewController)
                break
            case SideMenuTitle.bill.selectedString().lowercased():
                isNavigated = false
                moveToBillList(viewController: viewController)
                break
            case SideMenuTitle.order.selectedString().lowercased():
                isNavigated = false
                moveToOrderBooking(viewController: viewController)
                break
            case SideMenuTitle.payerQR.selectedString().lowercased():
                isNavigated = false
                moveToPayerQR(viewController: viewController)
                break
            case SideMenuTitle.privacy.selectedString().lowercased():
                isNavigated = false
                moveToPrivacySetting(viewController: viewController, strType: SideMenuTitle.privacy.selectedString().lowercased())
                break
            case SideMenuTitle.terms.selectedString().lowercased():
                isNavigated = false
                moveToPrivacySetting(viewController: viewController, strType: SideMenuTitle.terms.selectedString().lowercased())
                break
            case SideMenuTitle.apple.selectedString().lowercased():
                isNavigated = false
                moveToPrivacySetting(viewController: viewController, strType: SideMenuTitle.apple.selectedString().lowercased())
                break
            case SideMenuTitle.setting.selectedString().lowercased():
                isNavigated = false
                moveToSetting(viewController: viewController)
                break
            case "settings":
                isNavigated = false
                moveToSetting(viewController: viewController)
                break
            case SideMenuTitle.event.selectedString().lowercased():
                isNavigated = false
                moveToEventDetails(viewController: viewController)
                break
            case SideMenuTitle.profile.selectedString().lowercased():
                isNavigated = false
                moveToProfile(viewController: viewController)
                break
            case SideMenuTitle.password.selectedString().lowercased():
                isNavigated = false
                changePassword(viewController: viewController)
                break
            default: break
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isNavigated = true
            }
        }
    }
    func moveToHomeViewContrller(viewController:UIViewController) {
        if viewController.isKind(of: HomeViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objHomeView:HomeViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "HomeViewController") as! HomeViewController
        viewController.revealViewController()?.pushFrontViewController(objHomeView, animated: true)
    }
    func moveToItemList(viewController:UIViewController) {
        if viewController.isKind(of: DisplayIemViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objDisplayIem:DisplayIemViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "DisplayIemViewController") as! DisplayIemViewController
        viewController.revealViewController()?.pushFrontViewController(objDisplayIem, animated: true)
    }
    func moveToCustomerList(viewController:UIViewController) {
        if viewController.isKind(of: CustomerListViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objCustomer:CustomerListViewController = UIStoryboard(name: CustomerStoryBoard, bundle: nil).instantiateViewController(identifier: "CustomerListViewController") as! CustomerListViewController
        viewController.revealViewController()?.pushFrontViewController(objCustomer, animated: true)
    }
    func moveToOrganizationDescription(viewController:UIViewController) {
        if viewController.isKind(of: LogoAndNameViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objHospital:LogoAndNameViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "LogoAndNameViewController") as! LogoAndNameViewController
        viewController.revealViewController()?.pushFrontViewController(objHospital, animated: true)
    }
    func moveToLicenceList(viewController:UIViewController) {
        if viewController.isKind(of: LicenceListViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objLicence:LicenceListViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "LicenceListViewController") as! LicenceListViewController
        viewController.revealViewController()?.pushFrontViewController(objLicence, animated: true)
    }

    func moveToAccountDetail(viewController:UIViewController) {
        if viewController.isKind(of: SearchExpnaceViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objBorrowDetail:SearchExpnaceViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchExpnaceViewController") as! SearchExpnaceViewController
        viewController.revealViewController()?.pushFrontViewController(objBorrowDetail, animated: true)
    }


    func moveToBillList(viewController:UIViewController) {
        if viewController.isKind(of: BillListViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objBillList:BillListViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "BillListViewController") as! BillListViewController
        viewController.revealViewController()?.pushFrontViewController(objBillList, animated: true)
    }

    func moveToOrderBooking(viewController:UIViewController) {
        if viewController.isKind(of: ListAdvanceViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objListAdvance:ListAdvanceViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "ListAdvanceViewController") as! ListAdvanceViewController
        viewController.revealViewController()?.pushFrontViewController(objListAdvance, animated: true)
    }
    func moveToPayerQR(viewController:UIViewController) {
        if viewController.isKind(of: SearchProductViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objSearchProduct:SearchProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchProduct.strTypeOfSearch = TypeOfSearch.payerName.selectedType()
        viewController.revealViewController()?.pushFrontViewController(objSearchProduct, animated: true)
    }
    func moveToPrivacySetting(viewController:UIViewController,strType:String) {
        if viewController.isKind(of: TermsAndConditionViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objTerms:TermsAndConditionViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        if strType == SideMenuTitle.privacy.selectedString().lowercased() {
            objTerms.isfromPrivacy = false
        }else if strType == SideMenuTitle.terms.selectedString().lowercased() {
            objTerms.isFromEULA = true
        }
        else {
            objTerms.isfromPrivacy = true
        }
        viewController.revealViewController()?.pushFrontViewController(objTerms, animated: true)
    }
    func moveToSetting(viewController:UIViewController) {
        if viewController.isKind(of: TheamPickerViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objTheamPicker:TheamPickerViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TheamPickerViewController") as! TheamPickerViewController
        viewController.revealViewController()?.pushFrontViewController(objTheamPicker, animated: true)
    }
    func moveToEventDetails(viewController:UIViewController) {
        if viewController.isKind(of: EventListViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objEventList:EventListViewController = UIStoryboard(name: SearchAndShareStoryBoard, bundle: nil).instantiateViewController(identifier: "EventListViewController") as! EventListViewController
        viewController.revealViewController()?.pushFrontViewController(objEventList, animated: true)
    }
    func moveToProfile(viewController:UIViewController) {
        if viewController.isKind(of: SignUpViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objProfile:SignUpViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "SignUpViewController") as! SignUpViewController
        objProfile.isFromSignUp = false
        objProfile.updateData = {[weak self] in
        }
        viewController.revealViewController()?.pushFrontViewController(objProfile, animated: true)
    }
    
    func changePassword(viewController:UIViewController) {
        if viewController.isKind(of: ChangePasswordViewController.self) {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: strOpended)
            self.viewController = self.lastViewController
            return
        }
        let objChangePassword:ChangePasswordViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "ChangePasswordViewController") as! ChangePasswordViewController
        viewController.revealViewController()?.pushFrontViewController(objChangePassword, animated: true)
    }
}
