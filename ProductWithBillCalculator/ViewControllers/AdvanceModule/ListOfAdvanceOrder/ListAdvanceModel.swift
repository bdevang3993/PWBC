//
//  ListAdvanceModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 30/09/21.
//

import Foundation

struct AdvanceAllData {
    var productDetailId: Int = 0
    var date: String = ""
    var time: String = ""
    var advance: Double = 0.0
    var remains: Double = 0.0
    var pickupNumber: String = ""
    var customerId:Int = -1
    var productId:Int = -1
    var customerName:String = ""
    var customerNumber:String = ""
    var iteamName: String = ""
    var paiedDate: String = ""
    var price: Double = 0.0
    var quantity: String = ""
    var status:String = kBorrowStatus
    var billNumber:String = ""
}
