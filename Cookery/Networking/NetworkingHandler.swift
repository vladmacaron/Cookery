//
//  NetworkingHandler.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 18.05.21.
//

import UIKit

class NetwokringHandler {
    private static let apiKey = "87a44ca0b30d4fba8aab771763b898a8"
    enum Endpoint {
        private static let baseURL = "https://api.spoonacular.com"
        case randomRecipes
        case foodIngredientsAutocomplete
        case detailedRecipe(id: String)
        case recipeAutocomplete
        case recipeByIngredients
        
        fileprivate var stringURL: String {
            switch self {
            case .randomRecipes: return Endpoint.baseURL.appending("/recipes/random")
            case .foodIngredientsAutocomplete: return Endpoint.baseURL.appending("/food/ingredients/autocomplete")
            case .detailedRecipe(let id): return Endpoint.baseURL.appending("/recipes/\(id)/information")
            case .recipeAutocomplete: return
                Endpoint.baseURL
                .appending("/recipes/autocomplete")
            case .recipeByIngredients: return Endpoint.baseURL.appending("/recipes/complexSearch")
            }
        }
    }
    
    static func getRandomRecipes(withLimit limit: Int,
                                 completion: @escaping((Result<RandomRecipeQuery, Error>) -> Void)){
        var queryParameters = apiQueryParameter
        queryParameters["number"] = "\(limit)"
        queryParameters["intolerances"] = intolerances
        NetworkingManager.shared.request(forUrl: Endpoint.randomRecipes.stringURL,
                                         httpMethod: .get,
                                         queryParameters: queryParameters,
                                         completion: completion)
    }
    
    static func getIngredientsForQuery(_ query: String,
                                       completion: @escaping (Result<[Ingredient], Error>) -> Void) {
        var queryParameters = apiQueryParameter
        queryParameters["query"] = "\(query)"
        NetworkingManager.shared.request(forUrl: Endpoint.foodIngredientsAutocomplete.stringURL,
                                         httpMethod: .get,
                                         queryParameters: queryParameters,
                                         completion: completion)
    }
    
    static func getRecipesForQuery(_ query: String,
                                       completion: @escaping (Result<[Recipe], Error>) -> Void) {
        var queryParameters = apiQueryParameter
        queryParameters["query"] = "\(query)"
        NetworkingManager.shared.request(forUrl: Endpoint.recipeAutocomplete.stringURL,
                                         httpMethod: .get,
                                         queryParameters: queryParameters,
                                         completion: completion)
    }
    
    static func getDetailedRecipe(with id: Int,
                                  completion: @escaping (Result<DetailedRecipe, Error>) -> Void)  {
        var queryParameters = apiQueryParameter
        queryParameters["includeNutrition"] = "true"
        NetworkingManager.shared.request(forUrl: Endpoint.detailedRecipe(id: "\(id)").stringURL,
                                         httpMethod: .get,
                                         queryParameters: queryParameters,
                                         completion: completion)
    }
    
    static func getRecipesForIngredients(_ type: String?,_ duration: String?,_ calories: String?,_ protein: String?,
                                         _ carbs: String?,_ fat: String?,
                                       completion: @escaping (Result<RecipeWrapper, Error>) -> Void) {
        var queryParameters = apiQueryParameter
        queryParameters["includeIngredients"] = ingredients
        queryParameters["intolerances"] = intolerances
        if let type = type {
            queryParameters["type"] = type
        }
        if let calories = calories {
            queryParameters["maxCalories"] = "\(calories)"
        }
        if let duration = duration {
            queryParameters["maxReadyTime"] = "\(duration)"
        }
        if let protein = protein {
            queryParameters["maxProtein"] = "\(protein)"
        }
        if let carbs = carbs {
            queryParameters["maxCarbs"] = "\(carbs)"
        }
        if let fat = fat {
            queryParameters["maxFat"] = "\(fat)"
        }
        queryParameters["number"] = "20"
        NetworkingManager.shared.request(forUrl: Endpoint.recipeByIngredients.stringURL,
                                         httpMethod: .get,
                                         queryParameters: queryParameters,
                                         completion: completion)
    }
    
    static func loadImageURL(_ imageURL: String, into imageView: UIImageView) {
        DispatchQueue.global().async { [weak imageView] in
            if let url = URL(string: imageURL),
               let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        imageView?.image = image
                    }
                }
            }
        }
    }
    
    private static var apiQueryParameter: [String: String] {
        return ["apiKey": apiKey]
    }
    
    private static var intolerances: String {
        let intolerances: [Intolerance] = StorageManager.shared.getAllItems()
        return String(intolerances.reduce("", { result, intolerance in
            result + "," + intolerance.name
        }).dropFirst())
    }
    
    private static var ingredients: String {
        let ingredients: [Ingredient] = StorageManager.shared.getAllItems()
        return String(ingredients.reduce("", { result, ingredient in
            result + "," + ingredient.name
        }).dropFirst())
    }
}
