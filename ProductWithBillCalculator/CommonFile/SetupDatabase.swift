//
//  SetupDatabase.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 15/11/21.
//

import Foundation
final class SetUpDatabase: NSObject {
   static var objShared = SetUpDatabase()
    var objBusinessDatabaseQuerySetUp = BusinessDatabaseQuerySetUp()
    var objProductQuery = ProductQuery()
    var objCustomerQuery = CustomerQuery()
    var objLicenceDetailsQuery = LicenceDetailsQuery()
    var objOrderDetailsQuery = OrderDetailsQuery()
    var objPayerDetailsQuery = PayerDetailsQuery()
    var objProductDetailsQuery = ProductDetailsQuery()
    
    private override init() {
    }
    func fetchAllData(save success:@escaping((Bool) -> Void)){
        if let path = Bundle.main.path(forResource: "UserDetail", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:Any]//mutableLeaves
                let arrBusinessDetails = jsonObj["BusinessDetails"] as! [Any]
                let dicData = arrBusinessDetails[0] as! [String:Any]
                objBusinessDatabaseQuerySetUp.saveinDataBase(businessName: dicData["businessName"] as! String, gstInNumber: "", businessType: dicData["businessType"] as! String, contactNumber: "", emailId: dicData["email"] as! String, password: dicData["password"] as! String, gstCharge: "0", busniessAddress: "Nadiad")
                
                let userdefault = UserDefaults.standard
                userdefault.setValue("0", forKey: kGSTPercentage)
                userdefault.setValue(dicData["businessName"] as! String, forKey: kBusinessName)
                userdefault.setValue(dicData["businessType"] as! String, forKey: kBusinessType)
                userdefault.setValue("Nadiad", forKey: kAddress)
                userdefault.synchronize()
                let arrProduct = jsonObj["Product"] as! [Any]
                for product in arrProduct {
                    let data = product as! [String:Any]
                    objProductQuery.saveinDataBase(productId: data["productId"] as! Int, iteamName: data["iteamName"] as! String, price: data["price"] as! Double, qauntityPerUnit: data["quantityPerUnit"] as! Double, qauntityType: data["quantityType"] as! String, qauntity:0.0, numberOfPice: 1)
                }
                
                let arrCustomerDetail = jsonObj["CustomerDetail"] as! [Any]
                for customer in arrCustomerDetail {
                    let data = customer as! [String:Any]
                    objCustomerQuery.saveinDataBase(customerId: data["customerId"] as! Int, customerName: data["customerName"] as! String, emailId: data["emailId"] as! String, mobileNumber: data["mobileNumber"] as! String)
                }
                
                let arrLicenceDetail = jsonObj["LicenceDetail"] as! [Any]
                for licence in arrLicenceDetail {
                    let  data = licence as! [String:Any]
                   objLicenceDetailsQuery.saveinDataBase(licenceid: data["licenceid"] as! Int, licenceName: data["licenceName"] as! String, licenceNumber: data["licenceNumber"] as! String, registerDate: data["registerDate"] as! String, paymentDate: data["paymentDate"] as! String, lastDate: data["lastDate"] as! String, licenceImage: Data(), price: data["price"] as! String)
                }
                let arrOrderDetail = jsonObj["OrderDetail"] as! [Any]
                for orderDetail in arrOrderDetail {
                    let  data = orderDetail as! [String:Any]
                    objOrderDetailsQuery.saveinDataBase(productDetailId: data["productDetailId"] as! Int, date: data["date"] as! String, time: data["time"] as! String, advance: data["advance"] as! Double, remains: data["remains"] as! Double, pickupNumber: data["pickupNumber"] as! String, customerNumber: data["customerNumber"] as! String)
                }
                let arrPayerDetails = jsonObj["PayerDetails"] as! [Any]
                let dicDataPayer = arrPayerDetails[0] as! [String:Any]
                objPayerDetailsQuery.saveinDataBase(id: dicDataPayer["id"] as! Int, strName: dicDataPayer["name"] as! String, strURL: dicDataPayer["strUrl"] as! String)
                
                let arrProductDetailData = jsonObj["ProductDetailsData"] as! [Any]
                let dicrProductDetailData = arrProductDetailData[0] as! [String:Any]
                objProductDetailsQuery.saveinDataBase(productDetailId: dicrProductDetailData["productDetailId"] as! Int, customerId: dicrProductDetailData["customerId"] as! Int, productId: dicrProductDetailData["productId"] as! Int, customerName: dicrProductDetailData["customerName"] as! String, date: dicrProductDetailData["paiedDate"] as! String, iteamName: dicrProductDetailData["customerName"] as! String, paiedDate: dicrProductDetailData["paiedDate"] as! String, price: dicrProductDetailData["price"] as! Double, quantity: String(dicrProductDetailData["quantity"] as! Double), status: dicrProductDetailData["status"] as! String, numberOfPice: 1)
                success(true)
            }
            catch {
                print("parse error: \(error.localizedDescription)")
                success(false)
            }
        }
    }
}
