//
//  AllCustomMethods.swift
//  FugitCustomer
//
//  Created by addis on 09/02/20.
//  Copyright © 2020 addis. All rights reserved.
//

import Foundation
import UIKit
//import CoreData
import Floaty

//MARK:- Custom TextField Method
func setCustomTextField(self:UITextField,placeHolder:String,isBorder:Bool) -> UITextField {
    let newTextField:UITextField = self
    var multiplier:Double = 1.0
   
    if UIDevice.current.userInterfaceIdiom == .pad {
        multiplier = 10.0
    }
//    let value:CGFloat = CustomFontSize().textfieldFontSize / CGFloat(multiplier)
//    let data = "\(value)".split(separator: ".")
//     let newvalue = Int(data[0])
    let value:CGFloat = self.font!.pointSize + CGFloat(multiplier)
    let data = "\(value)".split(separator: ".")
     let newvalue = Int(data[0])
    newTextField.font = UIFont.systemFont(ofSize: CGFloat(newvalue!))//UIFont(name: CustomFontName().textfieldFontName, size: CGFloat(newvalue!))
    newTextField.textColor = UIColor.white
    newTextField.tintColor = UIColor.white
    if isBorder {
        newTextField.layer.borderColor =  hexStringToUIColor(hex:strTheamColor).cgColor
        newTextField.layer.borderWidth = 1.0
        newTextField.layer.cornerRadius = 10.0//
        newTextField.setLeftPaddingPoints(10.0)
        newTextField.setRightPaddingPoints(10.0)
    }
    newTextField.attributedPlaceholder = NSAttributedString(string: placeHolder,
    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    return newTextField
}
func setCustomSignUpTextField(self:UITextField,placeHolder:String,isBorder:Bool) -> UITextField {
    let newTextField:UITextField = self
    var multiplier:Double = 1.0
    if UIDevice.current.userInterfaceIdiom == .pad {
        multiplier = 10.0
    }
    let value:CGFloat = self.font!.pointSize + CGFloat(multiplier)
    let data = "\(value)".split(separator: ".")
     let newvalue = Int(data[0])
    newTextField.font = UIFont.systemFont(ofSize: CGFloat(newvalue!))
    
    newTextField.textColor = hexStringToUIColor(hex:strTheamColor)
    newTextField.tintColor = hexStringToUIColor(hex:strTheamColor)
    if isBorder {
        newTextField.layer.borderColor =  hexStringToUIColor(hex: strTheamColor).cgColor
        newTextField.layer.borderWidth = 1.0
        newTextField.layer.cornerRadius = 10.0
        newTextField.setLeftPaddingPoints(10.0)
        newTextField.setRightPaddingPoints(10.0)
    }
    newTextField.attributedPlaceholder = NSAttributedString(string: placeHolder,
                                                    attributes: [NSAttributedString.Key.foregroundColor:UIColor.lightGray])
    return newTextField
}

func setupIpadItem(floaty:Floaty) {
    if UIDevice.current.userInterfaceIdiom == .pad {
        floaty.size = 76
        floaty.itemSize  = 62
        floaty.itemSpace = 34
    }
}

//MARK:- EmailValidation
func isValidEmail(emailStr:String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailPred.evaluate(with: emailStr)
}
//MARK:- Remove Space before and after line
func removeWhiteSpace(strData:String) -> String {
    let trimmed:String = strData.trimmingCharacters(in: .whitespacesAndNewlines)
    return trimmed//trimmed.lowercased()
}
//MARK:- Convert HexColor To UIColor
func hexStringToUIColor(hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return UIColor.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)

    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
//MARK:- Save Images Locally
func saveImage(image: UIImage) -> (Bool,Data) {
    let emptyData = Data()
       guard let data = image.jpegData(compressionQuality: 1) ?? image.pngData() else {
           return (false,emptyData)
       }
       guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
           return (false,data)
       }
       do {
           try data.write(to: directory.appendingPathComponent("\(kprofileImage).png")!)
           return (true,data)
       } catch {
           return (false,data)
       }
   }
