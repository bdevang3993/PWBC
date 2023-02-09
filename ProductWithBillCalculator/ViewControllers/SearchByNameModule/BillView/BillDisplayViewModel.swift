//
//  BillDisplayViewModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 14/09/21.
//

import UIKit
import Floaty
import Screenshots
import IQKeyboardManagerSwift
import MessageUI
enum BillSelectionType {
   case save,share,message,mail,WhatsApp
   func selectedType() -> String {
       switch self {
       case .save:
           return "Save"
       case .share:
           return "Share"
       case .message:
           return "Message"
       case .mail:
           return "Mail"
       case .WhatsApp:
            return "WhatsApp"
       }
   }
}
class BillDisplayViewModel: NSObject {
 var arrFooter = [String]()
 var arrFooterDescription = ["","","","0%",""]
 var objBillDescriptionQuery = BillDescriptionQuery()
 var objProductDetailsQuery = ProductDetailsQuery()
 var isBillPaied:Bool = false
 var strBillSelectedType:String = ""
 var objCustomerQuery = CustomerQuery()
 var strBillStatus:String = kBorrowStatus
 var isFromAdvanceOrder:Bool = false
 var strCutomerNumber:String = ""
 var strCustomerEmailId:String = ""
 var billID:Int = 0
    var isFirstTimeBillShare:Bool = true
    func fetchId() {
        objBillDescriptionQuery.getRecordsCount { (id) in
            self.billID = Int(id) + 1
        }
    }
    func fetchNumberOfCustomer(name:String) {
        objCustomerQuery.fetchDataByName(customerName: name) { (result) in
            self.strCutomerNumber = result[0].strMobileNumber
            self.strCustomerEmailId = result[0].strEmailId
        } failure: { (isFalied) in
        }
    }

}

