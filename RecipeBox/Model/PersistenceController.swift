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
        addSampleData(to: viewContext)

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
                newRecipe.addToIngredientRecipe(newIngredient) // Use the correct accessor
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
    
    private func checkAndAddSampleData() {
           let context = container.viewContext
           let fetchRequest: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
           
           do {
               let count = try context.count(for: fetchRequest)
               if count == 0 {
                   PersistenceController.addSampleData(to: context)
               }
           } catch {
               fatalError("Failed to fetch count of recipes: \(error)")
           }
       }

       private static func addSampleData(to context: NSManagedObjectContext) {
           let sampleRecipe = RecipeEntity(context: context)
           sampleRecipe.title = "Sample Recipe"
           sampleRecipe.date = Date()
           sampleRecipe.steps = "These are the sample steps for the sample recipe."

           for i in 1...3 {
               let ingredient = IngredientEntity(context: context)
               ingredient.name = "Sample Ingredient \(i)"
               ingredient.amount = Double(i)
               ingredient.measurement = "grams"
               sampleRecipe.addToIngredientRecipe(ingredient)
           }

           do {
               try context.save()
           } catch {
               let nsError = error as NSError
               fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
           }
       }
   }
