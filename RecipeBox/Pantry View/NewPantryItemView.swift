//
//  NewPantryItemView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//

import SwiftUI
import CoreData

struct NewPantryItemView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var isPresented: Bool

    @State private var name: String = ""
    @State private var amount: String = ""
    @State private var selectedUnit: String = "grams"
    
    let units = ["grams", "oz", "ml", "cups"]

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Item")) {
                    TextField("Name", text: $name)
                    TextField("Amount", text: $amount)
                        .keyboardType(.decimalPad)
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit).tag(unit)
                        }
                    }
                }
                Section {
                    Button(action: addIngredient) {
                        Text("Add Item")
                    }
                }
            }
            .navigationBarTitle("New Item", displayMode: .inline)
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }

    private func addIngredient() {
        let newIngredient = PantryItemEntity(context: viewContext)
        newIngredient.name = name
        newIngredient.amount = Double(amount) ?? 0.0
        newIngredient.measurement = selectedUnit

        do {
            try viewContext.save()
            isPresented = false
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct NewPantryItemView_Previews: PreviewProvider {
    static var previews: some View {
        NewPantryItemView(isPresented: .constant(true))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