extension BillDisplayViewController {
    func  configureData() {
        objBillDisplayViewModel.arrFooter.removeAll()
        objBillDisplayViewModel.arrFooter.append(BillFooterTitle.amount.selectedString())
        objBillDisplayViewModel.arrFooter.append(BillFooterTitle.gstTax.selectedString())
        objBillDisplayViewModel.arrFooter.append(BillFooterTitle.totalAmount.selectedString())
        objBillDisplayViewModel.arrFooter.append(BillFooterTitle.discount.selectedString())
        objBillDisplayViewModel.arrFooter.append(BillFooterTitle.paybleAmount.selectedString())
        
        txtCustomerName.attributedPlaceholder = NSAttributedString(string: txtCustomerName.placeholder!,
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        objBillDisplayViewModel.fetchNumberOfCustomer(name: arrProductDetialWithCustomer[0].customerName)
        objBillDisplayViewModel.fetchId()
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewFooter.frame.size.height = 226
        }
        if arrProductDetialWithCustomer.count > 0 {
            let customerName = arrProductDetialWithCustomer[0].customerName
            if customerName == "Customer Name" {
                txtCustomerName.isEnabled = true
                txtCustomerName.text = ""
            } else {
                txtCustomerName.isEnabled = false
                txtCustomerName.text =  arrProductDetialWithCustomer[0].customerName
            }
           
        }
        let userDefault = UserDefaults.standard
        if let companyName = userDefault.value(forKey: kBusinessName) {
            lblCompanyName.text = (companyName as! String).capitalized
        }
        if let number = userDefault.value(forKey: kContactNumber) {
            lblPhone.text = "Company".localized() + " " + "Number".localized() + " : " + (number as! String)
        }
        if let address = userDefault.value(forKey: kAddress) {
            lblAddress.text = (address as! String)
        }
        if let gstInNumber = userDefault.value(forKey: kGSTINNumber) {
            lblGSTIN.text = "GST".localized() + " " + "Number".localized() + ": " + (gstInNumber as! String)
        } else {
            lblGSTIN.text = "GST".localized() + " " + "Number".localized() + ": " + "Not Applied".localized()
        }
        if let upiID = userDefault.value(forKey: kUpiId) {
            lblThanks.text = "Thank you for the privilege of our business, If you have any query then please visit us, if you want to pay using payment gatway then please use".localized() + " " + "\(upiID)" + "upi id or given above number".localized() + "."
        }else {
            lblThanks.text = "Thank you for the privilege of our business, If you have any query then please visit us, if you want to pay using payment gatway then please use".localized() + " " + "upi id or given above number".localized() + "."
        }
        if  userDefault.value(forKey: kLogo) != nil {
            let image = getSavedImage(named: kLogo)
            self.imgLogo.image = self.setUpWaterMarkImages(image: image!)
        } else {
            let image = UIImage(named: "Logo")
            self.imgLogo.image = self.setUpWaterMarkImages(image: image!)
        }
        let arrData = lblCompanyName.text?.split(separator: " ")
        var firstLater:String = ""
        if userDefault.value(forKey: kDiscount) != nil {
            objBillDisplayViewModel.arrFooterDescription[3] = userDefault.value(forKey: kDiscount) as! String
        }
        if arrData!.count > 0 {
            for i in 0...arrData!.count - 1 {
                firstLater = firstLater + String(arrData![i].first!)
            }
        }
        let date = Date()
        let newDate:String = convertdateFromDate(date: date)
        let arrDate = newDate.split(separator: " ")
        lblDate.text = strSelectedDate//String(arrDate[0])
        lblTime.text = String(arrDate[1] + arrDate[2])
        lblThanks.adjustsFontSizeToFitWidth = true
        firstLater = firstLater.capitalized
        let strdate = convertMonthAndYearFromDate(date: date)
        if userDefault.value(forKey: kBillId) != nil {
            objBillDisplayViewModel.billID = userDefault.value(forKey: kBillId) as! Int
            objBillDisplayViewModel.billID =  objBillDisplayViewModel.billID + 1
        }
        let billId = String(format: "%06d", objBillDisplayViewModel.billID)
        lblBillNO.text = firstLater + "/" + billId + "/" + strdate
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        
//        self.txtView.linkTextAttributes = [
//            .foregroundColor: UIColor.blue,
//            .underlineStyle: NSUnderlineStyle.single.rawValue
//        ]
        self.layoutFAB()
        self.updateTotalData()
    }
    
    
    func setUpWaterMarkImages(image:UIImage) -> UIImage {
          let img2 = image
            let img2Rect = CGRect(x: 0, y: 0, width: img2.size.width, height: img2.size.height)
            UIGraphicsBeginImageContextWithOptions(img2.size, true, 0)
            let context = UIGraphicsGetCurrentContext()

            context!.setFillColor(UIColor.white.cgColor)
            context!.fill(img2Rect)

            img2.draw(in:img2Rect, blendMode: .normal, alpha: 1)

            let result = UIGraphicsGetImageFromCurrentImageContext()
//            imageView.image = result
            UIGraphicsEndImageContext()
            return result!
    }
    
    
    
