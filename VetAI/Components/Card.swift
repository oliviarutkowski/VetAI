import SwiftUI

/// A reusable container view that applies the app's card styling.
///
/// Usage:
/// ```swift
/// Card {
///     VStack { ... }
/// }
/// ```
struct Card<Content: View>: View {
    /// The content displayed inside the card.
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.l)
            .background(Palette.surface)
            .cornerRadius(Radius.card)
            .shadow(color: Shadow.card, radius: 12, x: 0, y: 6)
    }
}

