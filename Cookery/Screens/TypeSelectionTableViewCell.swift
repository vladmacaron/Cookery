//
//  TypeSelectionTableViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

protocol TypeSelectionDelegate: AnyObject {
    func didSelectType(_ type: RecipeType)
}

class TypeSelectionTableViewCell: UITableViewCell {
    weak var delegate: TypeSelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        if let type = RecipeType(rawValue: sender.tag) {
            delegate?.didSelectType(type)
        }
    }
}
