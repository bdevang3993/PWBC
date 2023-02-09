//
//  EventListViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 11/08/21.
//

import UIKit
import Floaty

class EventListViewController: UIViewController {

    @IBOutlet weak var lblNoDataFound: UILabel!
    @IBOutlet weak var viewForHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    var floaty = Floaty()
    var arrEventDetails = [LicenceList]()
    var eventListViewModel = EventListViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
