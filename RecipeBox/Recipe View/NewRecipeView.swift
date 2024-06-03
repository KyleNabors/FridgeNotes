//
//  NewRecipeView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//

import SwiftUI

struct NewRecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var recipeName: String = ""

    var body: some View {
        Form {
            Section(header: Text("Recipe Name")) {
                TextField("Enter recipe name", text: $recipeName)
            }

            Button("Save") {
                let newRecipe = RecipeEntity(context: viewContext)
                newRecipe.title = recipeName

                do {
                    try viewContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
        .navigationBarTitle("Add Recipe", displayMode: .inline)
    }
}