    func updateTotalData() {
        totoalAmount = 0
        if arrProductDetialWithCustomer.count > 0 {
            for i in 0...arrProductDetialWithCustomer.count - 1 {
                let data = arrProductDetialWithCustomer[i]
                let value:Double = data.price
                totoalAmount = totoalAmount + value
            }
        }
        let userDefault = UserDefaults.standard
        
        if let percentage = userDefault.value(forKey: kGSTPercentage) {
            objBillDisplayViewModel.arrFooterDescription[1] = "\(percentage) %"
            let value:Double = Double(percentage as! String)!
            let withoutTex = totoalAmount * (value/100)
            let newAmount = totoalAmount - withoutTex
            objBillDisplayViewModel.arrFooterDescription[0] = "\(newAmount)"
        }
        objBillDisplayViewModel.arrFooterDescription[2] = "\(totoalAmount)"
        if userDefault.value(forKey: kDiscount) != nil {
            let data:String  = userDefault.value(forKey: kDiscount) as! String
            let strDiscountPercentage =  data.split(separator: "%")
            let discountValue:Double = Double(strDiscountPercentage[0])!
            let afterDiscountTotal:Double = totoalAmount * (discountValue / 100)
            let totalPrice = totoalAmount - afterDiscountTotal
            objBillDisplayViewModel.arrFooterDescription[4] = "\(totalPrice)"
        } else {
            objBillDisplayViewModel.arrFooterDescription[4] = "\(totoalAmount)"
        }
        self.tblDisplayData.reloadData()
    }
    
    
    func checkForStatus() {
        if txtCustomerName.text!.count <= 0 {
            Alert().showAlert(message: "please provide customer name".localized(), viewController: self)
        }
        let objData = arrProductDetialWithCustomer[0]
        let status = objData.status
        if status == kBorrowStatus  {
            let alertController = UIAlertController(title: kAppName, message: "please select bill status".localized(), preferredStyle: .alert)
            // Create the actions
            let okAction = UIAlertAction(title: kPaiedStatus, style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.objBillDisplayViewModel.isBillPaied = true
                self.updateInProductData()
            }
            let cancelAction = UIAlertAction(title: "Dues", style: UIAlertAction.Style.default) {
                UIAlertAction in
                self.objBillDisplayViewModel.isBillPaied = false
                self.updateInProductData()
            }
            // Add the actions
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            // Present the controller
            self.present(alertController, animated: true, completion: nil)
        } else {
            if objBillDisplayViewModel.isFromAdvanceOrder {
                self.objBillDisplayViewModel.isBillPaied = true
            }
            self.updateInProductData()
        }
    }
    
    
    func updateInProductData() {
        self.updateInProductDescription()
        let image = self.screenshot()
        self.saveInDatabase(image: image)
    }
    
    
    func updateInProductDescription() {
       // updateWithDate
        var strDate:String = ""
        var strStatus:String = kBilledStatus//objBillDisplayViewModel.strBillStatus
        //let selectedDate = dateFormatter.string(from: Date())
        for value in arrProductDetialWithCustomer {
            objBillDisplayViewModel.strBillStatus = value.status
            if self.objBillDisplayViewModel.isBillPaied {
                strStatus = kPaiedStatus
                strDate = strSelectedDate
            }
            let updated = objBillDisplayViewModel.objProductDetailsQuery.updateWithDate(productDetailId: value.productDetailId, status: strStatus, date: strSelectedDate, billNumber: lblBillNO.text!, customerName: txtCustomerName.text!)
        }
    }
    
    func saveInDatabase(image:UIImage) {
        if objBillDisplayViewModel.strBillStatus == kBorrowStatus || objBillDisplayViewModel.isFromAdvanceOrder {
            let success = saveImage(image: image)
            let lblDate = strSelectedDate//self.dateFormatter.string(from: Date())
            let save = objBillDisplayViewModel.objBillDescriptionQuery.saveinDataBase(billId: objBillDisplayViewModel.billID, isPaied: self.objBillDisplayViewModel.isBillPaied, billImage: success.1, customerName: txtCustomerName.text!, customerNumber: objBillDisplayViewModel.strCutomerNumber, date: strSelectedDate, amount: Double(objBillDisplayViewModel.arrFooterDescription[2])!, billNumber: lblBillNO.text!)
           
            if save {
                switch objBillDisplayViewModel.strBillSelectedType {
                case BillSelectionType.save.selectedType():
                    setAlertWithCustomAction(viewController: self, message: kDataSaveSuccess.localized(), ok: { (isSuccess) in
                        self.updateClosure!()
                        self.dismiss(animated: true, completion: nil)
                    }, isCancel: false) { (isFailed) in
                    }
                    break
                case BillSelectionType.share.selectedType():
                    self.shareImage(image: image)
                    break
                case BillSelectionType.message.selectedType():
                    self.sendViaMessage(image: image)
                    break
                case BillSelectionType.mail.selectedType():
                    self.sendViaMail(image: image)
                    break
                case BillSelectionType.WhatsApp.selectedType():
                    self.sendViaWhatsApp(image: image)
                default:
                    break
                }
                
            }
        } else {
            Alert().showAlert(message: "This bill is alreday saved".localized(), viewController: self)
        }
    }
    
