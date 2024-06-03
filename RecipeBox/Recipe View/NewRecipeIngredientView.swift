//
//  NewIngredientView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/2/24.
//


import SwiftUI

struct NewRecipeIngredientView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var ingredientName: String = ""
    @State private var ingredientQuantity: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var selectedMeasurement: String = "grams"
    
    @ObservedObject var recipe: RecipeEntity
    @Binding var isPresented: Bool

    var body: some View {
        Form {
            Section(header: Text("Ingredient Name")) {
                TextField("Name", text: $ingredientName)
            }
            Section(header: Text("Amount Needed in Recipe")) {
                TextField("Quantity", text: $ingredientQuantity)
                    .keyboardType(.decimalPad)
            }
            Section(header: Text("Measurement Units")) {
                Picker("Measurement", selection: $selectedMeasurement) {
                    ForEach(["grams", "oz", "ml", "cups"], id: \.self) {
                        Text($0)
                    }
                }
            }
        }
        .navigationBarItems(trailing: Button("Save") {
            saveIngredient()
        })
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .navigationTitle("New Ingredient")
        
        Button(action: saveIngredient) {
            Text("Add Ingredient")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding()
    }

    private func saveIngredient() {
        guard !ingredientName.isEmpty, !ingredientQuantity.isEmpty, let amount = Double(ingredientQuantity) else {
            alertMessage = "Name and Quantity cannot be empty."
            showAlert = true
            return
        }

        let newIngredient = IngredientEntity(context: viewContext)
        newIngredient.name = ingredientName
        newIngredient.amount = amount
        newIngredient.measurement = selectedMeasurement
        newIngredient.recipeIngredient = recipe

        do {
            try viewContext.save()
            isPresented = false
        } catch {
            let nsError = error as NSError
            alertMessage = "Unresolved error \(nsError), \(nsError.userInfo)"
            showAlert = true
        }
    }
}

struct NewIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        NewRecipeIngredientView(recipe: RecipeEntity(), isPresented: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
