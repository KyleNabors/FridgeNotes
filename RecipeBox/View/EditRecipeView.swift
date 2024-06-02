//
//  EditRecipeView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import SwiftUI
import CoreData

struct EditRecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @Binding var recipe: RecipeEntity

    @State private var recipeTitle: String = ""
    @State private var recipeInstructions: String = ""

    var body: some View {
        Form {
            Section(header: Text("Title")) {
                TextField("Enter title", text: $recipeTitle)
                    .onAppear {
                        self.recipeTitle = recipe.title ?? ""
                    }
            }
            Section(header: Text("Instructions")) {
                TextEditor(text: $recipeInstructions)
                    .onAppear {
                        self.recipeInstructions = recipe.content ?? ""
                    }
            }
            NavigationLink(destination: IngredientsTableView(recipe: $recipe)) {
                Text("Edit Ingredients")
            }
            Button(action: saveRecipe) {
                Text("Save Recipe")
            }
        }
        .navigationTitle("Edit Recipe")
    }

    private func saveRecipe() {
        recipe.title = recipeTitle
        recipe.content = recipeInstructions
        recipe.timestamp = Date()

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let previewRecipe = RecipeEntity(context: context)
        return EditRecipeView(recipe: .constant(previewRecipe)).environment(\.managedObjectContext, context)
    }
}
