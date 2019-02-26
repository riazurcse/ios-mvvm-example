//
//  Devices.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import Foundation
import UIKit

extension UIDevice {
    
    public class var isiPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    
    public class var isiPadPro129: Bool {
        return isiPad && UIScreen.main.nativeBounds.size.height == 2732
    }
    
    public class var isiPadPro97: Bool {
        return isiPad && UIScreen.main.nativeBounds.size.height == 2048
    }
    
    public class var isiPadPro: Bool {
        return isiPad && (isiPadPro97 || isiPadPro129)
    }
}

extension Notification.Name {
    static let cart = Notification.Name("cart")
}

