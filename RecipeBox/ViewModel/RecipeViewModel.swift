//
//  RecipeViewModel.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/2/24.
//

import Foundation
import CoreData

class RecipeViewModel: ObservableObject {
    @Published var recipe: RecipeEntity
    private var viewContext: NSManagedObjectContext

    init(recipe: RecipeEntity, context: NSManagedObjectContext) {
        self.recipe = recipe
        self.viewContext = context
    }

    func updateRecipe(title: String, content: String) {
        recipe.title = title
        recipe.content = content
        saveContext()
    }

    func deleteIngredient(_ ingredient: IngredientEntity) {
        viewContext.delete(ingredient)
        saveContext()
    }

    private func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}
