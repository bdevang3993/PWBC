//
//  LicenceModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 08/09/21.
//

import Foundation

struct LicenceList {
    var licenceid: Int = -1
    var licenceName: String = ""
    var licenceNumber: String = ""
    var paymentDate: String = ""
    var registerDate: String = ""
    var lastDate: String = ""
    var price:String = "0.0"
    var licenceImage: Data?
    var daysRemaining:Int = 10000
}
