//
//  AddProduct.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 31/08/21.
//

import Foundation

struct ItemList {
    var strTitle:String
    var strDescription:String
    var isPicker:Bool = false
    var isEditable:Bool = false
}

enum ItemDisplayTItle {
    case itemName,typeOfBusiness,quantityPerUnit,quantityType,itemPrice,totalPrice,quantity,quality
    func strSelectedTitle() -> String  {
        switch self {
        case .itemName:
            return "Iteam".localized() + " " + "Name".localized()
        case .typeOfBusiness:
            return "Type".localized() + " " + "of".localized() + " " + "Business".localized()
        case .quantityPerUnit:
            return "Quantity".localized() + " " + "Per".localized() + " " + "Unit".localized()
        case .quantity:
            return "Quantity".localized()
        case .quantityType:
            return "Quantity".localized() + " " + "Type".localized()
        case .itemPrice:
            return "Iteam".localized() + " " + "Price".localized() + " " + "Per".localized() + " " + "Unit".localized()
        case .totalPrice:
            return "Price".localized()//"Total Price".localized()
        case .quality:
            return "Quality".localized()
        default:
            return "Iteam".localized() + " " + "Name".localized()
        }
    }
}
enum AdvanceTitle  {
    case date,time,advance,remains,customerName,customerNumber,pickUpPersonNumber
    func strSelectedTitle() -> String {
        switch self {
        case .date:
            return "Date".localized()
        case .time:
            return "Time".localized()
        case .advance:
            return "Advance".localized()
        case .remains:
            return "Remains".localized()
        case .customerName:
            return "Customer".localized() + "Name".localized()
        case .customerNumber:
            return "Customer".localized() + "Number".localized()
        case .pickUpPersonNumber:
            return "PickUp".localized() + "Person".localized() + "Number".localized()
        default:
            return "Date".localized()
        }
    }
}
