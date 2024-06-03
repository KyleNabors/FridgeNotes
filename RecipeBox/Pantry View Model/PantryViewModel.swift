//
//  PantryViewModel.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//

import Foundation
import SwiftUI
import CoreData

class PantryViewModel: ObservableObject {
    @Published var ingredients: [IngredientEntity] = []
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchIngredients()
    }

    func fetchIngredients() {
        let request: NSFetchRequest<IngredientEntity> = IngredientEntity.fetchRequest()
        do {
            ingredients = try context.fetch(request)
        } catch {
            print("Failed to fetch ingredients: \(error)")
        }
    }

    func addIngredient(name: String, amount: Double, measurement: String) {
        let newIngredient = IngredientEntity(context: context)
        newIngredient.name = name
        newIngredient.amount = amount
        newIngredient.measurement = measurement
        saveContext()
        fetchIngredients()
    }

    func deleteIngredient(_ ingredient: IngredientEntity) {
        context.delete(ingredient)
        saveContext()
        fetchIngredients()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
}
