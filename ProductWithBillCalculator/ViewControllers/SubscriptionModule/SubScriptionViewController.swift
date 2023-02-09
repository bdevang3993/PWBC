//
//  SubScriptionViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/11/21.
//

import UIKit
import Floaty
class SubScriptionViewController: UIViewController {
    @IBOutlet weak var lblSubScriptionTitle: UILabel!
    @IBOutlet weak var lblAllAccess: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet weak var lblNextBilling: UILabel!
    var objSubscription = SubScriptionViewModel()
    var floaty = Floaty()
    @IBOutlet weak var btnSubscription: UIButton!
    @IBOutlet weak var btnCancelSubScription: UIButton!
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
        viewHeader.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.view.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        objSubscription.setHeaderView(headerView: viewHeader)
        btnSubscription.setUpButton()
        self.btnSubscription.setTitle("Subscribe".localized(using: "ButtonTitle"), for: .normal)
        btnCancelSubScription.setUpButton()
        self.btnCancelSubScription.setTitle("Cancel Subscription".localized(using: "ButtonTitle"), for: .normal)
        self.checkForData()
        self.layoutFAB()
        self.lblSubScriptionTitle.text = "PWBC" + " " + "SubScription".localized()
        self.lblAllAccess.text = "All".localized() + " " + "Access".localized()
        self.lblPrice.text = "179.0($1.99) / 1" + " " + "year".localized()
    }
    override func viewDidAppear(_ animated: Bool) {
        if isSpeackSpeechOn {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    func  checkForData()  {
        let setUpURl = FileStoragePath.objShared.setUpDateStorageURl()
        let backupUrl = setUpURl.appendingPathComponent("selectedDate.txt")
        var strDate:String = ""
        do {
            strDate = try String(contentsOf: backupUrl)
            if strDate.count > 0 {
                DispatchQueue.main.async {
                    self.lblNextBilling.text = "Next Billing date".localized() + " " + strDate
                }
            }
        }
        catch {
            //Alert().showAlert(message: "Issue getting data run another time", viewController: self)
        }
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidLoad()
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    @IBAction func btnCancelSubscriptionClicked(_ sender: Any) {
        DispatchQueue.main.async {
              UIApplication.shared.open(URL(string: "https://apps.apple.com/account/subscriptions")!, options: [:], completionHandler: nil)
            }
    }
    @IBAction func btnSubscriptionClicked(_ sender: Any) {
        let loaderViewController:LoaderViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "LoaderViewController") as! LoaderViewController
        loaderViewController.isFromPayMentGatWay = true
        loaderViewController.isbtnCloseShow = true
        loaderViewController.modalPresentationStyle = .overFullScreen
        self.present(loaderViewController, animated: false, completion: nil)
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
