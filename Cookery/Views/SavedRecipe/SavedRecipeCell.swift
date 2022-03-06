//
//  SavedRecipeCell.swift
//  Cookery
//
//  Created by Vladislav Mazurov on 16.05.21.
//

import UIKit

class SavedRecipeCell: UITableViewCell {

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeRatingLabel: UILabel!
    @IBOutlet weak var recipeTimeLabel: UILabel!
    @IBOutlet weak var recipePriceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(systemName: "timer")
        let fullString = NSAttributedString(attachment: imageAttachment)
        timeLabel.attributedText = fullString
        recipeNameLabel.font = .primaryTitleFont
        recipeNameLabel.textColor = .primaryTitleText
        timeLabel.font = .primaryTitleFont
        timeLabel.textColor = .primaryTitleText
        recipePriceLabel.font = .primaryTitleFont
        recipePriceLabel.textColor = .primaryTitleText
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
