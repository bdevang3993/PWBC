//
//  BusinessDetails+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 02/09/21.
//
//

import Foundation
import CoreData


extension BusinessDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessDetails> {
        return NSFetchRequest<BusinessDetails>(entityName: "BusinessDetails")
    }

    @NSManaged public var businessName: String?
    @NSManaged public var gstInNumber: String?
    @NSManaged public var businessType: String?
    @NSManaged public var contactNumber: String?
    @NSManaged public var emailId: String?
    @NSManaged public var password: String?
    @NSManaged public var gstCharge: String?

}
