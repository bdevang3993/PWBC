//
//  BillDescription+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 22/09/21.
//
//

import Foundation
import CoreData


extension BillDescription {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BillDescription> {
        return NSFetchRequest<BillDescription>(entityName: "BillDescription")
    }

    @NSManaged public var billId: Double
    @NSManaged public var isPaied: Bool
    @NSManaged public var billImage: Data?
    @NSManaged public var customerName: String?
    @NSManaged public var customerNumber: String?
    @NSManaged public var date: String?
    @NSManaged public var amount: Double
    @NSManaged public var billNumber: String?
    

}