    func screenshot() -> UIImage{
        imgBack.isHidden = true
        let tableViewScreenShot = self.tblDisplayData.screenshot
        let viewScreenShot:UIImage = self.viewDisplayData.screenshot!
        let newImage:UIImage = viewScreenShot.mergeImage(image2: tableViewScreenShot!)
        imgBack.isHidden = false
        let userDefault = UserDefaults.standard
        userDefault.set(objBillDisplayViewModel.billID, forKey: kBillId)
        userDefault.synchronize()
        return newImage
    }
    
    func shareImage(image:UIImage) {
        var qrcodeImage:UIImage?
        var imageShare = [Any]()
        var urlData:URL?
        let userDefault = UserDefaults.standard
        
        if  userDefault.value(forKey: kQRCode) != nil {
            let strQRCode:String = userDefault.value(forKey: kQRCode) as! String
            let strLink = strQRCode.appending("&am=\(objBillDisplayViewModel.arrFooterDescription[4])")
            let data = strLink.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            guard let url = URL.init(string:strLink) else {
                return
            }
            urlData = url
//            UIApplication.shared.open(url, options: [:]) { (isSuccess) in
//                print("Success = \(url)")
//            }
            let filter = CIFilter(name: "CIQRCodeGenerator")
            filter!.setValue(data, forKey: "inputMessage")
            filter!.setValue("Q", forKey: "inputCorrectionLevel")
            let qrImage = filter?.outputImage
            qrcodeImage = UIImage(ciImage: qrImage!)
        }
        
        if qrcodeImage != nil {
            imageShare = [image,urlData]
        } else {
            imageShare = [image]
        }
        
        //let imageShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageShare , applicationActivities: nil)
        activityViewController.isModalInPresentation = true
        activityViewController.popoverPresentationController?.sourceView = self.viewDisplayData
        activityViewController.completionWithItemsHandler = { [weak self] (value1,value2,value3,value4) in
            setAlertWithCustomAction(viewController: self!, message: "You have share bill successfully".localized(), ok: { (isSuccess) in
                self!.updateClosure!()
                self?.dismiss(animated: true, completion: nil)
            }, isCancel: false) { (isFailed) in
            }
        }
        self.present(activityViewController, animated: true, completion: nil)
     }
    
    func sendViaMessage(image:UIImage) {
        if objBillDisplayViewModel.strCutomerNumber.count < 2 {
            self.setUpPopUpAlertMessage(strMessage: "please enter customer number".localized(), isMobileNumber: true)
        }
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = "Your Bill Number is".localized() + ":\(lblBillNO.text ?? "") " + "and".localized() + " " + "Total Amount".localized() + " " + ":\(objBillDisplayViewModel.arrFooterDescription[4])"
            controller.recipients = ["\(objBillDisplayViewModel.strCutomerNumber)"]
            controller.messageComposeDelegate = self
            if MFMessageComposeViewController.canSendAttachments() {
                let dataImage =  image.pngData()
                guard dataImage != nil else {
                    return
                }
                controller.addAttachmentData(dataImage!, typeIdentifier: "image/png", filename: "Bill.png")
            }
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    func sendViaMail(image:UIImage) {
        let strEmail:String = objBillDisplayViewModel.strCustomerEmailId
        if strEmail.count < 2 {
            self.setUpPopUpAlertMessage(strMessage: "can't be find email id please add email id", isMobileNumber: false)
          //  Alert().showAlert(message: "can't be find email id please add email id", viewController: self)
        }
        if  MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients([strEmail])
            mail.setSubject("Bill Description".localized())
            mail.setMessageBody("Your Bill Number is".localized() + ":\(lblBillNO.text ?? "")" + "and" + "Total Amount".localized() + " " + ":\(objBillDisplayViewModel.arrFooterDescription[4])", isHTML: true)
            mail.mailComposeDelegate = self
            mail.addAttachmentData(image.pngData()!,
                                   mimeType: "image/jpeg",
                                   fileName: "mydesign.jpeg")
            
            present(mail, animated: true)
          
        }
        else {
            Alert().showAlert(message: "can't be find email id please add email id", viewController: self)
        }
    }
    
