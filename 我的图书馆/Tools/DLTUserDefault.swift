//
//  DLTUserDefaultKey.swift
//  我的图书馆
//
//  Created by dongliang on 2025/11/8.
//

import Foundation

extension UserDefaults {
    
    func set(_ value: Any?, for key: DLTCacheDataKey) {
        set(value, forKey: key.rawValue)
    }
    
    func value(for key: DLTCacheDataKey) -> Any? {
        return object(forKey: key.rawValue)
    }
    
    //实现这个方法，是为了自动推断出来这个key是DLTCacheDataKey，调用时就可以直接写.DLTThemeTypeKey了
    //如果还是调用系统的话，必须保证forKey是个字符传，所以必须写DLTCacheDataKey.DLTThemeTypeKey.rawValue
    //实现之后，以后调用就方便了
    func string(for key: DLTCacheDataKey) -> String? {
        return string(forKey: key.rawValue)
    }
    
    func array(for key: DLTCacheDataKey) -> [Any]? {
        return array(forKey: key.rawValue)
    }
    
    func dictionary(for key: DLTCacheDataKey) -> [String: Any]? {
        return dictionary(forKey: key.rawValue)
    }
    
    func data(for key: DLTCacheDataKey) -> Data? {
        return data(forKey: key.rawValue)
    }
    
    func stringArray(for key: DLTCacheDataKey) -> [String]? {
        return stringArray(forKey: key.rawValue)
    }
    
    func integer(for key: DLTCacheDataKey) -> Int {
        return integer(forKey: key.rawValue)
    }
    
    func float(for key: DLTCacheDataKey) -> Float {
        return float(forKey: key.rawValue)
    }
    
    func double(for key: DLTCacheDataKey) -> Double {
        return double(forKey: key.rawValue)
    }
    
    func bool(for key: DLTCacheDataKey) -> Bool {
        return bool(forKey: key.rawValue)
    }
    
    
}
