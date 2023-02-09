//
//  AddPayerDetailViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/10/21.
//

import UIKit
import Vision
import Floaty
class AddPayerDetailViewController: UIViewController {
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var txtBusinessName: UITextField!
    @IBOutlet weak var qrImage: UIImageView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var lblQRCode: UILabel!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var btnPay: UIButton!
    var strUpiLink:String = ""
    var floaty = Floaty()
    var payerDetailsQuery = PayerDetailsQuery()
    var isFromAddItem:Bool = true
    var updateAllData:updateDataWhenBackClosure?
    let objImagePickerViewModel = ImagePickerViewModel()
    let objAddPayerDetailViewModel = AddPayerDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Opened".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    func configureData() {
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        txtBusinessName.delegate = self
        txtAmount.delegate = self
        self.fetchId()
        objAddPayerDetailViewModel.setHeaderView(headerView: viewHeader)
        btnSave.setUpButton()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        btnPay.setUpButton()
        self.btnPay.setTitle("PAY".localized(using: "ButtonTitle"), for: .normal)
        txtAmount.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        txtAmount.attributedPlaceholder = NSAttributedString(string: txtAmount.placeholder!,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        txtAmount.isHidden = true
        lblQRCode.text = "Click here to Add QR Code".localized()
        txtBusinessName.placeholder = "Business".localized() + " " + "Name".localized()
        btnPay.isHidden = true
        if isFromAddItem == false {
            txtAmount.isHidden = false
            txtBusinessName.text = objAddPayerDetailViewModel.objPayerData.strName
            objAddPayerDetailViewModel.newId = objAddPayerDetailViewModel.objPayerData.id
            self.btnPay.isHidden = false
            self.createQRCode()
        }
        self.layoutFAB()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if isSpeackSpeechOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    
    
    @IBAction func btnQRCodeClicked(_ sender: Any) {
        self.alertForImage()
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        if self.txtBusinessName.text!.count <= 0 {
            Alert().showAlert(message: "please provide".localized() + " " + "Business".localized() + " " +  "Name".localized(), viewController: self)
            return
        }
        if self.objAddPayerDetailViewModel.strURlLink.count <= 0 {
            Alert().showAlert(message: "please selet".localized() + " " + "QRCode".localized(), viewController: self)
            return
        }
        setAlertWithCustomAction(viewController: self, message: "Are you sure you have save this entry".localized() + "?", ok: { (isSuccess) in
            self.saveInDatabase()
        }, isCancel: false) { (isFailed) in
        }
    }
    
    func createQRCode() {
        strUpiLink = objAddPayerDetailViewModel.objPayerData.strURL
        print("Link = \(strUpiLink)")
        if txtAmount.text!.count > 0 {
            if strUpiLink.contains("&am=") {
            }else{
                strUpiLink = strUpiLink.appending("&am=\(txtAmount.text ?? "0")")
            }
        }
       
        let data = strUpiLink.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        filter!.setValue("Q", forKey: "inputCorrectionLevel")
       let qrcodeImage = filter?.outputImage
        let scaleX = qrImage.frame.size.width / qrcodeImage!.extent.size.width
        let scaleY = qrImage.frame.size.height / qrcodeImage!.extent.size.height
        let transformedImage = qrcodeImage!.transformed(by: CGAffineTransform(scaleX: scaleX, y: scaleY))
        qrImage.image = UIImage(ciImage: transformedImage)
        let imageData = qrImage.image!.pngData()
        print("image data = \(imageData)")
    }
    
    @IBAction func btnPayClicked(_ sender: Any) {
        if txtAmount.text!.count >  0 {
            strUpiLink = objAddPayerDetailViewModel.objPayerData.strURL
            if txtAmount.text!.count > 0 {
                self.createQRCode()
               // strUpiLink = strUpiLink.appending("&am=\(txtAmount.text ?? "0")")
                let url = NSURL(string: strUpiLink)! as URL
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:]) { (isSuccess) in
                        if isSuccess {
                            Alert().showAlert(message: "Payment".localized() + " " + "successfully".localized(), viewController: self)
                        } else {
                            Alert().showAlert(message: "Payment failed please try again".localized(), viewController: self)
                        }
                    }
                    UIApplication.shared.open(url)
                } else {
                    print("Can't open url on this device")
                }
                
                
//                UIApplication.shared.open(NSURL(string: strUpiLink)! as URL, options: [:], completionHandler: nil)
            }
        } else {
            Alert().showAlert(message: "please provide".localized() + " " + "Amount".localized(), viewController: self)
        }
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidLoad()
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    
    @objc func deleteClicked() {
        setAlertWithCustomAction(viewController: self, message: kDeleteMessage.localized() , ok: { (isSuccess) in
            let value = self.objAddPayerDetailViewModel.payerDetailsQuery.delete(id: self.objAddPayerDetailViewModel.objPayerData.id)
            self.backClicked()
        }, isCancel: true) { (isFailed) in
        }
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
