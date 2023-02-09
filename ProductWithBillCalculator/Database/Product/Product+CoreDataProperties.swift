//
//  Product+CoreDataProperties.swift
//  
//
//  Created by devang bhavsar on 02/09/21.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }
    @NSManaged public var productId: Int64
    @NSManaged public var iteamName: String?
    @NSManaged public var qauntityPerUnit: Double
    @NSManaged public var qauntity: Double
    @NSManaged public var numberOfPice: Int64
    @NSManaged public var qauntityType: String?
    @NSManaged public var price: Double
    
}
