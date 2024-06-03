//
//  ContentView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//


import SwiftUI

struct ContentView: View {
    @EnvironmentObject var recipeListViewModel: RecipeListViewModel

    var body: some View {
        Group {
            if recipeListViewModel.isDataLoaded {
                RecipeListView()
                    .environmentObject(recipeListViewModel)
            } else {
                ProgressView("Loading...")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(RecipeListViewModel(manager: PersistenceController.preview))
    }
}
