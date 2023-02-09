//
//  BillDisplayModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 22/09/21.
//

import Foundation
enum BillFooterTitle {
    case amount,gstTax,totalAmount,discount,paybleAmount
    func selectedString() -> String {
        switch self {
        case .amount:
            return "Amount"
        case .gstTax:
            return "GST" + " " + "Tax"
        case .totalAmount:
            return "Total" + " " + "Amount"
        case .discount:
            return "Discount"
        case .paybleAmount:
            return "Payable" + " " + "Amount"
         default:
            return "Amount"
        }
    }
}
struct BillList {
    var billId: Double = 0.0
    var isPaied: Bool = false
    var billImage: Data = Data()
    var customerName: String = ""
    var customerNumber: String = ""
    var date: String = ""
    var amount: Double = 0.0
    var billNumber:String = ""
}
