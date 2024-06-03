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
    @Published var items: [PantryItemEntity] = []
    private var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
        fetchItems()
    }

    func fetchItems() {
        let request: NSFetchRequest<PantryItemEntity> = PantryItemEntity.fetchRequest()
        do {
            items = try context.fetch(request)
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    func addItem(name: String, amount: Double, measurement: String) {
        let newItem = PantryItemEntity(context: context)
        newItem.name = name
        newItem.amount = amount
        newItem.measurement = measurement
        saveContext()
        fetchItems()
    }

    func deleteItem(_ item: PantryItemEntity) {
        context.delete(item)
        saveContext()
        fetchItems()
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
    }
    
    var managedObjectContext: NSManagedObjectContext {
           return context
       }
}
