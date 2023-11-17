//
//  TravioColor.swift
//  TravioProject
//
//  Created by Burak Özer on 16.11.2023.
//

import Foundation

import UIKit

enum ThemeColor {
    case viewColor
    case fontColor
    case mainColor
    case textButtonColor

    var uiColor: UIColor {
        switch self {
        case .viewColor:
            return UIColor(hexString: "#F8F8F8")
        case .fontColor:
            return UIColor(hexString: "#3d3d3d")
        case .mainColor:
            return UIColor(hexString: "#38ada9")
        case .textButtonColor:
            return UIColor(hexString: "#17C0EB")
        }
    }
}


