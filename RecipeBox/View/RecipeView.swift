//
//  RecipeView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import SwiftUI
import CoreData

struct RecipeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State var recipe: RecipeEntity

    @State private var showEditRecipeView: Bool = false
    @State private var recipeInstructions: String = ""
    @State private var showNewIngredientForm: Bool = false
    @State private var recipeTitle: String = ""

    var body: some View {
        VStack {
            TextField("Enter title",
                      text: $recipeTitle
            )
            .multilineTextAlignment(.center)
            .font(.largeTitle)
                .bold()
                .onAppear {
                    self.recipeTitle = recipe.title ?? ""
                }

            Section(header: Text("Ingredients")) {
                List {
                    ForEach(recipe.sortedIngredientsArray, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient.name ?? "")
                            Spacer()
                            Text("\(ingredient.amount, specifier: "%.2f") \(ingredient.measurement ?? "")")
                        }
                    }
                }
            }
            
            
            Spacer()
            
            Section(header: Text("Recipe")) {
                TextEditor(text: $recipeInstructions)
                    .onAppear {
                        self.recipeInstructions = recipe.content ?? ""
                    }
                    .lineSpacing(2)
                    .cornerRadius(10)
                    .autocapitalization(.words)
                    .padding()
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.blue, lineWidth: 2)
                        .padding())
            }

            Button(action: {
                showNewIngredientForm = true
            }) {
                Text("Add New Ingredient")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            
        }
        .padding(.top, -50.0)
        .sheet(isPresented: $showNewIngredientForm) {
            NewIngredientView(recipe: recipe, isPresented: $showNewIngredientForm)
                .environment(\.managedObjectContext, viewContext)
        }
        .onDisappear() {
            saveRecipe()
        }
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

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let previewRecipe = RecipeEntity(context: context)
        previewRecipe.title = "Sample Recipe"
        previewRecipe.timestamp = Date()
        previewRecipe.content = "Sample content"

        return RecipeView(recipe: previewRecipe).environment(\.managedObjectContext, context)
    }
}