func getSavedImage(named: String) -> UIImage? {
    if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
    }
    return nil
}
func convertInAttributedString(strData:String,color:UIColor) -> NSAttributedString {
    // Custom color
  //  let greenColor = UIColor(red: 10/255, green: 190/255, blue: 50/255, alpha: 1)
    // create the attributed colour
    let attributedStringColor = [NSAttributedString.Key.foregroundColor : color]
    // create the attributed string
    let attributedString = NSAttributedString(string: strData, attributes: attributedStringColor)
    // Set the label
    return attributedString
}
func convertdateFromDate(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
    formatter.setLocalizedDateFormatFromTemplate("MM/dd/yyyy hh:mm a")
    //formatter.dateFormat = "MM/dd/yyyy hh:mm a"
    return formatter.string(from: date)
}
func converttimeFromDate(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
    formatter.setLocalizedDateFormatFromTemplate("hh:mm a")
   // formatter.dateFormat = "hh:mm a"
    return formatter.string(from: date)
}
func convertMonthAndYearFromDate(date:Date) -> String {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
    formatter.setLocalizedDateFormatFromTemplate("MM/yyyy")
    //formatter.dateFormat = "MM/yyyy"
    return formatter.string(from: date)
}
func converFunction(date:Date) -> String? {
    let formatter = DateFormatter()
    formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
    formatter.setLocalizedDateFormatFromTemplate("yyyy,EEEE, MMM d")
    let timeZone = NSTimeZone()
    formatter.timeZone = timeZone as TimeZone
    var strSelectedDate:String = ""
    strSelectedDate = formatter.string(from: date)
    strSelectedDate = strSelectedDate + ("th")
    return strSelectedDate
}
func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}

func setAlertWithCustomAction(viewController:UIViewController,message:String,ok okBlock: @escaping ((Bool) -> Void),isCancel:Bool,cancel cancelBlock: @escaping ((Bool) -> Void)) {
    let alertController = UIAlertController(title: kAppName, message:message, preferredStyle: .alert)
    // Create the actions
    let okAction = UIAlertAction(title: "OK".localized(), style: UIAlertAction.Style.default) {
        UIAlertAction in
        okBlock(true)
    }
    alertController.addAction(okAction)
    if isCancel {
        let cancelAction = UIAlertAction(title: "Cancel".localized(), style: UIAlertAction.Style.default) {
            UIAlertAction in
            cancelBlock(true)
        }
        alertController.addAction(cancelAction)
    }
    viewController.present(alertController, animated: true, completion: nil)
}
func validatePhoneNumber(value: String) -> Bool {
    let PHONE_REGEX = "^[0-9]{10}$" //((\\+)|(00))
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
    let result =  phoneTest.evaluate(with: value)
    return result
}

func checkForNextDate(selectedDate:Date) -> Int  {
    let dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
          formatter.dateFormat = "dd/MM/yyyy"//"yyyy/MM/dd"
          return formatter
      }()
    let date = Date()
    let newDate = dateFormatter.string(from: date)
    let curentDate:Date = dateFormatter.date(from: newDate)!
    if selectedDate != nil {
        let newDate = dateFormatter.string(from: selectedDate )
        let convertSavedDate:Date = dateFormatter.date(from: newDate)!
        let diffInDays:Int = Calendar.current.dateComponents([.day], from: convertSavedDate, to:curentDate).day!
        return diffInDays
    }
    return 0
}
func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
    let shapeLayer = CAShapeLayer()
    shapeLayer.strokeColor = UIColor.lightGray.cgColor
    shapeLayer.lineWidth = 1
    shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

    let path = CGMutablePath()
    path.addLines(between: [p0, p1])
    shapeLayer.path = path
    view.layer.addSublayer(shapeLayer)
}
//func backupDatabase(backupName: String){
//    let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
//    let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
//    let container = NSPersistentContainer(name: kPersistanceStorageName)
//    container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
//
//    let store:NSPersistentStore
//    store = container.persistentStoreCoordinator.persistentStores.last!
//    do {
//        try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
//    } catch {
//    }
//}
