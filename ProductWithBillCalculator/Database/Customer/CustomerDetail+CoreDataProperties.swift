//
//  CustomerDetail+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 06/09/21.
//
//

import Foundation
import CoreData


extension CustomerDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CustomerDetail> {
        return NSFetchRequest<CustomerDetail>(entityName: "CustomerDetail")
    }
    @NSManaged public var customerId:Int64
    @NSManaged public var customerName: String?
    @NSManaged public var emailId: String?
    @NSManaged public var mobileNumber: String?
    
}
