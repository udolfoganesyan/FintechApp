//
//  Theme.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 04.10.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import UIKit

enum Theme: Int {
    
    case classic
    case day
    case night
    
    var backgroundColor: UIColor {
        switch self {
        case .classic:
            return .groupTableViewBackground
        case .day:
            return .white
        case .night :
            return .black
        }
    }
    
    var primaryTextColor: UIColor {
        switch self {
        case .night:
            return .white
        default:
            return .black
        }
    }
    
    var secondaryTextColor: UIColor {
        switch self {
        case .night:
            return UIColor(red: 0.553, green: 0.553, blue: 0.576, alpha: 1)
        default:
            return UIColor(red: 0.235, green: 0.235, blue: 0.263, alpha: 0.6)
        }
    }
    
    var incomingCellColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.875, green: 0.875, blue: 0.875, alpha: 1)
        case .day:
            return UIColor(red: 0.918, green: 0.922, blue: 0.929, alpha: 1)
        case .night:
            return UIColor(red: 0.18, green: 0.18, blue: 0.18, alpha: 1)
        }
    }
    
    var outgoingCellColor: UIColor {
        switch self {
        case .classic:
            return UIColor(red: 0.863, green: 0.969, blue: 0.773, alpha: 1)
        case .day:
            return UIColor(red: 0.263, green: 0.537, blue: 0.976, alpha: 1)
        case .night:
            return UIColor(red: 0.361, green: 0.361, blue: 0.361, alpha: 1)
        }
    }
    
    var incomingCellTextColor: UIColor {
        switch self {
        case .night:
            return .white
        default:
            return .black
        }
    }
    
    var outgoingCellTextColor: UIColor {
        switch self {
        case .classic:
            return .black
        default:
            return .white
        }
    }
    
    var buttonBackgroundColor: UIColor {
        switch self {
        case .night:
            return UIColor(red: 0.106, green: 0.106, blue: 0.106, alpha: 1)
        default:
            return UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        }
    }
    
    var barStyle: UIBarStyle {
        switch self {
        case .night:
            return .black
        default:
            return .default
        }
    }
}
