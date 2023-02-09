//
//  TermsAndConditionViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 19/08/21.
//

import Foundation
import Floaty

class TermsAndConditionViewModel: NSObject {
    var headerViewXib:CommanView?
    func setHeaderView(headerView:UIView,isFromBack:Bool,isPrivacy:Bool,isFromEULA:Bool) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
         headerView.frame = headerViewXib!.bounds
        if isPrivacy {
            headerViewXib!.lblTitle.text = "Privacy Policy".localized()
        }else{
            headerViewXib!.lblTitle.text = "Terms of Use".localized()
        }
        if isFromEULA {
            headerViewXib!.lblTitle.text = "Apple Terms (EULA)".localized()
        }
        headerViewXib!.btnBack.isHidden = false
        if isFromBack {
            headerViewXib!.imgBack.image = UIImage(named: "backArrow")
            headerViewXib!.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(TermsAndConditionViewController(), action: #selector(TermsAndConditionViewController.backClicked), for: .touchUpInside)
        } else {
            headerViewXib!.imgBack.image = UIImage(named: "drawer")
            headerViewXib!.lblBack.isHidden = true
            headerViewXib?.btnBack.setTitle("", for: .normal)
            headerViewXib?.btnBack.addTarget(TermsAndConditionViewController().revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        }

        
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension TermsAndConditionViewController: FloatyDelegate {
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




