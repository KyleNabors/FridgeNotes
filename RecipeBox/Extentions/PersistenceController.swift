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

        // Create some dummy data for preview purposes
        let newRecipe = RecipeEntity(context: viewContext)
        newRecipe.title = "Sample Recipe"
        newRecipe.content = "Sample Instructions"
        newRecipe.timestamp = Date()
        newRecipe.id = UUID()

        let newIngredient = IngredientEntity(context: viewContext)
        newIngredient.name = "Sample Ingredient"
        newIngredient.amount = 1.0
        newIngredient.measurement = "grams"
        newIngredient.step = 1
        newIngredient.recipe = newRecipe

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
