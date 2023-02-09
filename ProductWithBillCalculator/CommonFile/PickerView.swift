//
//  PickerView.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 26/02/21.
//

import UIKit
import SBPickerSelector

final class PickerView: NSObject {

   static var objShared = PickerView()
    private override init() {
        
    }
    func setUpDatePickerWithDate(viewController:UIViewController,selectedValue:@escaping (Date) -> Void) {
        let date = Date()
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear, endDate: date).cancel {
            print("cancel, will be autodismissed")
        }.set { values in
            if let values = values as? [Date] {
                selectedValue(values[0])
                //self.txtBirthDay.text = values[0]
            }
        }.present(into: viewController)
    }
    
    func setUpDatePickerWithMonthAndYear(viewController:UIViewController,selectedValue:@escaping (Date) -> Void) {
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateMonthYear).cancel {
            print("cancel, will be autodismissed")
        }.set { values in
            if let values = values as? [Date] {
                selectedValue(values[0])
                //self.txtBirthDay.text = values[0]
            }
        }.present(into: viewController)
    }
    
    func setUpDatePickerWithoutEndDate(viewController:UIViewController,selectedValue:@escaping (Date) -> Void) {
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.dateDayMonthYear).cancel {
            print("cancel, will be autodismissed")
        }.set { values in
            if let values = values as? [Date] {
                selectedValue(values[0])
                //self.txtBirthDay.text = values[0]
            }
        }.present(into: viewController)
    }
    func setUPickerWithValue<T>(arrData:[T],viewController:UIViewController,selectedValue:@escaping (T) -> Void) {
        SBPickerSwiftSelector(mode: SBPickerSwiftSelector.Mode.text, data: arrData).cancel {
                   print("cancel, will be autodismissed")
                   }.set { values in
                       //if let values = values as? [String] {
                           //self.objExpenseViewModel.arrDescription[2] = values[0]
                           let value = values[0]
                        selectedValue(value as! T)
                      // }
               }.present(into: viewController)
    }
    
   
}
