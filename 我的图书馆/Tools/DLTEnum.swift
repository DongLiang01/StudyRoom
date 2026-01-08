//
//  DLTEnum.swift
//  我的图书馆
//
//  Created by dongliang on 2025/11/8.
//

import Foundation

//主题模式
enum DLTThemeType: Int {
    case day    //白天
    case night   //黑夜
}

//默认会为每个枚举值设置一个rawValue，就是枚举值相同的字符串
enum DLTCacheDataKey: String {
    case DLTThemeTypeKey
}
