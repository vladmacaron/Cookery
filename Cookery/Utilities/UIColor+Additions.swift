//
//  UIColor+Additions.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 16.05.21.
//

import UIKit

extension UIColor {
    static var mainGreen: UIColor? {
        return UIColor(hex: "#7ED321")
    }
    
    static var secondaryGreen: UIColor? {
        return UIColor(hex: "#B8E986")
    }
    
    static var prominentGreen: UIColor? {
        return UIColor(hex: "#417505")
    }

    static var paleGrey: UIColor? {
        return UIColor(hex: "#EBEBEB")
    }
    
    static var componentGrey: UIColor? {
        return UIColor(hex: "#EFC4C4")
    }
    
    static var primaryTitleText: UIColor? {
        return UIColor(hex: "#4A4A4A")
    }
    
    static var descriptiontText: UIColor? {
        return UIColor(hex: "#999999")
    }
    
    // MARK: - Utilities
    
    public convenience init(hex: String) {
        let hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha:1)
    }
}
