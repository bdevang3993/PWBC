//
//  LoaderViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 18/09/21.
//

import UIKit
import CoreData
import StoreKit

class LoaderViewController: UIViewController {
    @IBOutlet var viewMain: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    var isFromPayMentGatWay:Bool = false
    var isbtnCloseShow:Bool = false
    var recipeProducts = [SKProduct]()
    var objLoaderViewModel = LoaderViewModel()
    var myProduct:SKProduct?
    @IBOutlet weak var lblPrivacyPolicy: UILabel!
    @IBOutlet weak var lblAnd: UILabel!
    @IBOutlet weak var txtViewRules: UITextView!
    @IBOutlet weak var lblFreeSubscription: UILabel!
    @IBOutlet weak var btnClose: UIButton!
    
    @IBOutlet weak var lblTermsAndUse: UILabel!
    @IBOutlet weak var btnTermsAndUse: UIButton!
    @IBOutlet weak var btnPrivacyPolicy: UIButton!
    @IBOutlet weak var btnFreeSubScription: UIButton!
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
//        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    
    @IBOutlet weak var btnBuy: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnClose.isHidden = true
        if isbtnCloseShow {
            btnClose.isHidden = false
        }
        let jeremyGif = UIImage.gif(name: "loader")
        imgLogo.image = jeremyGif
        viewMain.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        if isFromPayMentGatWay {
            if checkForData() {
                btnFreeSubScription.isHidden = true
                lblFreeSubscription.isHidden = true
            }
            btnBuy.layer.borderWidth = 1.0
            btnReset.layer.borderWidth = 1.0
            btnBuy.layer.borderColor = UIColor.white.cgColor
            btnReset.layer.borderColor = UIColor.white.cgColor
            btnBuy.layer.cornerRadius = 10.0
            self.btnBuy.setTitle("Subscribe for  179.0($1.99)/Year".localized(using: "ButtonTitle"), for: .normal)
            btnReset.layer.cornerRadius = 10.0
            self.btnReset.setTitle("Restore Purchase".localized(using: "ButtonTitle"), for: .normal)
            IAPManager.shared.getProducts {(productResults) in
                DispatchQueue.main.async {
                    switch productResults {
                        case .success(let fetchedProducts): self.recipeProducts = fetchedProducts
                        case .failure(let error): print(error.localizedDescription)
                    }
                }
            }
        } else {
            objLoaderViewModel.viewController = self
            txtViewRules.isHidden = true
            btnBuy.isHidden = true
            btnReset.isHidden = true
            btnFreeSubScription.isHidden = true
            lblFreeSubscription.isHidden = true
            btnPrivacyPolicy.isHidden = true
            btnTermsAndUse.isHidden = true
            lblAnd.isHidden = true
            lblPrivacyPolicy.isHidden = true
            lblTermsAndUse.isHidden = true
            lblTitle.isHidden = true
            btnClose.isHidden = true
            
            if isFromDelete {
                objLoaderViewModel.destroyPersistentStore()
                objLoaderViewModel.deleteAllEntry()
                
            } else {
                objLoaderViewModel.restoreFromStore(backupName: kProductDataBase)
            }
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
    
    @IBAction func btnResetClicked(_ sender: Any) {
        //SKPaymentQueue.default().restoreCompletedTransactions()
        var isSuccess:Bool = false
        IAPManager.shared.restorePurchases {(result) in
            switch result {
                case .success(let dataSave): isSuccess = dataSave
                    break
                case .failure(let error): print(error.localizedDescription)
                    break
            }
        }
    }
    
    @IBAction func btnBuyClicked(_ sender: Any) {
        self.buyProduct(using: recipeProducts[0]) { (success) in
        }
    }
    
    func buyProduct(using product: SKProduct?, completion: @escaping (_ success: Bool) -> Void) {
        guard let product = product else { return }
        IAPManager.shared.buy(product: product) { (iapResult) in
            switch iapResult {
                case .success(let success):
                    if success {
                        let currentDate = Date()
                        var dateComponent = DateComponents()
                        dateComponent.year = 1
                        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
                        let newDate = self.dateFormatter.string(from: futureDate!)
                        self.saveDataInFile(date: newDate)
                        
                    }
                    completion(true)
                case .failure(_): completion(false)
            }
        }
    }
    
    func saveDataInFile(date:String) {
        let setUpURl = FileStoragePath.objShared.setUpDateStorageURl()
        let backupUrl = setUpURl.appendingPathComponent("selectedDate.txt")
        do {
            try date.write(to: backupUrl, atomically: true, encoding: .utf8)
            let input = try String(contentsOf: backupUrl)
            self.dismiss(animated: true, completion: nil)
        } catch {
            print(error.localizedDescription)
            Alert().showAlert(message: error.localizedDescription, viewController: self)
        }
    }
    func  checkForData() -> Bool {
        let setUpURl = FileStoragePath.objShared.setUpDateStorageURl()
        let backupUrl = setUpURl.appendingPathComponent("selectedDate.txt")
        var strDate:String = ""
        do {
            strDate = try String(contentsOf: backupUrl)
            if strDate.count > 0 {
                return true
            } else {
                return false
            }
        }
        catch {
            //Alert().showAlert(message: "Issue getting data run another time", viewController: self)
            return false
        }
    }

    @IBAction func btnFreeSubscriptionClicked(_ sender: Any) {
        if !FileStoragePath.objShared.checkForFileExist() {
            let currentDate = Date()
            var dateComponent = DateComponents()
            dateComponent.month = 3
            let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
            let newDate = self.dateFormatter.string(from: futureDate!)
            self.saveDataInFile(date: newDate)
        }
    }
    @IBAction func btnTermsofUse(_ sender: Any) {
        let objTerms:TermsAndConditionViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        objTerms.isfromPrivacy = false
        objTerms.isfromBack = true
        objTerms.modalPresentationStyle = .overFullScreen
        self.present(objTerms, animated: true, completion: nil)
        
    }
    @IBAction func btnPrivacyPolicy(_ sender: Any) {
        let objTerms:TermsAndConditionViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(identifier: "TermsAndConditionViewController") as! TermsAndConditionViewController
        objTerms.isfromPrivacy = true
        objTerms.isfromBack = true
        objTerms.modalPresentationStyle = .overFullScreen
        self.present(objTerms, animated: true, completion: nil)
    }
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
