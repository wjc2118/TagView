//
//  UIColor+WJC.swift
//  stringExten
//
//  Created by Mac-os on 16/8/12.
//  Copyright © 2016年 risen. All rights reserved.
//

import UIKit

public struct WJCColor {
}

extension WJCColor {
    
    public var randomColor: UIColor {
        return UIColor(colorLiteralRed: Float(Int(arc4random_uniform(256))) / 255.0, green: Float(Int(arc4random_uniform(256))) / 255.0, blue: Float(Int(arc4random_uniform(256))) / 255.0, alpha: 1.0)
    }
    
    public func hex(_ hex: Int, alpha: Float) -> UIColor {
        guard hex <= 0xFFFFFF else {
            return UIColor(white: 0.0, alpha: 0.0)
        }
        return UIColor(colorLiteralRed: Float((hex & 0xFF0000) >> 16) / 255.0, green: Float((hex & 0xFF00) >> 8) / 255.0, blue: Float(hex & 0xFF) / 255.0, alpha: alpha)
    }
    
    public func hex(_ hex: UInt) -> UIColor {
        if hex <= 0xFFFFFF {
            return self.hex(Int(hex), alpha: 1.0)
        } else if hex <= 0xFFFFFFFF {
            return UIColor(colorLiteralRed: Float((hex & 0xFF0000) >> 16) / 255.0, green: Float((hex & 0xFF00) >> 8) / 255.0, blue: Float(hex & 0xFF) / 255.0, alpha: Float((hex & 0xFF000000) >> 24) / 255.0)
        } else {
            return UIColor(white: 0.0, alpha: 0.0)
        }
    }
    
    public func hexString(_ hexString: String) -> UIColor {
        
        var hex: UInt32 = 0
        let scanner = Scanner(string: hexString)
        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
        
        guard scanner.scanHexInt32(&hex) else {
            return UIColor(white: 0.0, alpha: 0.0)
        }
        
        return self.hex(UInt(hex))
    }
    
}

public extension UIColor {
    
    public static var wjc: WJCColor {
        return WJCColor()
    }
    
    convenience init(r: Int, g: Int, b: Int) {
        self.init(colorLiteralRed: Float(r) / 255.0, green: Float(g) / 255.0, blue: Float(b) / 255.0, alpha: 1)
    }
    
//    convenience init(wjc_hex: UInt) {
//        if wjc_hex <= 0xFFFFFF {
//            self.init(wjc_hex: Int(wjc_hex), alpha: 1)
//        } else if wjc_hex <= 0xFFFFFFFF {
//            self.init(colorLiteralRed: Float((wjc_hex & 0xFF0000) >> 16) / 255.0, green: Float((wjc_hex & 0xFF00) >> 8) / 255.0, blue: Float(wjc_hex & 0xFF) / 255.0, alpha: Float((wjc_hex & 0xFF000000) >> 24) / 255.0)
//        } else {
//            self.init(white: 0, alpha: 0)
//        }
//    }
    
//    convenience init(wjc_hex: Int, alpha: Float) {
//        guard wjc_hex <= 0xFFFFFF else {
//            self.init(white: 0, alpha: 0); return
//        }
//        
//        self.init(colorLiteralRed: Float((wjc_hex & 0xFF0000) >> 16) / 255.0, green: Float((wjc_hex & 0xFF00) >> 8) / 255.0, blue: Float(wjc_hex & 0xFF) / 255.0, alpha: alpha)
//    }
    
//    convenience init(wjc_hexString: String) {
//        var hex: UInt32 = 0
//        let scanner = Scanner(string: wjc_hexString)
//        scanner.charactersToBeSkipped = CharacterSet(charactersIn: "#")
//        
//        guard scanner.scanHexInt32(&hex) else {
//            self.init(white: 0, alpha: 0); return
//        }
//        
//        self.init(wjc_hex: UInt(hex))
//    }
    
//    class func wjc_randomColor() -> Self {
//        return self.init(colorLiteralRed: Float(Int(arc4random_uniform(256))) / 255.0, green: Float(Int(arc4random_uniform(256))) / 255.0, blue: Float(Int(arc4random_uniform(256))) / 255.0, alpha: 1)
//    }
    
}
