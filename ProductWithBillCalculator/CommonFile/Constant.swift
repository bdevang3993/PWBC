//
//  Constant.swift
//  FugitCustomer
//
//  Created by addis on 09/02/20.
//  Copyright © 2020 addis. All rights reserved.
//

import Foundation
import UIKit
//import CoreLocation

//MARK:- Screen Resolution
let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

let MainStoryBoard = "Main"
let ProductStoryBoard = "Product"
let CustomerStoryBoard = "Customer"
let LicenceStoryBoard = "Licence"
let SearchAndShareStoryBoard = "SearchAndShare"
var isDataBaseAvailable:Bool = false
let kLong = "long"
let kSideMenuNotification = "SideMenuNotification"
let kHomeNotification = "HomeNotification"
let kprofileImage = "profileImage"
let kContactNumber = "contactNumber"
let kDiscount = "discount"
let kToken = "token"
let kAppName = "PWBC"
let kUserId = "userId"
let kUserName = "userName"
let kGender = "gender"
let kEmail = "email"
let kAddress = "busniessAddress"
let kGSTINNumber = "gstinNumber"
let kBusinessName = "businessName"
let kPassword = "password"
let kBusinessType = "businessType"
let kGSTPercentage = "gstCharge"
let kFirstName = "firstName"
let kName = "name"
let kBirthDay = "birthday"
let kEthnicity = "ethnicity"
let kdevicetype = "I"
let ktype = "type"
let kLogin = "login"
let kDeviceToken = "deviceToken"
let kProductDataBase = "ProductDataBase"
let kPersistanceStorageName = "ProductWithBillCalculator"
let kTablet = "Tablet"
let kPaiedStatus = "Paied"
let kBorrowStatus = "Borrow"
let kAdvanceStatus = "Advance"
let kBilledStatus = "Billed"
let kBillId = "billId"
let kPaiedDate = "paiedDate"
let kSelectedLanguage = "selectedLanguage"
let kSelectedLocal = "SelectedLocal"
var strSelectedLanguage:String = "English"
var strSelectedLocal:String = "en"
var strType:String = ""
var userId:String = "1"
//var personId:String = "2"
var phoneNumber:String = ""
var emailId:String = ""
var cornderRadious:CGFloat = 40.0
var dateCorenerRadious:CGFloat = 10.0
var isPackageSelected:Bool = false
var strSelectedTypeFelt:String = ""//"Angry"
var strSelectedFeeling:String = ""//"Blamed"
var dateSelected:Date?
var isInternalUpdateOfView:Bool = false
var searchPersonName:String = ""
var searchType:String = ""
var strBusinessType:String = ""
var feltid:String = ""
var feelingid:String = ""
var ksimulator = "Simulator"
var historySelectedDate = Date()
var deviceID:String = UIDevice.current.identifierForVendor!.uuidString
var kSelectOption = "please select one option"
var kPleaseAddMember = "please add member from home screen"
var kOptionalDateSelectrion = "please select Date"
var kItemAdded = "You have added Item"
var kother = "other"
var kCustomer = "customer"
var kUpiId = "UpiId"
var kCompanyName = "CompanyName"
var kLogo = "logo"
var kQRCode = "qrCode"
var kTheamColor = "theamColor"
var kSpeach = "speach"
var kSpeakSpeech = "SpeakSpeech"
var kNotificationSend = "notificationSend"
var kDate = "Date"
var kMobileDigitAlert = "Mobile number is not more then 12 Digit."
var kGSTINAleart = "GSTIN number is not more then 15 Digit."
var kFetureAlert = "You can't be select feture date"
var kAddIteamAlert = "Please add Item first"
var kItemCalculate = "Iteam Calculated SuccessFully"
var kDataSaveSuccess = "Data save sucessfully"
var kDataUpdate = "Data update successfully"
var kDatafailedToSave = "Issue in save in database please check again"
var kFetchDataissue = "data can't be find please try again"
var kDeleteData = "Data deleted successfully"
var kSelectCustomerData = "please select customer"
var kDeleteMessage = "Are you sure you want to delete?"
//MARK:- TypeDefine Declaration
typealias TASelectedIndex = (Int) -> Void
typealias TaSelectedValueSuccess = (String) -> Void
typealias TaSelectedLocalNotification = (String,String) -> Void
typealias ImagePass = (UIImage) -> Void
typealias taSelctedTypeOFBusiness = ([BusinessType]) -> Void
typealias updateDataWhenBackClosure = () -> Void
typealias updateAddedItem = (Items,Int) -> Void
typealias updateSearchCustomer = (CustomerList) -> Void
//MARK:- Constant API URL
let getTermsandconditions = "get_Terms_and_conditions"
var strTheamColor = "#FFA500"
var arrMemberList = [[String:Any]]()
var isFromDelete:Bool = false
var isSpeackSpeechOn:Bool = false
//let userInfo = "Users"