    func sendViaWhatsApp(image:UIImage) {
        ShareOnWhatsApp.objShared.viewController = self
        ShareOnWhatsApp.objShared.shareSuccess = { [weak self] in
            DispatchQueue.main.async {
                setAlertWithCustomAction(viewController: self!, message: "You have share bill successfully".localized(), ok: { (isSuccess) in
                    self!.updateClosure!()
                    self?.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isFailed) in
                }
            }
        }
        ShareOnWhatsApp.objShared.shareImageOnWhatsApp(numbeString: objBillDisplayViewModel.strCutomerNumber, selectdImage: image, view: self.view) { (isSuccess) in
            
        } failed: { (strError) in
            Alert().showAlert(message: strError, viewController: self)
        }
    }
    
    func setUpPopUpAlertMessage(strMessage:String,isMobileNumber:Bool) {
        let alertController = UIAlertController(title:"PWBC", message:strMessage, preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "OK".localized(), style: .default, handler: { alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            if isMobileNumber {
                self.objBillDisplayViewModel.strCutomerNumber = firstTextField.text!
            } else {
                self.objBillDisplayViewModel.strCustomerEmailId = firstTextField.text!
            }
            print("firstName \(firstTextField.text ?? "")")
        })
        
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: .default, handler: { (action : UIAlertAction!) -> Void in })
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter text"
        }
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
extension BillDisplayViewController:UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return arrProductDetialWithCustomer.count
        } else {
            return objBillDisplayViewModel.arrFooter.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if indexPath.section ==  0 {
                return 100
            } else if indexPath.section == 1 {
                return 80
            } else {
                return 90
            }
        } else {
            if indexPath.section ==  0 {
                return 70
            } else if indexPath.section == 1 {
                return 50
            } else {
                return 60
            }
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "HeaderTableViewCell") as! HeaderTableViewCell
            DispatchQueue.main.async {
                cell.lblItemName.text = "Product".localized()
                cell.lblDate.text = "Qty".localized()
                cell.lblPrice.text = "Amount".localized()
            }
            cell.selectionStyle = .none
            return cell
        } else if indexPath.section == 1 {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "LoanDetailsTableViewCell") as! LoanDetailsTableViewCell
            let objData = arrProductDetialWithCustomer[indexPath.row]
            cell.lblDateofPay.text =  objData.iteamName
            cell.lblDateofPay.numberOfLines = 0
            cell.lblDateofPay.adjustsFontSizeToFitWidth = true
            cell.lblDateofPay.sizeToFit()
            let arrData = objData.quantity.split(separator: " ")
            let strData = arrData[0] + "X\(objData.numberOfPice)" + arrData[1]
            cell.lblBankName.text = String(strData)//"\(objData.quantity)"
            cell.lblBankName.sizeToFit()
            cell.lblDeduction.text = "\(objData.price)"
            cell.lblDeduction.sizeToFit()
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "FooterTableViewCell") as! FooterTableViewCell
            DispatchQueue.main.async {
                cell.lblTotalAmount.text = self.objBillDisplayViewModel.arrFooter[indexPath.row]
                cell.lblTotalPrice.text =  self.objBillDisplayViewModel.arrFooterDescription[indexPath.row]
            }
            return cell
        }
    }
}
extension BillDisplayViewController : UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
extension BillDisplayViewController:
     MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller:
            MFMailComposeViewController,
            didFinishWith result: MFMailComposeResult,
            error: Error?) {
            
        if let _ = error {
            self.dismiss(animated: true, completion: nil)
        }
        switch result {
            case .cancelled:
                print("Cancelled")
                break
            case .sent:
                setAlertWithCustomAction(viewController: self, message: "Mail sent successfully".localized(), ok: { (isSuccess) in
                    self.updateClosure!()
                    self.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isFailed) in
                }
                break
            case .failed:
                print("Sending mail failed")
                break
            default:
                break
        }
        controller.dismiss(animated: true, completion: nil)
    }
}
extension BillDisplayViewController:MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        setAlertWithCustomAction(viewController: self, message: "Messsage sent successfully".localized(), ok: { (isSuccess) in
            self.updateClosure!()
            self.dismiss(animated: true, completion: nil)
        }, isCancel: false) { (isFailed) in
        }
    }
}
extension BillDisplayViewController: FloatyDelegate {
    
