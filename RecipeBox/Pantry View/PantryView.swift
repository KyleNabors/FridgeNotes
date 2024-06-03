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

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(vm.items, id: \.self) { item in
                        HStack {
                            Text(item.name ?? "")
                            Spacer()
                            Text("\(item.amount, specifier: "%.2f") \(item.measurement ?? "")")
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
                            NewPantryItemView(isPresented: $showNewIngredientForm)
                                .environment(\.managedObjectContext, vm.managedObjectContext)
                        }
        }
    }

    private func deleteIngredients(at offsets: IndexSet) {
        for index in offsets {
            let item = vm.items[index]
            vm.deleteItem(item)
        }
    }
}

struct PantryView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        return PantryView()
            .environment(\.managedObjectContext, context)
            .environmentObject(PantryViewModel(context: context))
    }
}
