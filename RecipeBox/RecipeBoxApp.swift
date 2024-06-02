//
//  RecipeBoxApp.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import SwiftUI

@main
struct RecipeBoxApp: App {
    let coreDataManager = CoreDataManager()
    @StateObject var recipeListViewModel: RecipeListViewModel

        init() {
            let viewModel = RecipeListViewModel(manager: coreDataManager)
            _recipeListViewModel = StateObject(wrappedValue: viewModel)
        }


    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(recipeListViewModel)
        }
    }
}
