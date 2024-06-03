//
//  RecipeViewModel.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/2/24.
//

import SwiftUI
import CoreData

class RecipeViewModel: ObservableObject {
    @Published var recipe: RecipeEntity
    private var context: NSManagedObjectContext

    init(recipe: RecipeEntity? = nil, context: NSManagedObjectContext) {
        self.context = context
        if let recipe = recipe {
            self.recipe = recipe
        } else {
            // Create a new RecipeEntity if none is provided
            var newRecipe = RecipeEntity(context: context)
            newRecipe.title = ""
            newRecipe.date = Date()
            newRecipe.steps = ""
            self.recipe = newRecipe = ""
        }
    }

    func updateRecipe(title: String, content: String) {
        recipe.title = title
        recipe.steps = content
        saveContext()
    }

    func addIngredient(name: String, amount: Double, measurement: String) {
        let newIngredient = IngredientEntity(context: context)
        newIngredient.name = name
        newIngredient.amount = amount
        newIngredient.measurement = measurement
        saveContext()
    }

    func deleteIngredient(_ ingredient: IngredientEntity) {
        context.delete(ingredient)
        saveContext()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    var sortedIngredientsArray: [IngredientEntity] {
        let ingredientsArray = recipeIngredient.ingredients?.allObjects as? [IngredientEntity] ?? []
        return ingredientsArray.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
}
