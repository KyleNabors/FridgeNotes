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
            let entityDescription = NSEntityDescription.entity(forEntityName: "RecipeEntity", in: context)!
            self.recipe = RecipeEntity(entity: entityDescription, insertInto: context)
            self.recipe.title = ""
            self.recipe.date = Date()
            self.recipe.steps = ""
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
        newIngredient.recipeIngredient = recipe
        recipe.addToIngredients(newIngredient)
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
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }

    var sortedIngredientsArray: [IngredientEntity] {
        let ingredientSet = recipe.ingredientRecipe as? Set<IngredientEntity> ?? []
        let ingredientArray = Array(ingredientSet)
        return ingredientArray.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
}

