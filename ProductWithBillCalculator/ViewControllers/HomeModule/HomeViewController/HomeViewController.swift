//
//  HomeViewController.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
import Floaty
import FSCalendar
import Localize_Swift

class HomeViewController: UIViewController,UIGestureRecognizerDelegate {
    
    @IBOutlet weak var viewBtnSave: UIView!
    @IBOutlet weak var calenderView: FSCalendar!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var tblDisplayData: UITableView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var imgDown: UIImageView!
    
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnDate: UIButton!
    var floaty = Floaty()
    var datesWithMultipleEvents = [String]()
    var tblSaveData = UITableView()
    @IBOutlet weak var viewHeader: UIView!
    let objHomeViewModel = HomeViewModel()
    var isTotalUpdateFromNotification:Bool = true
    var isSpeakOn:Bool = true
    var isSpeackFirstTime:Bool = true
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    //MARK:- Calender View
     var currentPage: Date?
      private lazy var today: Date = {
          return Date()
      }()
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
     lazy var scopeGesture: UIPanGestureRecognizer = {
          [unowned self] in
          let panGesture = UIPanGestureRecognizer(target: self.calenderView, action: #selector(self.calenderView.handleScopeGesture(_:)))
          panGesture.delegate = self
          panGesture.minimumNumberOfTouches = 1
          panGesture.maximumNumberOfTouches = 2
          return panGesture
      }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Moved".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        self.calenderView.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        objHomeViewModel.setHeaderView(headerView: viewHeader)
        btnSave.setUpButton()
        txtName.placeholder = "Select".localized() + " " + "Name".localized()
        self.btnSave.setTitle("SAVE".localized(using: "ButtonTitle"), for: .normal)
        objHomeViewModel.btnSave = btnSave
        objHomeViewModel.tableView = tblDisplayData
        tblDisplayData.delegate = self
        tblDisplayData.dataSource = self
        //self.checkForSavedDate()
        AppUpdaterMessage.getSingleton().showUpdateWithConfirmation()
        if isInternalUpdateOfView {
            currentPage = dateSelected
            isInternalUpdateOfView = false
        }
        self.configureData()
        floaty = Floaty()
        self.layoutFAB()
        //  self.restoreFromStore(backupName: kPersonDataBase)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        if isSpeackSpeechOn && isSpeakOn {
            self.isSpeakOn = false
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
                self.isSpeakOn = true
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateAllData), name: NSNotification.Name(kHomeNotification), object: nil)
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        objHomeViewModel.timeInterVal = 2
        self.clearAllEntry()
    }
    
    
    @objc func updateAllData(notification: NSNotification) {
        btnSave.isHidden = false
        if isTotalUpdateFromNotification {
            isTotalUpdateFromNotification = false
            var items = Items()
            if let newItem = notification.userInfo!["item"] as? Items {
                items = newItem
            }
            if isSpeackSpeechOn && items.isFromHome {
                items.isFromHome = false
                self.setUpSpeachView()
            }
            DispatchQueue.main.async {
                if let item = notification.userInfo!["item"] as? Items {
                    if self.objHomeViewModel.arrAllItems.count <= 0 {
                        self.objHomeViewModel.arrAllItems.append(item)
                    } else {
                        var isMatch:Bool = false
                        for i in 0...self.objHomeViewModel.arrAllItems.count - 1 {
                            let itemName = self.objHomeViewModel.arrAllItems[i].strItemsName
                            if itemName == item.strItemsName {
                                isMatch = true
                                return
                            }
                        }
                        if isMatch == false {
                            self.objHomeViewModel.arrAllItems.append(item)
                        }
                    }
                    print("Data = \(self.objHomeViewModel.arrAllItems)")
                    self.objHomeViewModel.updateTotalData()
                    self.objHomeViewModel.tableView = self.tblDisplayData
                    self.tblDisplayData.reloadData()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.isTotalUpdateFromNotification = true
            }
        }
    }
    
    func setUpSpeachView() {
        DispatchQueue.main.async {
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
            SpeachListner.objShared.setUpData(viewController: self)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.setUpSpeechData()
            MBProgressHub.dismissLoadingSpinner(self.view)
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            self.isSpeakOn = true
            self.isTotalUpdateFromNotification = true
        }
    }
    
    func loadLockViewController() {
        let loaderViewController:LoaderViewController = UIStoryboard(name: LicenceStoryBoard, bundle: nil).instantiateViewController(identifier: "LoaderViewController") as! LoaderViewController
        loaderViewController.isFromPayMentGatWay = true
        loaderViewController.modalPresentationStyle = .overFullScreen
        self.present(loaderViewController, animated: false, completion: nil)
    }
    
    func configureData() {
        imgDown.tintColor = hexStringToUIColor(hex: strTheamColor)
        if UIDevice.current.userInterfaceIdiom == .pad {
            viewBtnSave.frame.size.height = 100.0
        }
        if currentPage == nil {
            currentPage = Date()
        }
        if objHomeViewModel.arrAllItems.count > 0 {
            btnSave.isHidden = false
        } else {
            btnSave.isHidden = true
        }
        var fontSize:CGFloat = 18.0
        var rowHeight:CGFloat = 40.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 28.0
            rowHeight = 60.0
        }
        self.calenderView.appearance.weekdayFont = UIFont.systemFont(ofSize: fontSize)
        self.calenderView.appearance.titleFont =  UIFont.systemFont(ofSize: fontSize - 4.0)
        self.calenderView.rowHeight = rowHeight
        self.calenderView.weekdayHeight = rowHeight
        self.calenderView.appearance.eventDefaultColor = .black
        //UIColor(red: 31/255.0, green: 119/255.0, blue: 219/255.0, alpha: 1.0)
        self.calenderView.select(currentPage)
        objHomeViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        objHomeViewModel.viewController = self
        lblDate.text = converFunction(date: currentPage!)
        lblDate.adjustsFontSizeToFitWidth = true
        lblDate.numberOfLines = 0
        lblDate.sizeToFit()
        self.calenderView.scope = .week
        self.calenderView.dataSource = self
        self.calenderView.delegate = self
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        let userDefault = UserDefaults.standard
        let savedDate = userDefault.value(forKey: kDate)
        var isAllow:Bool = true
        let date = Date()
        let newDate = dateFormatter.string(from: date)
        let curentDate:Date = dateFormatter.date(from: newDate)!
        if savedDate != nil {
            let newDate = dateFormatter.string(from: savedDate as! Date)
            let convertSavedDate:Date = dateFormatter.date(from: newDate)!
            let diffInDays:Int = Calendar.current.dateComponents([.day], from: convertSavedDate, to:curentDate).day!
            if diffInDays <= 0 {
                isAllow = false
            } else {
                isAllow = true
            }
        }
        if appDelegate.isFirstTime && isAllow {
            self.fetchAllEvents()
        }
    }
    func getAllDataFromDB(name:String) {
        objHomeViewModel.fetchFromDatabase(date: self.currentPage!, tableView: tblDisplayData, name: name)
        tblDisplayData.reloadData()
    }
    
    @IBAction func btnPreviousClicked(_ sender: Any) {
        moveCurrentPage(moveUp: false)
    }
    
    @IBAction func btnNextClicked(_ sender: Any) {
        moveCurrentPage(moveUp: true)
    }
    func moveCurrentPage(moveUp: Bool) {
        
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = moveUp ? 1 : -1
        let currentDate = self.currentPage
        self.currentPage = calendar.date(byAdding: dateComponents, to: self.currentPage ?? self.today)
        let value = checkForNextDate(selectedDate: self.currentPage!)
        if value < 0 {
            Alert().showAlert(message: kFetureAlert.localized(), viewController: self)
            self.currentPage = currentDate
            return
        }
        self.calenderView.setCurrentPage(self.currentPage!, animated: true)
        self.calenderView.select(self.currentPage)
        historySelectedDate = self.currentPage!
        objHomeViewModel.strConvertedDate = convertdateFromDate(date: self.currentPage!)
        lblDate.text = converFunction( date: self.currentPage!)
        if txtName.text!.count > 0 {
            self.getAllDataFromDB(name: txtName.text!)
        }
    }
    
   
    
    @IBAction func btnDateClicked(_ sender: Any) {
        PickerView.objShared.setUpDatePickerWithDate(viewController: self) { (selectedDate) in
            self.lblDate.text = converFunction(date: selectedDate)
            self.objHomeViewModel.strConvertedDate = convertdateFromDate(date: selectedDate)
            self.currentPage = selectedDate
             historySelectedDate = selectedDate
            self.calenderView.setCurrentPage(self.currentPage!, animated: true)
            self.calenderView.select(self.currentPage)
            if self.txtName.text!.count > 0 {
                self.getAllDataFromDB(name: self.txtName.text!)
            }
        }
    }
    
    @IBAction func btnCustomerNameClicked(_ sender: Any) {
        let objSearchCustomer:SearchProductViewController = UIStoryboard(name: ProductStoryBoard, bundle: nil).instantiateViewController(identifier: "SearchProductViewController") as! SearchProductViewController
        objSearchCustomer.modalPresentationStyle = .overFullScreen
        objSearchCustomer.isFromHome = true
        objSearchCustomer.strTypeOfSearch = TypeOfSearch.customerName.selectedType()
        objSearchCustomer.updateSearchCustomer = {[weak self] result in
            self?.txtName.text = result.strCustomerName
            self?.objHomeViewModel.objCustomer = result
            print("all Product = \(self?.objHomeViewModel.arrProductDetialWithCustomer )")
            if self!.isTotalUpdateFromNotification {
                self?.isTotalUpdateFromNotification = false
                if isSpeackSpeechOn {
                    self!.setUpSpeachView()
                }
            }
        }
        self.present(objSearchCustomer, animated: true, completion: nil)
    }
    
    @IBAction func btnSaveClicked(_ sender: Any) {
        if txtName.text == "" {
            if isSpeackSpeechOn {
                if self.isSpeackFirstTime {
                    self.isSpeackFirstTime  = false
                    SpeachRecognizerData.objShared.setupValueForSpeak(strValue: kSelectCustomerData.localized())
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.isSpeackFirstTime  = true
                }
            } else {
                Alert().showAlert(message: kSelectCustomerData.localized(), viewController: self)
            }
            return
        }
        if isSpeackSpeechOn {
            self.objHomeViewModel.setUpInDatabase(date: self.currentPage!, tableview: self.tblDisplayData, name: self.txtName.text!)
        } else {
            setAlertWithCustomAction(viewController: self, message: "Are you sure you have to save this data into database".localized() + "?", ok: { (isSuccess) in
                self.objHomeViewModel.setUpInDatabase(date: self.currentPage!, tableview: self.tblDisplayData, name: self.txtName.text!)
            }, isCancel: false) { (isFailed) in
                
            }
        }
    }
    
    @objc func clearAllEntry() {
       MBProgressHub.showLoadingSpinner(sender: self.view)
        objHomeViewModel.arrAllItems.removeAll()
        if objHomeViewModel.arrProductDetialWithCustomer.count > 0 {
            
            let id = objHomeViewModel.arrProductDetialWithCustomer[0].customerId
            if  id == -10 {
                objHomeViewModel.objProductDetailsQuery.deleteEntryWithCustomerId(customerId: id)
            }
        }
        objHomeViewModel.arrProductDetialWithCustomer.removeAll()
        objHomeViewModel.totoalAmount = 0.0
        btnSave.isHidden = true
        MBProgressHub.dismissLoadingSpinner(self.view)
        tblDisplayData.reloadData()
        if isSpeackFirstTime {
            self.isSpeackFirstTime = false
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Clear All".localized())
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.isSpeackFirstTime = true
        }
    }
    
    func checkForSavedDate() {
        let setUpURl = FileStoragePath.objShared.setUpDateStorageURl()
        let backupUrl = setUpURl.appendingPathComponent("selectedDate.txt")
        var strDate:String = ""
        do {
            strDate = try String(contentsOf: backupUrl)
        }
        catch {
            //Alert().showAlert(message: "Issue getting data run another time", viewController: self)
        }
        if strDate.count > 0 {
            let curentDate:Date = dateFormatter.date(from: strDate)!
            let todayDate = dateFormatter.string(from: Date())
            let date = dateFormatter.date(from: todayDate)
            let diffInDays:Int = Calendar.current.dateComponents([.day], from: date!, to:curentDate).day!
            if diffInDays <= 0 {
                self.loadLockViewController()
            }
        } else {
            self.loadLockViewController()
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
