//
//  Commons.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

open class Commons: NSObject {
    
    static func selectedDevice() -> String {
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 480:
                return "iPhoneClassic"
            case 960:
                return "iPhone4Sizes"
            case 1136:
                return "iPhone5Sizes"
            case 1334:
                return "iPhone6Sizes"
            case 2208:
                return "iPhone6PlusSizes"
            default:
                return "Unknown"
            }
        }
        else{
            return "iPadSizes"
        }
    }
}
