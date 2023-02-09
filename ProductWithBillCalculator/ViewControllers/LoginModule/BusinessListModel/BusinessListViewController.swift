//
//  BusinessListViewController.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import UIKit
import Localize_Swift
class BusinessListViewController: UIViewController {

    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var veiwBackground: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var viewBtnSave: UIView!
    var objBusinessViewModel = BusinessListViewModel()
    var objLangaugeViewModel = LangaugeListViewModel()
    var arrSelectedBusinessList = [BusinessType]()
    var succesUpdate:taSelctedTypeOFBusiness?
    var isFromSelectLangauge:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
    }
    override func viewWillAppear(_ animated: Bool) {
     //   NotificationCenter.default.addObserver(self, selector: #selector(setUpText), name: NSNotification.Name(LCLLanguageChangeNotification), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    
//    @objc func setUpText() {
//        self.tblDisplayData.reloadData()
//    }
    func configureData() {
        btnSave.setUpButton()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBtnSave.frame.size.height = 100
        }
        if isFromSelectLangauge {
            objLangaugeViewModel.tblDisplay = tblDisplayData
            objLangaugeViewModel.setUpCustomDelegate()
            objLangaugeViewModel.setUpLanguageSelection()
        } else {
            objBusinessViewModel.tblDisplay = tblDisplayData
            objBusinessViewModel.fetchBusinessData(arrSelectedBusinessList: arrSelectedBusinessList)
            objBusinessViewModel.setUpCustomDelegate()
        }
        objBusinessViewModel.setHeaderView(headerView: viewHeader, isFromSelectLangauge: isFromSelectLangauge)
        veiwBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.tblDisplayData.delegate = self
        self.tblDisplayData.dataSource = self
    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    @IBAction func btnSaveClicked(_ sender: Any) {
        if isFromSelectLangauge {
           
            objLangaugeViewModel.setUpSelectedLanguage(strLanguage: objLangaugeViewModel.strSelectedCode)
            self.dismiss(animated: true, completion: nil)
        } else {
            let  data:[BusinessType] = objBusinessViewModel.arrBusinessType.filter{$0.isSelected == true}
            if data.count > 0 {
                setAlertWithCustomAction(viewController: self, message: "You have selected Business Type".localized(), ok: { (isSuccess) in
                    self.succesUpdate!(data)
                    self.dismiss(animated: true, completion: nil)
                }, isCancel: false) { (isSucess) in
                }
            } else {
                Alert().showAlert(message: "Please select any one Business Type".localized(), viewController: self)
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
extension BusinessListViewController:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFromSelectLangauge {
            return objLangaugeViewModel.numberOfRows()
        } else {
            return objBusinessViewModel.numberOfRows()
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isFromSelectLangauge {
            return objLangaugeViewModel.heightForRow()
        } else {
            return objBusinessViewModel.heightForRow()
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblDisplayData.dequeueReusableCell(withIdentifier: "BusinessListTableViewCell") as! BusinessListTableViewCell
        if isFromSelectLangauge {
            self.objLangaugeViewModel.setUpCellData(cell: cell, index: indexPath.row)
        } else {
            self.objBusinessViewModel.setUpCellData(index: indexPath.row, cell: cell)
        }
       
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isFromSelectLangauge {
            self.objLangaugeViewModel.setupDataSelection(index: indexPath.row)
        } else {
            self.objBusinessViewModel.setupDataSelection(index: indexPath.row)
        }
    }
}
