//
//  RecipeListView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/2/24.
//

import CoreData
import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var vm: RecipeListViewModel
    @State private var searchText = ""
    @State private var selectedRecipe: RecipeEntity?
    //@State private var recipes: FetchedResults<RecipeEntity>
    //@Environment(\.managedObjectContext) private var viewContext
    
    //    @FetchRequest(
    //        sortDescriptors: [NSSortDescriptor(keyPath: \RecipeEntity.title, ascending: true)],
    //        animation: .default)
    
    
    var groupedByDate: [Date: [RecipeEntity]] {
        let calendar = Calendar.current
        return Dictionary(grouping: vm.recipes) { recipeEntity in
            let dateComponents = calendar.dateComponents([.year, .month, .day],
                                                         from: recipeEntity.timestamp!)
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    
    var headers: [Date] {
        groupedByDate.map { $0.key }.sorted(by: { $0 > $1 })
    }
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedRecipe) {
                ForEach(headers, id: \.self) { header in
                    Section(header: Text(header, style: .date)) {
                        ForEach(groupedByDate[header]!) { recipe in
                            NavigationLink(value: recipe) {
                                ListCellView(recipe: recipe)
                            }
                        }
                        
                        .onDelete(perform: { indexSet in
                            deleteRecipe(in: header, at: indexSet)
                        })
                    }
                }
            }
            .id(UUID())
            .navigationTitle("Recipes")
            .searchable(text: $searchText)
            .onChange(of:searchText) {
                // MARK: Core Data Search
                vm.searchRecipes(with: searchText)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                    Button {
                        createNewRecipe()
                        
                    } label: {
                        Image(systemName: "plus")
                            .foregroundColor(Color(UIColor.systemBlue))
                    }
                }
            }
            
        } detail: {
            if let selectedRecipe {
                RecipeView(recipe: selectedRecipe)
            } else {
                Text("Select a Recipe.")
            }
            
        }
    }
    
    //MARK: Core Data Operations
    
    private func createNewRecipe() {
        selectedRecipe = nil
        selectedRecipe = vm.createRecipe()
    }
    
    private func deleteRecipe(in header: Date, at offsets: IndexSet) {
        offsets.forEach { index in
            if let recipeToDelete = groupedByDate[header]?[index] {
                
                if recipeToDelete == selectedRecipe {
                    selectedRecipe = nil
                }
                
                vm.deleteRecipe(recipeToDelete)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let context = PersistenceController.preview.container.viewContext
//        return ContentView().environment(\.managedObjectContext, context)
//    }
//}
