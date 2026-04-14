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
    private(set) var DLT_888C95_888C95: UIColor?
    private(set) var DLT_2563EB_2563EB: UIColor?
    private(set) var DLT_F5F7FB_1A1B21: UIColor?
    private(set) var DLT_E5E7EB_3A3C44: UIColor?
    private(set) var DLT_111827_FFFFFF: UIColor?
    private(set) var DLT_6B7280_9CA3AF: UIColor?
    
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
            DLT_888C95_888C95 = UIColor.hex("#888C95")
            DLT_2563EB_2563EB = UIColor.hex("#2563EB")
            DLT_F5F7FB_1A1B21 = UIColor.hex("#F5F7FB")
            DLT_E5E7EB_3A3C44 = UIColor.hex("#E5E7EB")
            DLT_111827_FFFFFF = UIColor.hex("#111827")
            DLT_6B7280_9CA3AF = UIColor.hex("#6B7280")
        case .night:
            bgColor = UIColor.hex("#181B21")
            DLT_333333_FFFFFF = UIColor.hex("#FFFFFF")
            DLT_F7F8FA_20242C = UIColor.hex("#20242C")
            DLT_888C95_888C95 = UIColor.hex("#888C95")
            DLT_2563EB_2563EB = UIColor.hex("#2563EB")
            DLT_F5F7FB_1A1B21 = UIColor.hex("#1A1B21")
            DLT_E5E7EB_3A3C44 = UIColor.hex("#3A3C44")
            DLT_111827_FFFFFF = UIColor.hex("#FFFFFF")
            DLT_6B7280_9CA3AF = UIColor.hex("#9CA3AF")
        }
    }
}

