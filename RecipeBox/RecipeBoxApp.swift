//
//  RecipeBoxApp.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import SwiftUI

@main
struct RecipeBoxApp: App {
    @StateObject private var recipeListViewModel = RecipeListViewModel(manager: PersistenceController.shared)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipeListViewModel)
        }
    }
}
