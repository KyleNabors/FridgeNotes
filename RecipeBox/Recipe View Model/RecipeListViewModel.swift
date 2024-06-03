//
//  RecipeViewModel.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import Foundation
import CoreData

class RecipeListViewModel: ObservableObject {
    @Published var recipes: [RecipeEntity] = []
    @Published var isDataLoaded = false
    var viewContext: NSManagedObjectContext

    init(manager: PersistenceController = PersistenceController.shared) {
        self.viewContext = manager.container.viewContext
        loadData()
    }

    private func loadData() {
        DispatchQueue.global().async { [weak self] in
            self?.fetchRecipes()
            DispatchQueue.main.async {
                self?.isDataLoaded = true
            }
        }
    }

    func fetchRecipes() {
        let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
        do {
            let fetchedRecipes = try viewContext.fetch(request)
            DispatchQueue.main.async {
                self.recipes = fetchedRecipes
            }
        } catch {
            print("Failed to fetch recipes: \(error.localizedDescription)")
        }
    }

    func createRecipe() -> RecipeEntity {
        let newRecipe = RecipeEntity(context: viewContext)
        newRecipe.date = Date()
        saveContext()
        fetchRecipes()
        return newRecipe
    }

    func deleteRecipe(_ recipe: RecipeEntity) {
        viewContext.delete(recipe)
        saveContext()
        fetchRecipes()
    }

    func searchRecipes(with searchText: String) {
        if searchText.isEmpty {
            fetchRecipes()
        } else {
            let request: NSFetchRequest<RecipeEntity> = RecipeEntity.fetchRequest()
            request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
            do {
                let fetchedRecipes = try viewContext.fetch(request)
                DispatchQueue.main.async {
                    self.recipes = fetchedRecipes
                }
            } catch {
                print("Failed to search recipes: \(error.localizedDescription)")
            }
        }
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