    func layoutFAB() {
        floaty.buttonColor = hexStringToUIColor(hex:strTheamColor)
        floaty.hasShadow = false
        floaty.fabDelegate = self
        setupIpadItem(floaty: floaty)
        floaty.addItem("Save".localized(), icon: UIImage(named: "save")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have to save Bill".localized() + "?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.objBillDisplayViewModel.strBillSelectedType =  BillSelectionType.save.selectedType()
                    self.checkForStatus()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        floaty.addItem("Share".localized() + " " + "Bill".localized(), icon: UIImage(named: "share")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have share this Bill".localized() + "?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.objBillDisplayViewModel.strBillSelectedType =  BillSelectionType.share.selectedType()
                    self.checkForStatus()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        floaty.addItem("Share Bill Via Message".localized(), icon: UIImage(named: "sendMessage")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have share this Bill".localized() + "?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.objBillDisplayViewModel.strBillSelectedType =  BillSelectionType.message.selectedType()
                    self.checkForStatus()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }

        floaty.addItem("Share Bill Via Email".localized(), icon: UIImage(named: "sendEmail")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have share this Bill".localized() + "?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.objBillDisplayViewModel.strBillSelectedType =  BillSelectionType.mail.selectedType()
                    self.checkForStatus()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        floaty.addItem("Share Bill Via WhatsApp".localized(), icon: UIImage(named: "sendMessage")) {item in
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: kAppName, message: "Are you sure you have share this Bill".localized() + "?", preferredStyle: .alert)
                // Create the actions
                let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    self.objBillDisplayViewModel.strBillSelectedType =  BillSelectionType.WhatsApp.selectedType()
                    self.checkForStatus()
                }
                let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    NSLog("Cancel Pressed")
                }
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                // Present the controller
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        floaty.addItem(SideMenuTitle.speak.selectedString(), icon: UIImage(named: "mic")) {item in
            SpeachListner.objShared.viewController = self
            self.setUpSpeechData()
        }
        
        self.view.addSubview(floaty)
    }
    func setUpSpeechData() {
        DispatchQueue.main.async {
            SpeachListner.objShared.selectedString = { [weak self] result in
                self?.filterSearchWithString(strCustomerName: result)
            }
            SpeachListner.objShared.setUpSpeackRecognizer()
        }
    }
    func filterSearchWithString(strCustomerName:String) {
        let data = strCustomerName.lowercased().components(separatedBy: "Bill".lowercased())
        if data.count > 1  && objBillDisplayViewModel.isFirstTimeBillShare {
            objBillDisplayViewModel.isFirstTimeBillShare = false
            self.objBillDisplayViewModel.isBillPaied = false
            self.objBillDisplayViewModel.strBillSelectedType =  BillSelectionType.WhatsApp.selectedType()
            self.updateInProductData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.objBillDisplayViewModel.isBillPaied = true
            }
        }
        let newData = strCustomerName.lowercased().components(separatedBy: "Back".lowercased())
        if newData.count > 1 && objBillDisplayViewModel.isFirstTimeBillShare  {
            objBillDisplayViewModel.isFirstTimeBillShare = false
            self.btnBackClicked(AnyObject.self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.objBillDisplayViewModel.isBillPaied = true
            }
        }
    }
}
