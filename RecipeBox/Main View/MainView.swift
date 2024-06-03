//
//  ContentView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/3/24.
//


import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            RecipeListView()
                .tabItem {
                    Image(systemName: "book")
                    Text("Recipes")
                }
            
            PantryView()
                .tabItem {
                    Image(systemName: "cart")
                    Text("Pantry")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
