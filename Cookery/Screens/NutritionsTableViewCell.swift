//
//  NutritionsTableViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class NutritionsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var firstBarWidthRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var secondBarWidthRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var thirdBarWidthRatioConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var firstBar: UIView!
    @IBOutlet weak var secondBar: UIView!
    @IBOutlet weak var thirdBar: UIView!
    
    @IBOutlet weak var firstBarIndicator: OvalView!
    @IBOutlet weak var secondBarIndicator: OvalView!
    @IBOutlet weak var thirdBarIndicator: OvalView!
    
    @IBOutlet weak var firstBarIndicatorLabel: UILabel!
    @IBOutlet weak var secondBarIndicatorLabel: UILabel!
    @IBOutlet weak var thirdBarIndicatorLabel: UILabel!
    
    @IBOutlet weak var caloriesContainerView: OvalView!
    @IBOutlet weak var caloriesLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        titleLabel.textColor = .mainGreen
        titleLabel.font = .primaryTitleFont
        
        firstBar.backgroundColor = .prominentGreen
        secondBar.backgroundColor = .mainGreen
        thirdBar.backgroundColor = .secondaryGreen
        
        firstBarIndicator.backgroundColor = .prominentGreen
        secondBarIndicator.backgroundColor = .mainGreen
        thirdBarIndicator.backgroundColor = .secondaryGreen
        
        durationLabel.textColor = .descriptiontText
        durationLabel.font = .descriptionFont
        
        [firstBarIndicatorLabel, secondBarIndicatorLabel, thirdBarIndicatorLabel].forEach {
            $0?.textColor = .descriptiontText
            $0?.font = .descriptionFont
        }
        
        caloriesLabel.textColor = .mainGreen
        caloriesLabel.font = .descriptionFont
        
        separatorView.backgroundColor = .paleGrey
        titleLabel.text = "Nutritions"
        
        caloriesContainerView.layer.borderWidth = 1
        caloriesContainerView.layer.borderColor = UIColor.mainGreen?.cgColor
    }
    
    func configure(for recipe: DetailedRecipe) {
        guard let nutritionDescriptor = recipe.nutritionDescriptor else {
            return
        }
        firstBarWidthRatioConstraint = firstBarWidthRatioConstraint.changeMultiplier(multiplier: CGFloat(nutritionDescriptor.fatsRatio))
        secondBarWidthRatioConstraint = secondBarWidthRatioConstraint.changeMultiplier(multiplier: CGFloat(nutritionDescriptor.carbsRatio))
        thirdBarWidthRatioConstraint = thirdBarWidthRatioConstraint.changeMultiplier(multiplier: CGFloat(nutritionDescriptor.proteinRatio))
        
        firstBarIndicatorLabel.text = nutritionDescriptor.fatsLabel
        secondBarIndicatorLabel.text = nutritionDescriptor.carbsLabel
        thirdBarIndicatorLabel.text = nutritionDescriptor.proteinLabel
        
        durationLabel.text = "\(recipe.readyInMinutes) min"
        caloriesLabel.text = nutritionDescriptor.caloriesLabel
    }
}

private extension NSLayoutConstraint {
    
    func changeMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(
            item: firstItem as Any,
            attribute: firstAttribute,
            relatedBy: relation,
            toItem: secondItem,
            attribute: secondAttribute,
            multiplier: multiplier,
            constant: constant)
        newConstraint.priority = priority
        
        NSLayoutConstraint.deactivate([self])
        NSLayoutConstraint.activate([newConstraint])
        
        return newConstraint
    }
}
