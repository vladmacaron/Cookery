//
//  IntolerancesViewController.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 17.05.21.
//

import UIKit

struct Intolerance: ChipRepresentable, StorageMainainable {
    static var key = "Intolerance"
    var name: String
}

class IntolerancesViewController: UIViewController {
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var actionButton: PrimaryButton!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var chipSelectorViewContainer: UIView!
    private var chipsSelectorView: ChipsSelectorView<Intolerance>?
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.layer.cornerRadius = 10
        confirmButton.backgroundColor = .mainGreen
        confirmButton.titleLabel?.font = .primaryTitleFont
        configureUI()
    }
    
    private func configureUI() {
        sectionLabel.text = "My intolerances"
        sectionLabel.font = .primaryTitleFont
        sectionLabel.textColor = .primaryTitleText
        actionButton.setTitle("Start using Cookery", for: .normal)
        separatorView.backgroundColor = .paleGrey
        descriptionLabel.textColor = .descriptiontText
        descriptionLabel.font = .descriptionFont
        descriptionLabel.text = """
            A food intolerance is difficulty digesting certain foods and having an unpleasant physical reaction to them. It causes symptoms, such as bloating and tummy pain, which usually happen a few hours after eating the food.
            """
        
        let intolerances: [Intolerance] = [
            Intolerance(name: "Dairy"),
            Intolerance(name: "Egg"),
            Intolerance(name: "Gluten"),
            Intolerance(name: "Grain"),
            Intolerance(name: "Peanut"),
            Intolerance(name: "Seafood"),
            Intolerance(name: "Sesame"),
            Intolerance(name: "Shellfish"),
            Intolerance(name: "Soy"),
            Intolerance(name: "Sulfite"),
            Intolerance(name: "Tree Nut"),
            Intolerance(name: "Wheat")
        ]
        
        chipsSelectorView = ChipsSelectorView(chips: intolerances)
        chipsSelectorView?.delegate = self
        if let chipsSelectorView = chipsSelectorView {
            chipSelectorViewContainer.addSubview(chipsSelectorView)
            chipsSelectorView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                chipsSelectorView.leadingAnchor.constraint(equalTo: chipSelectorViewContainer.leadingAnchor, constant: 0.0),
                chipsSelectorView.trailingAnchor.constraint(equalTo: chipSelectorViewContainer.trailingAnchor, constant: 0.0),
                chipsSelectorView.topAnchor.constraint(equalTo: chipSelectorViewContainer.topAnchor, constant: 0),
                chipsSelectorView.bottomAnchor.constraint(equalTo: chipSelectorViewContainer.bottomAnchor, constant: 0.0)
            ])
        }
    }
    
    @IBAction func confirm(_ sender: Any) {
         //this is a dummy button since it will change automatically but for user friendlier expierence it was added
         print("click")
     }
     
    @IBAction func submitButtonAction(_ sender: Any) {
    }
    
}

extension IntolerancesViewController: ChipsSelectorViewDelegate {
    func didToggleChip() {
        if let selectedChips = chipsSelectorView?.selectedChips {
            StorageManager.shared.setItems(selectedChips)
        }
    }
}
