//
//  TheamPickerModel.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 11/01/22.
//

import Foundation

enum TheamPickerTitle {
    case sky,red,orange,green,blue,indigo,violate
    func selectedString() -> String {
        switch self {
        case .sky:
            return "Sky".localized()
        case .red:
            return "Red".localized()
        case .orange:
            return "Orange".localized()
        case .green:
            return "Green".localized()
        case .blue:
            return "Blue".localized()
        case .indigo:
            return "Indigo".localized()
        case .violate:
            return "Violet".localized()
        default:
            return "Violet".localized()
        }
    }
}
