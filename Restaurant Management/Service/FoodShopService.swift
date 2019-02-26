//
//  FoodShopService.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct FoodShopService {
    
    private var apiClient: APIClient?
    
    init() {
    }
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getShops(completion: @escaping (JSON?, Error?) -> ()) {
        let shopsURL = Url.BASE_URL + Url.SHOP_LIST_URL
        self.apiClient?.get(url: shopsURL, completion: { (shops, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            let shopJSON = JSON(shops ?? "")
            completion(shopJSON, nil)
        })
    }
    
    func getFoods(id: String, completion: @escaping (JSON?, Error?) -> ()) {
        let foodItems = Url.BASE_URL + Url.FOOD_ITEM_LIST_URL + id
        self.apiClient?.get(url: foodItems, completion: { (foods, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            let foodJSON = JSON(foods ?? "")
            completion(foodJSON, nil)
        })
    }
}


