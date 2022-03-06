//
//  DottedRoundedButton.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class DottedRoundedButton: UIButton {
    
    private let dashedLineColor = UIColor.mainGreen?.cgColor
    private let dashedLinePattern: [NSNumber] = [6, 3]
    private let dashedLineWidth: CGFloat = 1

      private let borderLayer = CAShapeLayer()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tintColor = .mainGreen
        titleLabel?.font = .secondaryTitleFont
        titleLabel?.textAlignment = .center
        layer.cornerRadius = 10

        borderLayer.strokeColor = dashedLineColor
        borderLayer.lineDashPattern = dashedLinePattern
        borderLayer.backgroundColor = UIColor.clear.cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = dashedLineWidth
        borderLayer.cornerRadius = 10
        layer.addSublayer(borderLayer)
    }
    
    override func draw(_ rect: CGRect) {
           borderLayer.frame = bounds
           borderLayer.path = UIBezierPath(roundedRect: rect, cornerRadius: layer.cornerRadius).cgPath
       }

}
