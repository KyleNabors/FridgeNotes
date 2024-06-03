//
//  PersistenceController.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext

        // Create 10 dummy recipes with ingredients and instructions for preview purposes
        for i in 1...10 {
            let newRecipe = RecipeEntity(context: viewContext)
            newRecipe.title = "Sample Recipe \(i)"
            newRecipe.content = "Sample Instructions for Recipe \(i)"
            newRecipe.timestamp = Date()
            newRecipe.id = UUID()

            // Create 3 ingredients for each recipe
            for j in 1...3 {
                let newIngredient = IngredientEntity(context: viewContext)
                newIngredient.name = "Sample Ingredient \(j)"
                newIngredient.amount = Double(j)
                newIngredient.measurement = "grams"
                newIngredient.step = Int16(j)  // Convert Int to Int16
                newIngredient.recipe = newRecipe
            }
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }

        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RecipesContainer")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
