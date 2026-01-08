//
//  DLTThemeManager.swift
//  我的图书馆
//
//  Created by dongliang on 2025/11/8.
//

import Foundation
import UIKit

final class DLTThemeManager {
    /*
     static let会让swift底层生成延迟初始化的懒加载逻辑，且可以保证线程安全，系统在底层用了 dispatch_once 机制，全局只会初始化一次
     */
    static let shareManager = DLTThemeManager()
    //private(set): readOnly
    private(set) var bgColor: UIColor?
    private(set) var DLT_333333_FFFFFF: UIColor?
    private(set) var DLT_F7F8FA_20242C: UIColor?
    
    private init() {
        let themeTypeNum = UserDefaults.standard.integer(for: .DLTThemeTypeKey)
        let themeType = DLTThemeType(rawValue: themeTypeNum) ?? .day
        colorWithType(themeType)
    }
    
    func colorWithType(_ themeType: DLTThemeType) {
        switch themeType {
        case .day:
            bgColor = UIColor.hex("#FFFFFF")
            DLT_333333_FFFFFF = UIColor.hex("#333333")
            DLT_F7F8FA_20242C = UIColor.hex("#F7F8FA")
        case .night:
            bgColor = UIColor.hex("#181B21")
            DLT_333333_FFFFFF = UIColor.hex("#FFFFFF")
            DLT_F7F8FA_20242C = UIColor.hex("#20242C")
        }
    }
}

