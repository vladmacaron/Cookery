//
//  SavedRecipesController.swift
//  Cookery
//
//  Created by Vladislav Mazurov on 16.05.21.
//

import UIKit

class SavedRecipesController: UIViewController {
    
    private var storageManager = StorageManager.shared
    var model: [DetailedRecipe] = []
    
    var recipeID: Int?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "SavedRecipeCell", bundle: nil), forCellReuseIdentifier: "RecipeCell")
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model = storageManager.getAllItems()
        tableView.reloadData()
    }

}

extension SavedRecipesController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! SavedRecipeCell
        let recipe = model[indexPath.row]

        NetwokringHandler.loadImageURL(recipe.image, into: cell.recipeImage)
        cell.recipeNameLabel.text = recipe.title
        cell.recipeTimeLabel.text = String(recipe.readyInMinutes)
        switch recipe.pricePerServing {
        case 0..<80:
            cell.recipePriceLabel.text = "$"
        case 80...150:
            cell.recipePriceLabel.text = "$$"
        default:
            cell.recipePriceLabel.text = "$$$"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.storageManager.removedStoredItem(model[indexPath.row])
            model.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    //rendering stars for rating
    func ratingCalc(rating: Double) ->  NSMutableAttributedString {
        let imageAttachment = NSTextAttachment()
        let rat = Int(rating/10)
        imageAttachment.image = UIImage(systemName: "star.fill")?.withTintColor(.systemYellow)
        let fullString = NSMutableAttributedString()
        if((rat%2) != 0) {
            let imageAttachmentHalf = NSTextAttachment()
            imageAttachmentHalf.image = UIImage(systemName: "star.leadinghalf.fill")?.withTintColor(.systemYellow)
            for _ in 0...((rat/2)-1) {
                fullString.append(NSAttributedString(attachment: imageAttachment))
            }
            fullString.append(NSAttributedString(attachment: imageAttachmentHalf))
        } else {
            for _ in 1...((rat/2)) {
                fullString.append(NSAttributedString(attachment: imageAttachment))
            }
        }
        return fullString
    }
}

extension SavedRecipesController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        recipeID = Int(model[indexPath.row].id)
        self.performSegue(withIdentifier: "goToRecipeDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRecipeDetails" {
            let destinationVC = segue.destination as! RecipeDetailsViewController
            destinationVC.recipeID = recipeID
        }
    }
}
