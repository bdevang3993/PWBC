//
//  LoginModel.swift
//  Economy
//
//  Created by devang bhavsar on 07/01/21.
//

import UIKit

enum LoginTitle {
    case emailTitle,password
    func selectedString() -> String {
        switch self {
        case .emailTitle:
            return "Email id/Mobile Number".localized()
        case .password:
            return "Password".localized()
        default:
            return "Email id/Mobile Number".localized()
        }
    }
}
