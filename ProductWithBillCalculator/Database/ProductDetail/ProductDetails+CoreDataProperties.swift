//
//  ProductDetails+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 07/09/21.
//
//

import Foundation
import CoreData


extension ProductDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductDetails> {
        return NSFetchRequest<ProductDetails>(entityName: "ProductDetails")
    }

    @NSManaged public var customerId: Int64
    @NSManaged public var customerName: String?
    @NSManaged public var date: String?
    @NSManaged public var iteamName: String?
    @NSManaged public var paiedDate: String?
    @NSManaged public var price: Double
    @NSManaged public var productDetailId: Int64
    @NSManaged public var quantity: String
    @NSManaged public var productId: Int64
    @NSManaged public var status: String?
    @NSManaged public var billNumber: String?
    @NSManaged public var numberOfPice: Int64
}
