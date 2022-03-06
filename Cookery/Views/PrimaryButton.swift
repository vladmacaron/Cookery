//
//  PrimaryButton.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 17.05.21.
//

import UIKit

class PrimaryButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 10
    }
    
    private func configureUI() {
        backgroundColor = .mainGreen
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .secondaryTitleFont
    }
}
