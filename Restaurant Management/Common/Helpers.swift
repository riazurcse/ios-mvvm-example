//
//  Helpers.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import Foundation


class Helpers: NSObject {
    
    static func setJSONDictionaryValueWithKey(_ data: [String: Any], key: String) {
        
        let dictionaryData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
        let appData = UserDefaults.standard
        appData.set(dictionaryData, forKey: key)
        appData.synchronize()
    }
    
    static func getJSONDictionaryValueWithKey(_ key: String) -> [String: Any] {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? Data {
            let dictionaryData: Dictionary? = NSKeyedUnarchiver.unarchiveObject(with: value) as? [String : Any]
            return dictionaryData!
        }
        return ["":""]
    }
    
    static func setJSONArrayValueWithKey(_ data: [Any], key: String) {
        
        let arrayData: Data = NSKeyedArchiver.archivedData(withRootObject: data)
        let appData = UserDefaults.standard
        appData.set(arrayData, forKey: key)
        appData.synchronize()
    }
    
    static func getJSONArrayValueWithKey(_ key: String) -> [Any] {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? Data {
            var arrayData = [Any]()
            arrayData = (NSKeyedUnarchiver.unarchiveObject(with: value) as? [Any])!
            return arrayData
        }
        return [Any]()
    }
    
    static func setStringValueWithKey(_ data: String, key: String) {
        
        let appData = UserDefaults.standard
        appData.set(data, forKey: key)
        appData.synchronize()
    }
    
    static func setBoolValueWithKey(_ data: Bool, key: String) {
        
        let appData = UserDefaults.standard
        appData.set(data, forKey: key)
        appData.synchronize()
    }
    
    static func setIntValueWithKey(_ data: Int, key: String) {
        
        let appData = UserDefaults.standard
        appData.set(data, forKey: key)
        appData.synchronize()
    }
    
    static func getStringValueForKey(_ key: String) -> String {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? String {
            return value
        }
        return ""
    }
    
    static func getBoolValueForKey(_ key: String) -> Bool {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? Bool {
            return value
        }
        return false
    }
    
    static func getIntValueForKey(_ key: String) -> Int {
        
        let appData = UserDefaults.standard
        if let value = appData.object(forKey: key) as? Int {
            return value
        }
        return -1
    }
    
    static func removeValue(_ key: String) {
        
        let appData = UserDefaults.standard
        appData.removeObject(forKey: key)
        appData.synchronize()
    }
}






