//
//  SearchIngredientsViewController.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 18.05.21.
//

import UIKit

class SearchIngredientsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private let storageManager = StorageManager.shared
    private var ingredients: [Ingredient] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.backgroundColor = .clear
        searchBarContainer.backgroundColor = .paleGrey
        searchBarContainer.layer.cornerRadius = 10

        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.delegate = self
        
        separatorView.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.rowHeight = 100
        tableView.separatorColor = .lightGray
        
        titleLabel.font = .primaryTitleFont
        titleLabel.textColor = .primaryTitleText
        titleLabel.text = "Add ingredients"
        navigationController?.navigationBar.tintColor = .mainGreen
    }
  
    @IBAction func searchButton(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
}

extension SearchIngredientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientCell", for: indexPath) as? SearchIngredientTableViewCell else {
            fatalError("Unable to deque cell")
        }
        
        let ingredient = ingredients[indexPath.row]
        cell.label.text = ingredient.name
        cell.setIsCellAdded(storageManager.isItemContained(ingredient))
        cell.actionBlock = { [weak self] in
            guard let strongSelf = self else {
                return
            }
            
            if strongSelf.storageManager.isItemContained(ingredient) {
                self?.storageManager.removedStoredItem(ingredient)
                cell.setIsCellAdded(false)
            } else {
                self?.storageManager.addItem(ingredient)
                cell.setIsCellAdded(true)
            }
        }
        
        NetwokringHandler.loadImageURL(ingredient.imageURL(for: .medium), into: cell.ingredientImageView)
        return cell
    }
}

extension SearchIngredientsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            NetwokringHandler.getIngredientsForQuery(searchText, completion: { [weak self] result in
                switch result {
                case .success(let ingredients): self?.ingredients = ingredients
                case .failure(let error): print(error)
                }
            })
        } else {
            ingredients = []
        }
    }
}
