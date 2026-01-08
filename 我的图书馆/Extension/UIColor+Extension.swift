//
//  UIColor+Extension.swift
//  我的图书馆
//
//  Created by dongliang on 2025/11/11.
//

import UIKit

extension UIColor {
    class func RGBA(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        UIColor(displayP3Red: r / 255.0,
                green: g / 255.0,
                blue: b / 255.0,
                alpha: a)
    }

    class func RGB(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        RGBA(r, g, b, 1.0)
    }
    
    /// 支持 3、4、6、8 位 hex 字符串，例如 "#FFF"、"80FF0000"
    class func hex(_ hexString: String) -> UIColor? {
        //trimmingCharacters移除字符串两端的指定字符，whitespacesAndNewlines是一个内置字符集合，包含所有的空格、回车等
        //然后转成大写
        var hex = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if hex.hasPrefix("#") { hex.removeFirst() }
        
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 1
        var hexValue: UInt64 = 0
        //Scanner是一个工具类，用来从字符串中按规则读取数值（Int、Float、Hex 等）
        //创建一个Scanner扫描器对象，传入参数string，调用scanHexInt64尝试从字符串中读取16进制整数
        //&hexValue 是传址参数，意思是把扫描到的结果写入这个变量里，如果扫描失败，就会执行guard的return nil
        //Hex就代表16进制的意思，英文缩写，swift推荐使用scanHexInt64而不是scanHexInt32，因为前者位数更多，不会溢出
        guard Scanner(string: hex).scanHexInt64(&hexValue) else { return nil }
        
        switch hex.count {
        case 3: // RGB
            /*
             hexValue & 0xF00: 二进制的&操作，这个等于是只保留了前四位，因为后面的与0执行&操作，结果肯定是0
             >> 8: 二进制的移位操作，比如1111 0000 0000，向右移动8位，就变成了0000 1111，就是十进制里面的15
             */
            red   = CGFloat((hexValue & 0xF00) >> 8) / 15.0
            green = CGFloat((hexValue & 0x0F0) >> 4) / 15.0
            blue  = CGFloat(hexValue & 0x00F) / 15.0
        case 4: // RGBA
            red   = CGFloat((hexValue & 0xF000) >> 12) / 15.0
            green = CGFloat((hexValue & 0x0F00) >> 8) / 15.0
            blue  = CGFloat((hexValue & 0x00F0) >> 4) / 15.0
            alpha = CGFloat(hexValue & 0x000F) / 15.0
        case 6: // RRGGBB
            red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
            green = CGFloat((hexValue & 0x00FF00) >> 8) / 255.0
            blue  = CGFloat(hexValue & 0x0000FF) / 255.0
        case 8: // RRGGBBAA
            red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
            green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((hexValue & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(hexValue & 0x000000FF) / 255.0
        default:
            return nil
        }
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    //arc4random_uniform和arc4random的区别就是前者没有模偏差，后者有模偏差
    //模偏差就是：假如随机取0-10之间的随机数，arc4random会随机取0 - 2^32-1之间的一个数，32次方是和CPU位数有关，64位的CPU为了兼容性，基本上也都是取32次方，2^32 - 1的值是4294967295，它除10等于429496729余5，那么意思就随机数结果0-5之间的数概率会大一点，这个就是模偏差
    class func randomColor() -> UIColor {
        let red: CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
        let green: CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
        let blue: CGFloat = CGFloat(arc4random_uniform(255)) / 255.0
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
