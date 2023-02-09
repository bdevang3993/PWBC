//
//  SideMenuModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit
enum SideMenuTitle {
    case home,item,customer,organization,licence,account,bill,order,payerQR,privacy,terms,apple,setting,event,profile,password,restore,delete,speak
        func selectedString() -> String {
            switch self {
            case .home:
                return "Home".localized().lowercased()
            case .item:
                return "Item".localized().lowercased()
            case .customer:
                return "Customer".localized().lowercased()
            case .organization:
                return "Organization".localized().lowercased()
            case .licence:
                return "License".localized().lowercased()
            case .account:
                return "Account".localized().lowercased()
            case .bill:
                return "Bill".localized().lowercased()
            case .order:
                return "Order".localized().lowercased()
            case .payerQR:
                return "Quick".localized().lowercased()//"PayerQR".localized().lowercased()
            case .privacy:
                return "Privacy".localized().lowercased()
            case .terms:
                return "Terms".localized().lowercased()
            case .apple:
                return "Apple".localized().lowercased()
            case .setting:
                return "Setting".localized().lowercased()
            case .event:
                return "Event".localized().lowercased()
            case .profile:
                return "Profile".localized().lowercased()
            case .password:
                return "Password".localized().lowercased()
            case .restore:
                return "Restore".localized().lowercased()
            case .delete:
                return "Delete".localized().lowercased()
            case .speak:
                return "Speak".localized()
            default:
                return "Home".localized().lowercased()
            }
        }
}
enum OpenMenuTitle {
    case addProduct,addItem,addCustomer,addLicence,addOrderDetail,addPayerQR,subScription
    func selectedString() -> String {
        switch self {
        case .addProduct:
            return "Product".localized().lowercased()
        case .addItem:
            return "Item".localized().lowercased()
        case .addCustomer:
            return "Customer".localized().lowercased()
        case .addLicence:
            return "License".localized().lowercased()
        case .addOrderDetail:
            return "Order".localized().lowercased()
        case .addPayerQR:
            return "QR".localized().lowercased()
        case .subScription:
            return "SubScription".localized().lowercased()
        default:
            return "Product".localized().lowercased()
        }
    }
}
