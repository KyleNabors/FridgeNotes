//
//  RecipeView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//


import SwiftUI
import CoreData

struct RecipeView: View {
    @EnvironmentObject var vm: RecipeViewModel
    @State private var recipeTitle: String = ""
    @State private var recipeInstructions: String = ""
    @State private var showNewRecipeIngredientForm: Bool = false
    @ObservedObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        VStack {
            TextField("Enter title", text: $recipeTitle)
                .multilineTextAlignment(.center)
                .font(.largeTitle)
                .bold()
                .padding()
                .onAppear {
                    self.recipeTitle = vm.recipe.title ?? ""
                    self.recipeInstructions = vm.recipe.steps ?? ""
                }

            Section(header: Text("Ingredients")) {
                List {
                    ForEach(vm.recipe.sortedIngredientsArray, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient.name ?? "")
                            Spacer()
                            Text("\(ingredient.amount, specifier: "%.2f") \(ingredient.measurement ?? "")")
                        }
                    }
                    .onDelete(perform: deleteIngredients)
                }
            }

            Spacer()

            Section(header: Text("Recipe")) {
                TextEditor(text: $recipeInstructions)
                    .lineSpacing(2)
                    .cornerRadius(10)
                    .autocapitalization(.words)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.blue, lineWidth: 2)
                            .padding()
                    )
            }

            if !keyboardResponder.isKeyboardVisible {
                Button(action: {
                    showNewRecipeIngredientForm = true
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
        }
        .sheet(isPresented: $showNewRecipeIngredientForm) {
            NewRecipeIngredientView(recipe: vm.recipe, isPresented: $showNewRecipeIngredientForm)
                .environmentObject(vm)
        }
        .onDisappear {
            vm.updateRecipe(title: recipeTitle, content: recipeInstructions)
        }
    }

    private func deleteIngredients(at offsets: IndexSet) {
        for index in offsets {
            let ingredient = vm.recipe.sortedIngredientsArray[index]
            vm.deleteIngredient(ingredient)
        }
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let previewRecipe = RecipeEntity(context: context)
        previewRecipe.title = "Sample Recipe"
        previewRecipe.date = Date()
        previewRecipe.steps = "Sample content"

        for j in 1...3 {
            let newIngredient = IngredientEntity(context: context)
            newIngredient.name = "Sample Ingredient \(j)"
            newIngredient.amount = Double(j)
            newIngredient.measurement = "grams"
            newIngredient.recipeIngredient = previewRecipe
        }

        return RecipeView()
            .environmentObject(RecipeViewModel(recipe: previewRecipe, context: context))
            .environment(\.managedObjectContext, context)
    }
}