//MARK:- Constant Struct
typealias reloadTableViewClosure = () -> Void
struct AppMessage {
    var internetIssue:String = "Please check the internet connection"
}
struct CustomFontName {
    var textfieldFontName:String = "helvetica-neue-regular"
    var buttonFontName:String = "helvetica-neue-regular"
    var labelFontName:String = "helvetica-neue-regular"
    var boldHelvetica:String = "HelveticaNeue-Bold"
}
struct CustomFontSize {
    var textfieldFontSize:CGFloat = 28.0 * (screenWidth/320.0)
    var buttonFontSize:CGFloat = 15.0 * (screenWidth/320.0)
    var splaceScreenFontSize:CGFloat = 12.0 * (screenWidth/320.0)
    var labelFontSize:CGFloat = 15.0 * (screenWidth/320)
    var titleFontSize:CGFloat = 16.0 * (screenWidth/320.0)
    var pickerTitleLableSize:CGFloat = 23.0 * (screenWidth/320.0)
    var pickertextFieldSize:CGFloat = 20.0 * (screenWidth/320.0)
}
struct CustomColor {
    //HeaderColor4FB2B4
    var gradeintTopBackGround = "#0074E8"//"#00A9C3"
    var mainBackground = "#FF0000"//"#8BD1C9"//"#377F7F"//"#4FB2B4"//"#70CDCD"
    var textFontColor = "#4FB2B4"
    var pickerFontColor = "#4FB2B4"
    var labelSepratorColor = "#FFFFFF"
    var buttonBackGround = "#377F7F" //"#17B5B7"
    var blueColor = "#0074E8"
    var mainLightBackGround = "#84CACB"
    var journalBackGround = "#D1ECE9"
//"#00aac5"
    var gradeintBottomBackGround = "#0089C0"//"#00aac5"
}
public enum RainbowColor {
    case main,red,orange,green,blue,indigo,violet
    func selectedColor() -> String {
        switch self {
        case .main:
            return "#8BD1C9"
        case .red:
              return "#FF0000"
        case .orange:
              return "#FFA500"
        case .green:
              return "#008000"
        case .blue:
              return "#0000FF"
        case .indigo:
              return "#4B0082"
        case .violet:
              return "#EE82EE"
        default:
            return "#8BD1C9"
        }
    }
}

public enum QuantityTypeUnits {
    case unit,gm,kg,lt,ml,box,tablet,bottal,size,piece,cup,can,pkg
    func selectedUnit() -> Double {
        switch self {
        case .unit:
            return 1.0
        case .gm:
            return 100.0
        case .kg:
            return 1000.0
        case .lt:
            return 1000.0
        case .ml:
            return 100.0
        case .box:
            return 1.0
        case .tablet:
            return 1.0
        case .bottal:
            return 1.0
        case .size:
            return 1.0
        case .piece:
            return 1.0
        case .cup:
            return 1.0
        case .can:
            return 1.0
        case .pkg:
            return 1.0
        }
    }
}
struct AppAlertMessage {
    var oldPassword = "Please provide old password"
    var newPassword = "Please provide new password"
    var confirmPassword = "Please provide confirm password"
    var passwordNotMatch = "password does not match"
    var passwordChageSuccess = "password change successfully"
    var accountMessage = "Your account has been deactivated.please contact to app admin"
}
struct Alert {
    func showAlert(message:String,viewController:UIViewController) {
        let alert = UIAlertController(title:kAppName, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}

func setCommanHeaderView(width:CGFloat) -> CommanView {
    let headerViewXib:CommanView = CommanView().instanceFromNib()
    headerViewXib.frame = CGRect(x: 0, y: 0, width: width, height: (screenHeight * 0.1))
    return headerViewXib
}
func getCurrentTimeAndDate() -> (Int,Int) {
    let date = Date()
    let calendar = Calendar.current
    let hour = calendar.component(. hour, from: date)
    let minutes = calendar.component(. minute, from: date)
    return(hour,minutes)
}

func convertDateWithTime(date:String,hour:Int,minutes:Int) -> Date  {
    var dateComponents = DateComponents()
    let arrdevidedString:[String] = date.components(separatedBy: "/")
    dateComponents.year = Int(arrdevidedString[2])
    dateComponents.month = Int(arrdevidedString[1])
    dateComponents.day = Int(arrdevidedString[0])
    dateComponents.timeZone = TimeZone(abbreviation: "UTC") // Japan Standard Time
    var hours:Int = hour
    var minute:Int = minutes
    if hour == nil || hour == 0 {
     let dateAndTime = getCurrentTimeAndDate()
        hours = dateAndTime.0
        minute = dateAndTime.1
    }
    dateComponents.hour = hours
    dateComponents.minute = minute
    let userCalendar = Calendar.current // user calendar
    let someDateTime = userCalendar.date(from: dateComponents)
    return someDateTime!
}

