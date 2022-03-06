//
//  SummaryTableViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class SummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorView.backgroundColor = .paleGrey
        titleLabel.textColor = .mainGreen
        titleLabel.font = .primaryTitleFont
        
        summaryLabel.textColor = .descriptiontText
        summaryLabel.font = .descriptionFont
    }
}
