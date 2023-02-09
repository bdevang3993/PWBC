//
//  OrderDetail+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 30/09/21.
//
//

import Foundation
import CoreData


extension OrderDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<OrderDetail> {
        return NSFetchRequest<OrderDetail>(entityName: "OrderDetail")
    }
    
    @NSManaged public var productDetailId: Int64
    @NSManaged public var date: String?
    @NSManaged public var time: String?
    @NSManaged public var advance: Double
    @NSManaged public var remains: Double
    @NSManaged public var pickupNumber: String?
    @NSManaged public var customerNumber: String?
}
