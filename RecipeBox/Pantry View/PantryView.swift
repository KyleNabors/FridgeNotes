//
//  PantryView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//

import SwiftUI
import CoreData

struct PantryView: View {
    @EnvironmentObject var vm: PantryViewModel
    @State private var showNewIngredientForm: Bool = false
    @State private var newIngredientName: String = ""
    @State private var newIngredientAmount: String = ""
    @State private var newIngredientMeasurement: String = ""

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(vm.ingredients, id: \.self) { ingredient in
                        HStack {
                            Text(ingredient.name ?? "")
                            Spacer()
                            Text("\(ingredient.amount, specifier: "%.2f") \(ingredient.measurement ?? "")")
                        }
                    }
                    .onDelete(perform: deleteIngredients)
                }
                .navigationTitle("Pantry")
                .navigationBarItems(trailing: Button(action: {
                    showNewIngredientForm.toggle()
                }) {
                    Image(systemName: "plus")
                })
            }
            .sheet(isPresented: $showNewIngredientForm) {
                VStack {
                    TextField("Ingredient Name", text: $newIngredientName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Amount", text: $newIngredientAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    TextField("Measurement", text: $newIngredientMeasurement)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    Button("Add Ingredient") {
                        if let amount = Double(newIngredientAmount) {
                            vm.addIngredient(name: newIngredientName, amount: amount, measurement: newIngredientMeasurement)
                            showNewIngredientForm = false
                        }
                    }
                    .padding()
                }
                .padding()
            }
        }
    }

    private func deleteIngredients(at offsets: IndexSet) {
        for index in offsets {
            let ingredient = vm.ingredients[index]
            vm.deleteIngredient(ingredient)
        }
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return PantryView()
            .environmentObject(PantryViewModel(context: context))
            .environment(\.managedObjectContext, context)
    }
}
