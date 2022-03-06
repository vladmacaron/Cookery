//
//  DashboardViewController.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 19.05.21.
//

import UIKit

enum RecipeType: Int {
    case salads
    case mainDishes
    case deserts
    case snacks
    case breakfast
    case soup
}

class DashboardViewController: UIViewController, Activatable {
    @IBOutlet private weak var headerView: UIView!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private lazy var customizeMealTapGestureRecognizer: UITapGestureRecognizer = {
        UITapGestureRecognizer(target: self, action: #selector(didTapCustomizeMeal))
    }()
    private var randomRecepies: [Recipes] = [] {
        didSet {
            reloadSection(.random)
        }
    }
    var spinnerHolder: UIView?
    
    private enum Section: Int, CaseIterable {
        case random
        case type
        case customize
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        loadRandomRecepies()
    }
    
    private func configureUI() {
        titleLabel.text = "Recipes"
        tableView.register(UINib(nibName: "RandomRecipesTableViewCell", bundle: nil), forCellReuseIdentifier: "RandomCell")
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func reloadSection(_ section: Section) {
        tableView.reloadSections(IndexSet(integer: section.rawValue), with: .automatic)
    }
    
    private func loadRandomRecepies() {
        startActivity()
        NetwokringHandler.getRandomRecipes(withLimit: 7) { [weak self] result in
            self?.stopActivity()
            if case let .success(randomQuery) = result {
                self?.randomRecepies = randomQuery.recipes
            }
        }
    }
    
    @objc func didTapCustomizeMeal() {
        let vc = UIStoryboard(name: "CustomizeMeal", bundle: nil).instantiateViewController(identifier: "CMViewController")
        navigationController?.pushViewController(vc, animated: true)
       
    }
}

extension DashboardViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = Section(rawValue: section) else {
            return 0
        }
        switch section {
        case .random:
            return randomRecepies.isEmpty ? 0 : 1
        case .type, .customize:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        
        switch section {
        case .random:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RandomCell", for: indexPath) as? RandomRecipesTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: randomRecepies)
            cell.delegate = self
            return cell
        case .type:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TypeCell", for: indexPath) as? TypeSelectionTableViewCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        case .customize:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizeCell", for: indexPath)
            cell.selectionStyle = .none
            cell.addGestureRecognizer(customizeMealTapGestureRecognizer)
            return cell
        }
    }
}

extension DashboardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableView.automaticDimension
        }
        switch section {
        case .random:
            return 180
        default:
            return UITableView.automaticDimension
        }
    }
}

extension DashboardViewController: RandomRecipesDelegate {
    func didSelectItem(_ item: Recipes) {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "RecipeDetailsViewController") as? RecipeDetailsViewController else {
            return
        }
        viewController.recipeID = Int(item.id)
        viewController.navigationItem.title = "Recipe Overview"
        present(UINavigationController.generateWithRoot(viewController), animated: true, completion: nil)
    }
}

extension DashboardViewController: TypeSelectionDelegate {
    func didSelectType(_ type: RecipeType) {
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FindRecipiesController") as? FindRecipiesController {
            switch type {
            
            case .salads:
                viewController.type = "salad"
            case .mainDishes:
                viewController.type = "main course"
            case .deserts:
                viewController.type = "dessert"
            case .snacks:
                viewController.type = "snack"
            case .breakfast:
                viewController.type = "breakfast"
            case .soup:
                viewController.type = "soup"
            }
            
            present(UINavigationController.generateWithRoot(viewController), animated: true, completion: nil)
        }
    }
}

private extension UINavigationController {
    static func generateWithRoot(_ rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.shadowImage = UIImage()
        navigationController.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainGreen]
        return navigationController
    }
}
