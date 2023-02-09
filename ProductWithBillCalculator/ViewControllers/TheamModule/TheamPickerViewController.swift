//
//  TheamPickerViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/08/21.
//

import UIKit
import Localize_Swift
import Floaty

class TheamPickerViewController: UIViewController {
    @IBOutlet weak var lblTheamPicker: UILabel!
    @IBOutlet weak var speachSwitch: UISwitch!
    @IBOutlet weak var lblSpeeach: UILabel!
    @IBOutlet weak var lblSpeakSpeeech: UILabel!
    @IBOutlet weak var speakSpeechSwitch: UISwitch!
    @IBOutlet weak var viewBackGroundColor: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objTheamPickerViewModel = TheamPickerViewModel()
    @IBOutlet weak var btnCheckSubScription: UIButton!
    let userDefault = UserDefaults.standard
    let availableLanguages = Localize.availableLanguages()
    var actionSheet: UIAlertController!
    var floaty = Floaty()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Moved".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(setUpText), name: NSNotification.Name( LCLLanguageChangeNotification), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.setUpSpeechData()
            MBProgressHub.dismissLoadingSpinner(self.view)
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    
    func configureData() {
        objTheamPickerViewModel.configureColorName()
        lblTheamPicker.text = "If you want to take back up of your database then please make it iCloude Storage on".localized()
        lblSpeeach.text = "Listen".localized() + " " + "Speech Setup".localized()
        lblSpeakSpeeech.text = "Speak".localized() + " " + "Speech Setup".localized()
        btnCheckSubScription.setUpButton()
        self.btnCheckSubScription.setTitle("Check SubScription".localized(using: "ButtonTitle"), for: .normal)
//        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        objTheamPickerViewModel.setHeaderView(headerView: viewHeader)
        self.setUpListen()
        self.setUpSpeak()
        viewBackGroundColor.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        tblDisplayData.tableFooterView = UIView()
        self.layoutFAB()
    }
    
    @objc func setUpText()  {
//        self.floaty.removeFromSuperview()
//        floaty = Floaty()
        self.configureData()
        self.tblDisplayData.reloadData()
    }

    @IBAction func switchSpeach(_ sender: UISwitch) {
        if sender.isOn {
            userDefault.set(true, forKey: kSpeach)
            userDefault.synchronize()
        } else {
            userDefault.set(false, forKey: kSpeach)
            userDefault.synchronize()
        }
        self.setUpListen()
        self.setUpSpeak()
    }
    @IBAction func switchSpeakSpeech(_ sender: UISwitch) {
        if sender.isOn {
            isSpeackSpeechOn = true
            if isSpeackSpeechOn {
                SpeachListner.objShared.setUpData(viewController: self)
            }
            self.setUpSpeechData()
            userDefault.set(true, forKey: kSpeach)
            userDefault.set(true, forKey: kSpeakSpeech)
            userDefault.synchronize()
        } else {
            isSpeackSpeechOn = false
            userDefault.set(false, forKey: kSpeakSpeech)
            userDefault.synchronize()
        }
        self.setUpListen()
        self.setUpSpeak()
    }
    @IBAction func btnCheckForSubscriptionClicked(_ sender: Any) {
        let objCheckSubScription:SubScriptionViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "SubScriptionViewController") as! SubScriptionViewController
        objCheckSubScription.modalPresentationStyle = .overFullScreen
        self.present(objCheckSubScription, animated: true, completion: nil)
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
