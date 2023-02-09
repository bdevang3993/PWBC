//
//  PaySomeAmountViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 01/09/21.
//

import UIKit

class PaySomeAmountViewController: UIViewController {
    
    @IBOutlet weak var viewBtnSubmit: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var btnSave: UIButton!
    var updateAllData:updateDataWhenBackClosure?
    var objPaySomeAmountViewModel = PaySomeAmountViewModel()
    var objProductDetailsQuery = ProductDetailsQuery()
//    var objUserAdvanceQuery = UserAdvanceQuery()
//    var objUserExpenseQuery = UserExpenseQuery()
    var totalAmount:Int = 0
//    var arrBorrowDetail = [[String:Any]]()
    var arrProductDetialWithCustomer = [ProductDetialWithCustomer]()
    var isFromSelectDate:Bool = false
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
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidLoad()
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        if isFromSelectDate {
            let valied = self.checkForDateValidation()
            if  valied {
                self.deleteEntrybetweenDatesFromDatabase()
            }
        } else {
            let valied = self.checkForValidation()
            if valied {
                self.updateInDatabase()
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
