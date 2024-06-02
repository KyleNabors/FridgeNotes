//
//  RecipeViewModel.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import Foundation
import CoreData

class RecipeListViewModel: ObservableObject {

    let manager: CoreDataManager
    @Published var recipes: [RecipeEntity] = []
    @Published var isDataLoaded = false

    init(manager: CoreDataManager) {
        self.manager = manager
        loadData()
    }
    
    func loadData() {
        manager.loadCoreData { [weak self] result in
            DispatchQueue.main.async {
                self?.isDataLoaded = result
                if result {
                    self?.fetchRecipes()
                }
            }
        }
    }

    func fetchRecipes(with searchText: String = "")  {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        
        if !searchText.isEmpty {
            request.predicate = NSPredicate(format: "title CONTAINS %@", searchText)
        }

        do {
            recipes = try manager.container.viewContext.fetch(request)
        } catch {
            print("Error fetching recipes: \(error)")
        }
    }

    func createRecipe() -> RecipeEntity {
        let newRecipe = RecipeEntity(context: manager.container.viewContext)
        newRecipe.id = UUID()
        newRecipe.timestamp = Date()
        saveContext()
        fetchRecipes() // Refresh recipess list
        
        return newRecipe
    }

    func deleteRecipe(_ recipe: RecipeEntity) {
        manager.container.viewContext.delete(recipe)
        saveContext()
        fetchRecipes() // Refresh recipes list
    }

    func updateRecipe(_ recipe: RecipeEntity, title: String, content: String) {
        recipe.title = title
        recipe.content = content
        saveContext()
        fetchRecipes() // Refresh recipes list
    }
    
    func searchRecipes(with searchText: String) {
        fetchRecipes(with: searchText)
    }

    private func saveContext() {
        do {
            try manager.container.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
