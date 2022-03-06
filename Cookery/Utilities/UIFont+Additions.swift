//
//  UIFont+Additions.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 16.05.21.
//

import UIKit

extension UIFont {
    static func applicationRegularFont(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .regular)
    }
    
    static func applicationSemiBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
    }
    
    static func applicationBoldFont(withSize size: CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .bold)
    }
    
    static let primaryTitleFont = UIFont.applicationSemiBoldFont(withSize: 18)
    static let secondaryTitleFont = UIFont.applicationSemiBoldFont(withSize: 16)
    static let descriptionFont = UIFont.applicationSemiBoldFont(withSize: 14)
    static let indicatorTitleFont = UIFont.applicationSemiBoldFont(withSize: 11)
}
