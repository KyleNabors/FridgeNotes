//
//  RecipeListView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//

import CoreData
import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var vm: RecipeListViewModel
    @State private var searchText = ""
    @State private var selectedRecipe: RecipeEntity?

    var sortedRecipes: [RecipeEntity] {
        vm.recipes.sorted { (recipe1, recipe2) -> Bool in
            guard let name1 = recipe1.title, let name2 = recipe2.title else {
                return false
            }
            return name1.localizedCaseInsensitiveCompare(name2) == .orderedAscending
        }
    }

    var body: some View {
        NavigationStack {
            List(selection: $selectedRecipe) {
                ForEach(sortedRecipes, id: \.self) { recipe in
                    NavigationLink(destination: RecipeView()
                                    .environmentObject(RecipeViewModel(recipe: recipe, context: vm.viewContext))) {
                        RecipeListCellView(recipe: recipe)
                    }
                }
                .onDelete(perform: deleteRecipe)
            }
            .navigationTitle("Recipes")
            .searchable(text: $searchText)
            .onChange(of: searchText) {
                vm.searchRecipes(with: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        createNewRecipe()
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(Color(.systemBlue))
                    }
                }
            }

            if selectedRecipe == nil {
                Text("Select a Recipe.")
            }
        }
        .onAppear {
            if selectedRecipe == nil, let firstRecipe = vm.recipes.first {
                selectedRecipe = firstRecipe
            }
        }
    }

    private func createNewRecipe() {
        selectedRecipe = nil
        selectedRecipe = vm.createRecipe()
    }

    private func deleteRecipe(at offsets: IndexSet) {
        offsets.forEach { index in
            let recipeToDelete = sortedRecipes[index]
            if recipeToDelete == selectedRecipe {
                selectedRecipe = nil
            }
            vm.deleteRecipe(recipeToDelete)
        }
    }
}

import SwiftUI

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewContext = PersistenceController.preview.container.viewContext
        return RecipeListView()
            .environmentObject(RecipeListViewModel(manager: PersistenceController.preview))
            .environment(\.managedObjectContext, viewContext)
    }
}
