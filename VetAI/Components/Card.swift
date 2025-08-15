import SwiftUI

struct Card: ViewModifier {
    @Environment(\.colorScheme) private var colorScheme

    func body(content: Content) -> some View {
        content
            .background(
                Color(light: Palette.surface, dark: Palette.surfaceAlt)
            )
            .cornerRadius(16)
            .shadow(color: shadowColor, radius: 4, x: 0, y: 2)
    }

    private var shadowColor: Color {
        colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.1)
    }
}

extension View {
    func card() -> some View {
        modifier(Card())
    }
}
