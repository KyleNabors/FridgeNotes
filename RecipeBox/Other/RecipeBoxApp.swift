//
//  RecipeBoxApp.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//

//
//  RecipeBoxApp.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import SwiftUI

@main
struct RecipeBoxApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(PantryViewModel(context: persistenceController.container.viewContext))
                .environmentObject(RecipeViewModel(context: persistenceController.container.viewContext))
                .environmentObject(RecipeListViewModel()) // Add this line
        }
    }
}
