//
//  DisplayIemViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 01/09/21.
//

import UIKit

class DisplayIemViewController: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var objDisplayItemViewModel = DisplayItemViewModel()
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
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
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
    func configureData()  {
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        objDisplayItemViewModel.fetchAllData()
        objDisplayItemViewModel.setHeaderView(headerView: viewHeader)
        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        objDisplayItemViewModel.setUpCustomDelegate()
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
        self.tblDisplayData.tableFooterView = UIView()
        objDisplayItemViewModel.tableView = self.tblDisplayData
        self.tblDisplayData.separatorColor = hexStringToUIColor(hex: strTheamColor)
        self.layoutFAB()
    }
    func nextToAddIteam() {
        let objItema:AddProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "AddProductViewController") as! AddProductViewController
        objItema.isFromProduct = false
        objItema.isFromAddItem = true
        objItema.modalPresentationStyle = .overFullScreen
        objItema.updateAllData = {[weak self] in
            self!.objDisplayItemViewModel.fetchAllData()
        }
        self.present(objItema, animated: true, completion: nil)
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

