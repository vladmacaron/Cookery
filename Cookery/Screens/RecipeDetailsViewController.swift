//
//  RecipeDetailsViewController.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class RecipeDetailsViewController: UIViewController, Activatable {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var titleSeparator: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    private var storageManager = StorageManager.shared
    var bookmarkImage: UIImage? {
        guard let recipe = recipe else {
            return nil
        }
        if storageManager.isItemContained(recipe) {
            return UIImage(named: "bookmarkActiveIcon")
        } else {
            return UIImage(named: "bookmarkIcon")
        }
    }
    
    enum Section: Int, CaseIterable {
        case nutritions
        case ingredients
        case equipment
        case instructionsHeader
        case instructions
        case summary
    }
    
    //var recipeID: Int? = 765011
    var recipeID: Int?
    private var recipe: DetailedRecipe? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var rightBarButtonItem: UIBarButtonItem {
        let button = UIBarButtonItem(image: bookmarkImage,
                                     style: .plain,
                                     target: self, action: #selector(toggleBookmark))
        return button
    }
    
    var spinnerHolder: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadRecipe()
    }
    
    private func configureUI() {
        tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        tableView.layer.cornerRadius = 40
        tableView.clipsToBounds = true
        tableView.dataSource = self
        tableView.delegate = self
        
        navigationController?.navigationBar.tintColor = .mainGreen
        
        imageView.backgroundColor = .mainGreen
        nameLabel.textColor = .primaryTitleText
        nameLabel.text = "" //dummy recepie name for loading recepie here
        nameLabel.font = .primaryTitleFont
        
        titleSeparator.backgroundColor = .paleGrey
    }
    
    private func loadRecipe() {
        startActivity()
        guard let recipeID = recipeID else {
            stopActivity()
            return
        }
        
        NetwokringHandler.getDetailedRecipe(with: recipeID) { [weak self] result in
            self?.stopActivity()
            if case let .success(recipe) = result {
                self?.recipe = recipe
                self?.nameLabel.text = recipe.title
                
                if let imageView = self?.imageView {
                    NetwokringHandler.loadImageURL(recipe.image,
                                                   into: imageView)
                }
                self?.navigationItem.rightBarButtonItem = self?.rightBarButtonItem
            }
        }
    }
    
    @objc func toggleBookmark() {
        guard let recipe = recipe else {
            return
        }
        if storageManager.isItemContained(recipe) {
            storageManager.removedStoredItem(recipe)
        } else {
            storageManager.addItem(recipe)
        }
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
}

extension RecipeDetailsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        
        switch section {
        case .nutritions: return recipe != nil ? 1 : 0
        case .ingredients: return recipe?.extendedIngredients != nil ? 1 : 0
        case .equipment: return recipe?.equipment != nil ? 1 : 0
        case .summary: return recipe?.summary != nil ? 1 : 0
        case .instructionsHeader: return (recipe?.analyzedInstructions.first?.steps.isEmpty ?? true) ? 0 : 1
        case .instructions: return (recipe?.analyzedInstructions.first?.steps.isEmpty ?? true) ? 0 : (recipe?.analyzedInstructions.first?.steps.count ?? 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .nutritions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NutritionsCell", for: indexPath) as? NutritionsTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            if let recipe = recipe {
                cell.configure(for: recipe)
            }
            return cell
        case .ingredients:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalList", for: indexPath) as? HorizontalListTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            if let recipe = recipe {
                cell.model = HorizontalListTableViewCell.Model(title: "Ingredients",
                                                               items: recipe.extendedIngredients)
            }
            return cell
        case .equipment:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "HorizontalList", for: indexPath) as? HorizontalListTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            if let recipe = recipe {
                cell.model = HorizontalListTableViewCell.Model(title: "Equipment",
                                                               items: recipe.equipment)
            }
            return cell
       
        case .instructionsHeader:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleCell", for: indexPath) as? TitleTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.titleLabel.text = "Instructions"
            
            return cell
        case .instructions:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InstructionCell", for: indexPath) as? InstructionTableViewCell,
                  let steps = recipe?.analyzedInstructions.first?.steps else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            let step = steps[indexPath.row]
            cell.stepLabel.text = "\(step.number)"
            cell.contentLabel.text = step.step
            
            return cell
         case .summary:
                    guard let cell = tableView.dequeueReusableCell(withIdentifier: "SummaryCell", for: indexPath) as? SummaryTableViewCell else {
                        return UITableViewCell()
                    }
                    cell.selectionStyle = .none
                    cell.titleLabel.text = "Description"
                    cell.summaryLabel.text = recipe?.summary.withoutHtml
                    
                    return cell
        }
    }
}

extension RecipeDetailsViewController: UITableViewDelegate {
}

extension Ingredient: Listable {
    var displayedName: String {
        return originalName ?? name
    }
    
    var imageResource: String {
        return imageURL(for: .small)
    }
}

extension Equipment: Listable {
    var displayedName: String {
        return name
    }
    
    var imageResource: String {
        return imageURL(for: .small)
    }
}

private extension String {
    var withoutHtml: String {
        guard let data = self.data(using: .utf8) else {
            return self
        }
        
        let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
        ]
        
        guard let attributedString = try? NSAttributedString(data: data, options: options, documentAttributes: nil) else {
            return self
        }
        
        return attributedString.string
    }
}
