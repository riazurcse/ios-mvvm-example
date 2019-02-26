//
//  FoodShopViewModel.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import Foundation
import SwiftyJSON

class FoodShopViewModel {
    
    var shops: JSON? {
        didSet {
            self.didFinishFetch?()
        }
    }
    
    var error: Error? {
        didSet { self.showAlertClosure?() }
    }
    
    var showAlertClosure: (() -> ())?
    var didFinishFetch: (() -> ())?
    
    private var foodShopService: FoodShopService?
    
    init() {
        self.foodShopService = FoodShopService(apiClient: APIClient())
    }
    
    func fetchShops() {
        self.foodShopService?.getShops(completion: { (shops, error) in
            if let error = error {
                self.error = error
                return
            }
            self.error = nil
            self.shops = shops
        })
    }
}




