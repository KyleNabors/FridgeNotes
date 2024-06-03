//
//  PantryView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//

import SwiftUI
import CoreData

struct PantryView: View {
    @FetchRequest(
        entity: PantryItemEntity.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PantryItemEntity.name, ascending: true)]
    ) var pantryItems: FetchedResults<PantryItemEntity>

    var body: some View {
        NavigationView {
            List {
                ForEach(pantryItems, id: \.self) { item in
                    Text(item.name ?? "Unnamed Item")
                }
            }
            .navigationBarTitle("Pantry")
            .navigationBarItems(trailing:
                NavigationLink(destination: NewPantryItemView()) {
                    Image(systemName: "plus")
                }
            )
        }
    }
}
