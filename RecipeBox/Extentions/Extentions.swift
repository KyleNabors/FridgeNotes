//
//  Extentions.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/1/24.
//

import Foundation
import SwiftUI
import CoreData

// MARK: View

//extension View {
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
//}
//



extension RecipeEntity {
    var sortedIngredientsArray: [IngredientEntity] {
        let set = ingredients as? Set<IngredientEntity> ?? []
        return set.sorted {
            $0.name ?? "" > $1.name ?? ""
        }
    }
}
