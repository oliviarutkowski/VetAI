import SwiftUI

struct Card: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(
                Color(light: Palette.surface, dark: Palette.surfaceAlt)
            )
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func card() -> some View {
        modifier(Card())
    }
}
