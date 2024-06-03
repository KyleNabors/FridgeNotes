//
//  KeyboardResponder.swift
//  RecipeBox
//
//  Created by Kyle Nabors on 6/2/24.
//

import SwiftUI
import Combine

final class KeyboardResponder: ObservableObject {
    @Published var isKeyboardVisible: Bool = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .merge(with: NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification))
            .sink { [weak self] notification in
                guard let self = self else { return }
                self.isKeyboardVisible = notification.name == UIResponder.keyboardWillShowNotification
            }
            .store(in: &cancellables)
    }
}
