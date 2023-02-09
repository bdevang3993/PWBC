//
//  getAllEventList.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 24/08/21.
//

import Foundation
final class GetAllEventList:NSObject {
    lazy var dateFormatter: DateFormatter = {
          let formatter = DateFormatter()
//        formatter.locale = NSLocale(localeIdentifier: strSelectedLocal) as Locale
//        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy")
        formatter.dateFormat = "dd/MM/yyyy"
          return formatter
      }()
    static var shared = GetAllEventList()
    var objLicence = LicenceDetailsQuery()
    var objOrderDetails = OrderDetailsQuery()
    var arrOrderDetails = [AdvanceDetail]()
    var checkForDays:Int = 20
    var arrLicenceList = [LicenceList]()
    func fetchAllEvent(eventData: @escaping ([LicenceList]) -> Void) {
        arrLicenceList.removeAll()
        let date = Date()
        let newDate = dateFormatter.string(from: date)
        let curentDate:Date = dateFormatter.date(from: newDate)!
        self.objLicence.fetchAllData { (result) in
            for value in result {
                let strDate = value.lastDate
                let checkForDate = self.dateFormatter.date(from: strDate)
                let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to: checkForDate!).day!
                if diffInDays < self.checkForDays && diffInDays > 0 {
                    var selectedValue:LicenceList = value
                    selectedValue.daysRemaining = diffInDays
                    self.arrLicenceList.append(selectedValue)
                }
            }
            eventData(self.arrLicenceList)
        } failure: { (isFailed) in
            eventData(self.arrLicenceList)
        }
    }
    
    func fetchOrderEvent(eventDetails:@escaping ([AdvanceDetail]) -> Void) {
        arrOrderDetails.removeAll()
        let date = Date()
        let newDate = dateFormatter.string(from: date)
        let curentDate:Date = dateFormatter.date(from: newDate)!
        self.objOrderDetails.fetchAllData { (result) in
            for value in result {
                let strDate = value.date
                let checkForDate = self.dateFormatter.date(from: strDate)
                let diffInDays:Int = Calendar.current.dateComponents([.day], from: curentDate, to: checkForDate!).day!
                if diffInDays < self.checkForDays && diffInDays > 0 {
                    self.arrOrderDetails.append(value)
                }
            }
            eventDetails(self.arrOrderDetails)
        } failure: { (isFailed) in
            eventDetails(self.arrOrderDetails)
        }

    }
}
