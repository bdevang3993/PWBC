//
//  PayerDetails+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 16/10/21.
//
//

import Foundation
import CoreData


extension PayerDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PayerDetails> {
        return NSFetchRequest<PayerDetails>(entityName: "PayerDetails")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var strUrl: String?

}
