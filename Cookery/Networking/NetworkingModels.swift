//
//  NetworkingModels.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 18.05.21.
//

import Foundation

struct RandomRecipeQuery: Decodable {
    let recipes: [Recipes]
}

struct RecipeWrapper: Decodable {
    let results: [Recipe]
}

struct Recipe: Decodable {
    let id: Int64
    let title: String
    let imageType: String
    
    func imageURL() -> String {
        return "https://spoonacular.com/recipeImages/\(id)-556x370.\(imageType)"
    }
}


struct Recipes: Decodable {
    let id: Int64
    let title: String
    let image: String
    let dishTypes: [String]
}

struct DetailedRecipe: Codable, StorageMainainable {
    static var key = "Recipe"
    
    struct AnalyzedInstructions: Codable {
        struct Step: Codable {
            let number: Int
            let step: String
            let ingredients: [Ingredient]
            let equipment: [Equipment]
        }
        let steps: [Step]
    }
    
    struct Nutrition: Codable {
        struct Nutrient: Codable {
            let name: String
            let title: String
            let unit: String
            let amount: Double
        }
        let nutrients: [Nutrient]
    }
    
    struct NutritionDescriptor {
        let caloriesLabel: String
        let proteinLabel: String
        let proteinRatio: Double
        let fatsLabel: String
        let fatsRatio: Double
        let carbsLabel: String
        let carbsRatio: Double
    }
    
    let id: Int64
    let title: String
    let image: String
    let dishTypes: [String]
    let summary: String
    let pricePerServing: Double
    let spoonacularScore: Double
    let analyzedInstructions: [AnalyzedInstructions]
    let nutrition: Nutrition
    let readyInMinutes: Int
    let extendedIngredients: [Ingredient]
    
    var nutritionDescriptor: NutritionDescriptor? {
        guard let proteinNutrient = nutrition.nutrients.first(where: { $0.name == "Protein" }),
              let fatsNutrient = nutrition.nutrients.first(where: { $0.name == "Fat" }),
              let carbsNutrient = nutrition.nutrients.first(where: { $0.name == "Carbohydrates" }),
              let caloriesNutrient = nutrition.nutrients.first(where: { $0.name == "Calories" }) else {
            return nil
        }
        let totalDistribution = [proteinNutrient, fatsNutrient, carbsNutrient].map({ $0.amount }).reduce(0, +)
        return NutritionDescriptor(caloriesLabel: "\(Int(caloriesNutrient.amount)) \(caloriesNutrient.unit)",
                                   proteinLabel: "Protein \(Int(proteinNutrient.amount))\(proteinNutrient.unit)",
                                   proteinRatio: proteinNutrient.amount / totalDistribution,
                                   fatsLabel: "Fat \(Int(fatsNutrient.amount))\(fatsNutrient.unit)",
                                   fatsRatio: fatsNutrient.amount / totalDistribution,
                                   carbsLabel: "Carbs \(Int(carbsNutrient.amount))\(carbsNutrient.unit)",
                                   carbsRatio: carbsNutrient.amount / totalDistribution)
    }

    var equipment: [Equipment] {
        guard let analyzedInstructions = analyzedInstructions.first else {
            return []
        }

        return analyzedInstructions.steps.map({ $0.equipment }).reduce([], { $0 + $1 })
    }
    
    static func == (lhs: DetailedRecipe, rhs: DetailedRecipe) -> Bool {
        return lhs.id == rhs.id
    }
}

struct Ingredient: StorageMainainable {
    static var key = "Ingredients"
    
    let id: Int64?
    let name: String
    let image: String
    let originalName: String?
    let localizedName: String?
    
    enum Size: Int {
        case small = 100
        case medium = 250
        case large = 500
    }
    
    func imageURL(for size: Size) -> String {
        return "https://spoonacular.com/cdn/ingredients_\(size.rawValue)x\(size.rawValue)/\(image)"
    }
}
//changes for later to make equipment storable
struct Equipment: Codable { //, StorageMainainable
  // static var key = "Equipment"
 
    let id: Int64
    let name: String
    let image: String
    let localizedName: String
    
    enum Size: Int {
        case small = 100
        case medium = 250
        case large = 500
    }
    
    func imageURL(for size: Size) -> String {
        return "https://spoonacular.com/cdn/equipment_\(size.rawValue)x\(size.rawValue)/\(image)"
    }
}
