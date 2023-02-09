//
//  LicenceDetail+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 08/09/21.
//
//

import Foundation
import CoreData


extension LicenceDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LicenceDetail> {
        return NSFetchRequest<LicenceDetail>(entityName: "LicenceDetail")
    }
    @NSManaged public var lastDate: String?
    @NSManaged public var licenceid: Int64
    @NSManaged public var licenceImage: Data?
    @NSManaged public var licenceName: String?
    @NSManaged public var licenceNumber: String?
    @NSManaged public var paymentDate: String?
    @NSManaged public var registerDate: String?
    @NSManaged public var price:String?
}
