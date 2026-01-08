//
//  DLTGlobal.swift
//  myBook
//
//  Created by dongliang on 2025/12/8.
//

import Foundation
import UIKit

//每个文件必须显式 import 依赖的 module
//这样可以全项目自动导入
@_exported import SnapKit

//字体
let FontPingFangMe = "PingFangSC-Medium"
let FontPingFangRe = "PingFangSC-Regular"
let FontPingFangBold = "PingFangSC-Semibold"
let FontDINPro_Me = "DINPro-Medium"
let FontDINPro_Re = "DINPro-Regular"
let FontDINPro_Bold = "DINPro-Bold"

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height
/// 顶部安全区域高度（包含状态栏），得用计算属性，因为启动的是获得的是0，不能用let
var kSafeAreaTop: CGFloat {
    return UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0
}
/// 底部安全区域高度
var kSafeAreaBottom: CGFloat {
    return UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
}
/// 状态栏高度
var kStatusBarHeight: CGFloat {
    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
       let statusBarManager = windowScene.statusBarManager {
        return statusBarManager.statusBarFrame.height
    }else{
        return 0
    }
}



