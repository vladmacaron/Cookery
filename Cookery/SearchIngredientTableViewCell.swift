//
//  SearchIngredientTableViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 18.05.21.
//

import UIKit

class SearchIngredientTableViewCell: UITableViewCell {

    @IBOutlet weak var ingredientImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet private weak var actionButton: UIButton!
    
    func setIsCellAdded(_ isCellAdded: Bool) {
        if isCellAdded {
            actionButton.setImage(UIImage(named: "addedToListIcon"), for: .normal)
        } else {
            actionButton.setImage(UIImage(named: "addButton"), for: .normal)
        }
    }
    
    var actionBlock: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        label.font = .descriptionFont
        label.textColor = .primaryTitleText
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        ingredientImageView.image = nil
        actionBlock = nil
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        actionBlock?()
    }
}
