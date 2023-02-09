//
//  SignUpViewController.swift
//  Economy
//
//  Created by devang bhavsar on 06/01/21.
//

import UIKit
import Floaty
class SignUpViewController: UIViewController {

    @IBOutlet weak var imgTermsAndCondition: UIImageView!
    @IBOutlet weak var lblSepratorAddress: UILabel!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var lblSepratorGST: UILabel!
    @IBOutlet weak var txtGSTPercentage: UITextField!
  
    @IBOutlet weak var layoutConstraintAgeImageTop: NSLayoutConstraint!
    @IBOutlet weak var lblnameSeprator: UILabel!
    @IBOutlet weak var lblSepratorGSTIN: UILabel!
    @IBOutlet weak var lblSepratorNumber: UILabel!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCornerSetUp: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewHeaderTbl: UIView!
    @IBOutlet weak var txtGSTIN: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var lblSepratorEmail: UILabel!
    @IBOutlet weak var lblSeparatorPassword: UILabel!
    @IBOutlet weak var lblSeparatorRePassword: UILabel!
    @IBOutlet weak var txtContactNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var layoutConstraintPasswordHeight: NSLayoutConstraint!
    @IBOutlet weak var btnBusinessType: UIButton!
    @IBOutlet weak var layoutConstraintSubmitTop: NSLayoutConstraint!
    @IBOutlet weak var layOutConstriantTopTerms: NSLayoutConstraint!
    @IBOutlet weak var btnSubmit: UIButton!
    var floaty = Floaty()
    var isFromSignUp:Bool = true
    @IBOutlet weak var txtRepassword: UITextField!
    @IBOutlet weak var layoutConstraintheightTerms: NSLayoutConstraint!
    @IBOutlet weak var lblTermsAndCondition: UILabel!
    @IBOutlet weak var btnTermsAndCondition: UIButton!
    @IBOutlet weak var imgDownBusinessType: UIImageView!
    @IBOutlet weak var lblSepratorBusinessType: UILabel!
    @IBOutlet weak var layoutConstraintHeightforAge: NSLayoutConstraint!
    
    @IBOutlet weak var txtBusinessType: UITextField!
    
    @IBOutlet weak var imgCheckeForAge: UIImageView!
    @IBOutlet weak var lblAgeChecking: UILabel!
    
    @IBOutlet weak var btnAge: UIButton!
    var objSignUpViewModel = SignUpViewModel()
    var arrBusinessType = [BusinessType]()
    var displayMemberData = [String:Any]()
    var updateData:updateDataWhenBackClosure?
    var objBusinessDatabaseQuerySetUp = BusinessDatabaseQuerySetUp()
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
//        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        objSignUpViewModel.setHeaderView(headerView: viewHeader, isfromSignUp: isFromSignUp)
        if !isFromSignUp {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            self.setUpDisplayData()
            if isSpeackSpeechOn {
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Moved".localized())
                SpeachListner.objShared.setUpStopData()
                MBProgressHub.showLoadingSpinner(sender: self.view)
            }
        }
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        if isFromSignUp == false {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
            if isSpeackSpeechOn {
                SpeachListner.objShared.setUpData(viewController: self)
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.setUpSpeechData()
                    MBProgressHub.dismissLoadingSpinner(self.view)
                    SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
                }
            }
        }
        viewCornerSetUp.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        
    }

    @IBAction func btnTermsAndConditionClicked(_ sender: Any) {
        imgTermsAndCondition.image = UIImage(named: "checked")
    }
    
    @IBAction func btnBusinessTypeClicked(_ sender: Any) {
        let objBusinessType :BusinessListViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "BusinessListViewController") as! BusinessListViewController
        objBusinessType.modalPresentationStyle = .overFullScreen
        objBusinessType.arrSelectedBusinessList = arrBusinessType
        objBusinessType.succesUpdate = {[weak self] value in
            self!.arrBusinessType = value
            let arrFilerdata = self!.arrBusinessType.compactMap{$0.strBusinessName}
            var strSelectedBusiness:String = ""
            for i in 0...arrFilerdata.count - 1 {
                if i == 0 {
                    strSelectedBusiness = arrFilerdata[i]
                } else {
                    strSelectedBusiness = strSelectedBusiness + " , " + arrFilerdata[i]
                }
            }
            self!.txtBusinessType.text = strSelectedBusiness
        }
        self.present(objBusinessType, animated: true, completion: nil)
    }
    
    @IBAction func btnSubmitClicked(_ sender: Any) {
      let isValied = self.validatation()
        if isValied {
            var dataStored:Bool = false
            var strMessage:String = "Business Register successfully".localized()
            if isFromSignUp {
                let data = txtGSTPercentage.text?.split(separator: "%")
                dataStored =  objBusinessDatabaseQuerySetUp.saveinDataBase(businessName:  txtName.text!, gstInNumber: txtGSTIN.text!, businessType: txtBusinessType.text!, contactNumber: txtContactNumber.text!, emailId: txtEmail.text!, password: txtPassword.text!, gstCharge: String(data![0]), busniessAddress: txtAddress.text!)
              
                let userDefault = UserDefaults.standard
                userDefault.setValue(txtContactNumber.text, forKey: kContactNumber)
                userDefault.setValue(txtName.text, forKey: kBusinessName)
                userDefault.setValue(txtAddress.text, forKey: kAddress)
                userDefault.setValue(txtEmail.text, forKey: kEmail)
                userDefault.setValue(txtPassword.text, forKey: kPassword)
                userDefault.setValue(txtBusinessType.text, forKey: kBusinessType)
                userDefault.setValue(data![0], forKey: kGSTPercentage)
                userDefault.setValue(txtGSTIN.text, forKey: kGSTINNumber)
                userDefault.synchronize()
                KeychainService.saveNumber(number: self.txtContactNumber.text! as NSString)
                KeychainService.saveEmail(email: self.txtEmail.text! as NSString)
                KeychainService.savePassword(token: self.txtPassword.text! as NSString)
                FileStoragePath.objShared.backupDatabase(backupName: kProductDataBase)
            } else {
                let data = txtGSTPercentage.text?.split(separator: "%")
                dataStored = objBusinessDatabaseQuerySetUp.updateDataBase(gstInNumber: txtGSTIN.text!, contactNumber: txtContactNumber.text!, emailId: txtEmail.text!, gstCharge: String(data![0]), busniessAddress: txtAddress.text!, businessName: txtName.text!)
                strMessage = "Business Update SuccessFully".localized()
            }
            if dataStored {
                updateData!()
                setAlertWithCustomAction(viewController: self, message:strMessage , ok: { (isSuccess) in
                    self.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isSuccess) in
                }
            }
        }
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnAgeClicked(_ sender: Any) {
        let image = UIImage(named: "unChecked")
        let compare = imgCheckeForAge.image?.isEqualToImage(image: image!)
        if compare! {
            imgCheckeForAge.image = UIImage(named: "checked")
        } else {
            imgCheckeForAge.image = UIImage(named: "unChecked")
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

