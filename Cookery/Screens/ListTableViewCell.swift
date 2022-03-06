//
//  ListTableViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var separatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = .primaryTitleText
        titleLabel.font = .primaryTitleFont
        separatorView.backgroundColor = .paleGrey
    }
}
