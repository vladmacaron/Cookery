//
//  UIView+Utilities.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class OvalView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
    }
}

