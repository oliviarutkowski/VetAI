import SwiftUI

    struct PrimaryButtonStyle: ButtonStyle {
        @Environment(\.colorScheme) private var colorScheme

        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .font(Typography.body)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .foregroundColor(.white)
                .background(
                    Palette.primary.opacity(configuration.isPressed ? 0.9 : 1)
                )
                .cornerRadius(12)
                .shadow(color: shadowColor, radius: 2, x: 0, y: 2)
        }

        private var shadowColor: Color {
            colorScheme == .dark ? Color.white.opacity(0.15) : Color.black.opacity(0.2)
        }
    }
