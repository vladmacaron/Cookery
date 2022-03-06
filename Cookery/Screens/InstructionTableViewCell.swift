//
//  InstructionTableViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class InstructionTableViewCell: UITableViewCell {

    @IBOutlet weak var stepSeparatorView: UIView!
    @IBOutlet weak var stepContainerView: OvalView!
    @IBOutlet weak var stepLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        stepSeparatorView.backgroundColor = .paleGrey
        stepContainerView.backgroundColor = .mainGreen
        stepLabel.font = .descriptionFont
        contentLabel.font = .descriptionFont
        contentLabel.textColor = .descriptiontText
    }
}
