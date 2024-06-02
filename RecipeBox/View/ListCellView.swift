//
//  ListCellView.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import SwiftUI

struct ListCellView: View {
    var recipe: RecipeEntity
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            Text(recipe.title ?? "New Recipe")
                .lineLimit(1)
                .font(.title3)
                .fontWeight(.bold)
            Text(recipe.content ?? "No context available")
                .lineLimit(1)
                .fontWeight(.light)
        }
    }
}


