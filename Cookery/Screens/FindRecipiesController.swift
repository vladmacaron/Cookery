//
//  FindRecipiesController.swift
//  Cookery
//
//  Created by Vladislav Mazurov on 19.05.21.
//

import UIKit

class FindRecipiesController: UIViewController {
    
    private var recipes: [Recipe] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    private var storageManager = StorageManager.shared
    var model: [Ingredient] = []
    
    var recipeID: Int?
    var type: String?
    var durationValue: String?
    var fatValue: String?
    var carbValue: String?
    var proteinValue: String?
    var caloriesValue: String?
    
    @IBOutlet weak var searchBarContainer: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getRecipesByIngredients()
        
        titleLabel.font = .primaryTitleFont
        titleLabel.textColor = .primaryTitleText
        titleLabel.text = "Find Recipes"
        
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        searchBar.searchTextField.backgroundColor = .clear
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        
        searchBarContainer.backgroundColor = .paleGrey
        searchBarContainer.layer.cornerRadius = 10
        
        tableView.rowHeight = 100
        tableView.separatorColor = .lightGray
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FindRecipeCell", bundle: nil), forCellReuseIdentifier: "FindRecipeCell")
        tableView.reloadData()
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        searchBar.resignFirstResponder()
    }
    
    func getRecipesByIngredients() {
        model = storageManager.getAllItems()
        let ingredientsString = String(model.reduce("", { result, ingredient in
            result + "," + ingredient.name
        }).dropFirst())
        
        NetwokringHandler.getRecipesForIngredients(type, durationValue, caloriesValue, proteinValue,
                                                   carbValue, fatValue, completion: { [weak self] result in
            switch result {
            case .success(let recipes): self?.recipes = recipes.results
            case .failure(let error): print(error)
            }
        })
    }
    
}

extension FindRecipiesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FindRecipeCell", for: indexPath) as! FindRecipeCell
        
        let recipe = recipes[indexPath.row]
        
        cell.recipeNameLabel.text = recipe.title
        
        DispatchQueue.global().async { [weak cell] in
            if let url = URL(string: recipe.imageURL()),
               let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        cell?.recipeImage.image = image
                    }
                }
            }
        }
        
        return cell
        
    }
    
}

extension FindRecipiesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeID = Int(recipes[indexPath.row].id)
        self.performSegue(withIdentifier: "goToRecipeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipeDetails" {
            let destinationVC = segue.destination as! RecipeDetailsViewController
            destinationVC.recipeID = recipeID
        }
    }
}

extension FindRecipiesController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 1 {
            NetwokringHandler.getRecipesForQuery(searchText, completion: { [weak self] result in
                switch result {
                case .success(let recipes): self?.recipes = recipes
                case .failure(let error): print(error)
                }
            })
        } else {
            recipes = []
        }
    }
}
