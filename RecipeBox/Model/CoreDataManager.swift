//
//  CoreDataManager.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "RecipesContainer")
    }

    func loadCoreData(completion: @escaping (Bool) -> Void) {
        container.loadPersistentStores { description, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Core Data loading error: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }
}
