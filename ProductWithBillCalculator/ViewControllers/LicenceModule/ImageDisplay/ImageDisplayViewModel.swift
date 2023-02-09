//
//  ImageDisplayViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/03/21.
//

import UIKit
import Floaty

class ImageDisplayViewModel: NSObject {
    var isFromBillDisplay:Bool = false
    var headerViewXib:CommanView?
    var objBillDescriptionQuery = BillDescriptionQuery()
    var objProductDetailsQuery = ProductDetailsQuery()
    var arrProductDetails = [ProductDetialWithCustomer]()
    var objBillList = BillList(billId: 0.0, isPaied: false, billImage: Data(), customerName: "", customerNumber: "", date: "", amount: 0.0, billNumber: "")
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
//        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    func setHeaderView(headerView:UIView) {
        if headerView.subviews.count > 0 {
            headerViewXib?.removeFromSuperview()
        }
        headerViewXib = setCommanHeaderView(width: headerView.frame.size.width)
        headerViewXib!.btnHeader.isHidden = true
        if isFromBillDisplay {
            headerViewXib!.lblTitle.text = "Customer Bill".localized()
        } else {
            headerViewXib!.lblTitle.text = "Receipet".localized()
        }
        
        headerView.frame = headerViewXib!.bounds
        headerViewXib!.btnBack.isHidden = false
        headerViewXib!.imgBack.image = UIImage(named: "backArrow")
        headerViewXib!.lblBack.isHidden = true
        headerViewXib?.btnBack.addTarget(ImageDisplayViewController(), action: #selector(ImageDisplayViewController.backClicked), for: .touchUpInside)
        headerView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        headerView.addSubview(headerViewXib!)
    }
    
    func fetchProductDetailList() {
        objProductDetailsQuery.fetchAllDataByBillNumber(billNumber: objBillList.billNumber) { (result) in
            self.arrProductDetails = result
        } failure: { (failed) in
        }
    }
    
    func setupData(imageView:UIImageView,paiedImage:UIImageView) {
        imageView.image = UIImage(data: objBillList.billImage)
        if objBillList.isPaied {
            paiedImage.image = UIImage(named: "paied")
            paiedImage.isHidden = false
        }
    }
    
    func updateInProductDescription(isPaied:Bool,paiedImage:UIImageView,view:UIView) {
        MBProgressHub.objShared.showProgressHub(view: view)
        let strDate = dateFormatter.string(from: Date())
       let valueUpdated = objBillDescriptionQuery.update(billId: Int(objBillList.billId), isPaied: isPaied)
        if self.arrProductDetails.count > 0 {
            for value in arrProductDetails {
                let data = objProductDetailsQuery.updateWithDate(productDetailId: value.productDetailId, status: kPaiedStatus, date: strDate, billNumber: value.billNumber, customerName: value.customerName)
                print(data)
            }
            MBProgressHub.objShared.hideProgressHub(view: view)
        } else {
            MBProgressHub.objShared.hideProgressHub(view: view)
        }
        if valueUpdated {
            paiedImage.image = UIImage(named: "paied")
            paiedImage.isHidden = false
        }
    }
    
    func deleteFromDatabase(view:UIView,deletData deletDataSuccess:@escaping ((Bool) -> Void))  {
        MBProgressHub.objShared.showProgressHub(view: view)
        if self.arrProductDetails.count > 0 {
            let billNumber = self.arrProductDetails[0].billNumber
            let deleted = objBillDescriptionQuery.deleteEntryWithBillNumber(billNumber: billNumber)
            if deleted {
              let deletedData = objProductDetailsQuery.deleteEntryWithBillNumber(billNumber: billNumber)
                if deletedData {
                    deletDataSuccess(true)
                    MBProgressHub.objShared.hideProgressHub(view: view)
                } else {
                    deletDataSuccess(false)
                    MBProgressHub.objShared.hideProgressHub(view: view)
                }
            } else {
                deletDataSuccess(false)
                MBProgressHub.objShared.hideProgressHub(view: view)
            }
        } else {
            MBProgressHub.objShared.hideProgressHub(view: view)
        }
    }
    
    func shareImage(image:UIImage,viewController:UIViewController) {
        let imageShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view
        viewController.present(activityViewController, animated: true, completion: nil)
     }
    

}
extension ImageDisplayViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Change Bill Status", icon: UIImage(named: "save")) {item in
            DispatchQueue.main.async {
              //  if self.imgPaied.isHidden == true {
                    let alertController = UIAlertController(title: kAppName, message: "Are you sure this bill is Paied?", preferredStyle: .alert)
                    // Create the actions
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        self.objImageDisplay.updateInProductDescription(isPaied: true, paiedImage: self.imgPaied, view: self.view)
                    }
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    }
                    // Add the actions
                    alertController.addAction(okAction)
                    alertController.addAction(cancelAction)
                    // Present the controller
                    self.present(alertController, animated: true, completion: nil)
//                } else {
//                    Alert().showAlert(message: "This bill is already Paied you can't be change the status of the bill", viewController: self)
//                }
               
            }
        }
        floaty.addItem("Share Bill", icon: UIImage(named: "share")) {item in
            DispatchQueue.main.async {
                
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you want share bill?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    var image:UIImage?
                    if self.imgPaied.image == nil {
                        image = self.imgView.image
                    } else {
                        image = self.imgPaied.image?.mergeImage(image2: self.imgView.image!)//self.objImageDisplay.mergeImage(image1: self.imgPaied.image!, image2: self.imgView.image!)
                    }
                   
                    self.objImageDisplay.shareImage(image: image!, viewController: self)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        self.view.addSubview(floaty)
    }
}
