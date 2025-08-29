import SwiftUI

    struct PrimaryButtonStyle: ButtonStyle {
        @Environment(\.colorScheme) private var colorScheme

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(Typography.body)
                .padding(.vertical, Spacing.sm)
                .padding(.horizontal, Spacing.md)
                .foregroundColor(Color.white)
                .background(Palette.primary)
                .cornerRadius(Radius.button)
                .shadow(color: shadowColor, radius: Shadow.radius, x: Shadow.x, y: Shadow.y)
                .scaleEffect(configuration.isPressed ? 0.98 : 1)
                .opacity(configuration.isPressed ? 0.9 : 1)
        }

        private var shadowColor: Color {
            colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.2)
        }
    }
