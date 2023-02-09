//
//  SubscriptionViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/11/21.
//

import UIKit
import Floaty
class SubScriptionViewModel: NSObject {
    var headerViewXib:CommanView?
    var isFromBack:Bool = true
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.lblTitle.text = "Subscription Detail".localized()
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.btnBack.setTitle("", for: .normal)
        headerViewXib?.btnBack.addTarget(SubScriptionViewController(), action: #selector(SubScriptionViewController.backClicked), for: .touchUpInside)
        //  headerViewXib!.layoutConstraintbtnCancelLeading.constant = 0.0
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
}
extension SubScriptionViewController: FloatyDelegate {
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
                self?.filerStringValue(strValue: result)
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }

    func filerStringValue(strValue:String) {
        //let newData = strValue.lowercased().components(separatedBy: "Device".localized().lowercased())
        let split = strValue.split(separator: " ")
        var lastTwo = String(split.suffix(2).joined(separator: [" "]))
        lastTwo = removeWhiteSpace(strData: lastTwo)
        let backData = lastTwo.lowercased().components(separatedBy:"Back".localized().lowercased())
        if backData.count > 1 {
            if objSubscription.isFromBack {
                objSubscription.isFromBack = false
                DispatchQueue.main.async {
                    self.backClicked()
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    self.objSubscription.isFromBack = true
                }
            }
            return
        }
        
    }
}
