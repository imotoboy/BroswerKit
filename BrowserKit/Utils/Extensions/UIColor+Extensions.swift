//
//  UIColor+Extensions.swift
//  BrowserKit
//
//  Created by tramp on 2021/1/23.
//

import UIKit

extension UIColor {
    /// 随机色
    internal class var random: UIColor {
        return UIColor.init(red: ((CGFloat((arc4random() % 256)) / 255.0)), green: ((CGFloat((arc4random() % 256)) / 255.0)), blue: ((CGFloat((arc4random() % 256)) / 255.0)), alpha: 1.0)
    }
    
    /// 修改颜色透明度
    /// - Parameter value: CGFloat
    internal func alpha(_ value: CGFloat) -> UIColor {
        return withAlphaComponent(value)
    }
    
    /// 构建颜色
    ///
    /// - Parameters:
    ///   - hex: 16 进制
    convenience init(hex: String) {
        var hex = hex
        // 剔除 #
        while hex.hasPrefix("#") {
            hex.removeFirst()
        }
        let colorValue: String
        let alphaValue: CGFloat
        if hex.count == 6 {
            colorValue = .init(hex.prefix(6))
            alphaValue = 1.0
        } else if hex.count > 6 {
            colorValue = .init(hex.prefix(6))
            let value = (hex.suffix(from: colorValue.endIndex) as NSString).intValue
            alphaValue = value > 100 ? 1.0 : (CGFloat(value) / 100.0)
        } else {
            fatalError("Incorrect color value format  value: \(hex)")
        }
        // 构建 Scanner
        let scanner = Scanner(string: colorValue)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        // 扫描
        scanner.scanHexInt64(&rgbValue)
        // 构建参数
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        // 构建 UIColor
        self.init( red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: alphaValue)
        
    }
    
}

extension UIColor: Compatible {}
extension CompatibleWrapper where Base: UIColor {
    
    /// 调节颜色
    /// - Parameters:
    ///   - saturation: 饱和度
    ///   - brightness:
    ///   - alpha: 亮度
    /// - Returns: 透明度
    internal func adjust(saturation: CGFloat? = nil, brightness: CGFloat? = nil, alpha: CGFloat? = nil) -> UIColor {
        var _hue: CGFloat = 0.0
        var _saturation: CGFloat = 0.0
        var _brightness: CGFloat = 0.0
        var _alpha: CGFloat = 0.0
        base.getHue(&_hue, saturation: &_saturation, brightness: &_brightness, alpha: &_alpha)
        if let saturation = saturation { _saturation = saturation }
        if let brightness = brightness { _brightness = brightness }
        if let alpha = alpha { _alpha = alpha }
        
        return UIColor.init(hue: _hue, saturation: _saturation, brightness: _brightness, alpha: _alpha)
    }
    
    /// UIColor 转 hex 字符串
    ///
    /// - Parameter hash: 是否携带 “#”
    /// - Returns: hex 字符串
    internal func toHex(hash: Bool = true) -> String {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        // 获取 色值
        base.getRed(&r, green: &g, blue: &b, alpha: &a)
        // 构建 hex string
        var hex = String( format: "%02X%02X%02X",Int(r * 0xff), Int(g * 0xff), Int(b * 0xff))
        // 添加 hash (#)
        if hash == true { hex = "#\(hex)" }
        // 返回
        return hex
    }

}

extension UIColor {
    
    /// ==
    /// - Parameters:
    ///   - lhs: UIColor
    ///   - rhs: UIColor
    /// - Returns: Bool
   internal static func == (lhs: UIColor, rhs: UIColor) -> Bool {
        return lhs.hub.toHex() == rhs.hub.toHex()
    }
    
}
