//
//  APIClient.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

struct APIClient {
    
    // MARK: - Singleton
    static let shared = APIClient()
    
    func get(url: String, completion: @escaping (JSON?, Error?) -> ()) {
        Alamofire.request(url).responseJSON { response in
            if let error = response.error {
                completion(nil, error)
            }
            if let response = response.result.value {
                if let result = response as? [[String: Any]] {
                    completion(JSON(result), nil)
                }
            }
        }
    }
}
