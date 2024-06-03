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

        // Create dummy pantry ingredients for preview purposes
        for i in 1...10 {
            let newPantryItem = PantryItemEntity(context: viewContext)
            newPantryItem.name = "Sample Pantry Ingredient \(i)"
            newPantryItem.amount = Double(i)
            newPantryItem.measurement = "grams"
        }

        // Create some dummy recipes with ingredients
        for i in 1...5 {
            let newRecipe = RecipeEntity(context: viewContext)
            newRecipe.title = "Sample Recipe \(i)"
            newRecipe.steps = "Sample Instructions for Recipe \(i)"
            newRecipe.date = Date()

            for j in 1...3 {
                let newIngredient = IngredientEntity(context: viewContext)
                newIngredient.name = "Sample Ingredient \(j)"
                newIngredient.amount = Double(j)
                newIngredient.measurement = "grams"
                newRecipe.addToIngredients(newIngredient) // Use the generated accessor
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
        container = NSPersistentContainer(name: "RecipeBoxContainer")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
